%% 检测单张图片中的人脸
function [] = faceDetection_SingleImage(AXES, mergeThreshold, scaleFactor, data, saveFolder)
%% 申明全局变量，初始化
global CorrectDetectionNum
global DetectionNum
global TotalLabeledFrontalFaces
global TotalImages
CorrectDetectionNum = 0;
TotalImages = 1;
global src_img

%% 定义全局变量
global displayFrame
global bboxes % M * 4 的数组
global rowBboxes

%% 实例化人脸检测器
faceDetector = vision.CascadeObjectDetector(); % Finds faces by default
faceDetector.MergeThreshold = mergeThreshold;
faceDetector.ScaleFactor = scaleFactor;

%% 用 Viola-Jones 算法进行检测
disp('Processing Image ...');
frameSize = size(src_img);
if numel(frameSize)>2 % 数组的个数等于3，则是RGB图像；等于2是gray图像
    frame = rgb2gray(src_img);
else
    frame = src_img;
end
    bboxes = faceDetector.step(frame);


%% 计算 DetectionNum,设置 flag
if ~isempty(bboxes)
	[rowBboxes,colBboxes] = size(bboxes); % bboxes是 rowBboxes by 4的矩阵
 	DetectionNum = rowBboxes;
end
flag = zeros(1,rowBboxes);% 判断是否误检的标志量
    
%% 标记检测的绑定框和标准人脸
	displayFrame = src_img;
    % Load standard face set
if ~isempty(data)
    load(data);  
   	[rowData,colData] = size(Data);
 	TotalLabeledFrontalFaces = rowData;
   	for ii = 1:rowData
        isInBox = false; % 判断脸是否漏检的标志量
        Face = Data(ii,2:13); 
    	Face = table2array(Face);
        X = Face(1:2:11);
        Y = Face(2:2:12);
        X = X';
        Y = Y';
        Point = [X,Y];
        displayFrame = insertMarker(displayFrame,Point); % 标记标准人脸
        
        % 判断单个标准人脸点是否在检测框内
        if ~isempty(bboxes)
            for b = 1:rowBboxes
                x0 = bboxes(b,1);
                y0 = bboxes(b,2);
                length = bboxes(b,3);
                width = bboxes(b,4);
                x = [x0 x0+length x0+length x0 x0];
                y = [y0 y0 y0+width y0+length y0];
                in = inpolygon(X,Y,x,y);
                if isequal(in,[1;1;1;1;1;1])
                    CorrectDetectionNum = CorrectDetectionNum+1;
                    flag(b) = 1;
                    isInBox = true;
                    break;                   
                end
             end
             % Draw false negtive faces
             if isInBox == false
             	drawFalNeg(Point);
             end              
        else
        % 若未检测出任何人脸
        	drawFalNeg(Point);
            axes(AXES);
            imshow(displayFrame);
            imwrite(displayFrame,['/Users/apple/STUDY/Graduate Design/Single_Image','/resultImage','.jpg'])
        end
    end
   % 框出人脸，包括正确检测的和误检测的人脸
    markFace(flag);
    axes(AXES);
    imshow(displayFrame);
    imwrite(displayFrame,[saveFolder,'/resultImage','.jpg'])
else
% 未导入标准人脸集，直接标记人脸
    markFaceCommon();  
    axes(AXES);
    imshow(displayFrame);
    imwrite(displayFrame,[saveFolder,'/resultImage','.jpg'])
end


function drawFalNeg(point)
%% 绘制漏检人脸框
global displayFrame
    X = point(:,1);
    Y = point(:,2);
    left = min(X);
    right = max(X);
    botton = min(Y);
    top = max(Y);
    box = [left-(right-left)/2 botton-(top-botton)/2 (right-left)*2.5 (top-botton)*2.5];
    displayFrame = insertObjectAnnotation(displayFrame, 'rectangle',box,'FNeg','Color','blue');


function markFace(flag)
%% 标定有标准人脸集情况下的人脸框
global bboxes
global rowBboxes
global displayFrame
for i = 1:rowBboxes
    box = bboxes(i,:);
    if flag(i) == 1 % flag 是一维数组，数组个数即为一幅图片中检测出的人脸数
        displayFrame = insertObjectAnnotation(displayFrame, 'rectangle',box,num2str(i),'Color','green');
    else
        displayFrame = insertObjectAnnotation(displayFrame, 'rectangle',box,strcat(num2str(i),'FPos'),'Color','red');

    end
end


function markFaceCommon()
%% 标定无标准人脸集情况下的人脸框
global bboxes
global rowBboxes
global displayFrame
if ~isempty(bboxes)
    for i = 1:rowBboxes
    box = bboxes(i,:);
    displayFrame = insertObjectAnnotation(displayFrame, 'rectangle',box,num2str(i),'Color','green');
    end
end

