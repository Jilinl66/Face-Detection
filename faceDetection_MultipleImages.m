function [] = faceDetection_MultipleImages(mergeThreshold, scaleFactor, data, saveFolder)

%% 申明全局变量，初始化
global imageGather
global maxIndex
global CorrectDetectionNum
global DetectionNum
global TotalLabeledFrontalFaces
global TotalImages
CorrectDetectionNum = 0;
DetectionNum = 0;
TotalLabeledFrontalFaces = 0;
TotalImages = maxIndex;

%% 定义全局变量
global displayFrame
global bboxes % M-by-4 数组
global rowBboxes

%% 实例化人脸检测器
faceDetector = vision.CascadeObjectDetector();
faceDetector.MergeThreshold = mergeThreshold;
faceDetector.ScaleFactor = scaleFactor;

%% 逐一处理图片
mywait = waitbar(0,'Please wait...');
for i = 1:maxIndex    
     x = ['Processing image', num2str(i),' ...'];
     disp(x);
     
%% 用 Viola-Jones 算法进行检测
    frameSize = size(imageGather{i, 1});
    if numel(frameSize) > 2
        frame = rgb2gray(imageGather{i, 1});
    else
        frame = imageGather{i, 1};
    end
    bboxes = faceDetector.step(frame); % BBOX = step(detector,I)在输入图像I上执行物体检测

%% 计算 DetectionNum
	if ~isempty(bboxes)
        [rowBboxes,colBboxes] = size(bboxes);
        DetectionNum = DetectionNum + rowBboxes;
	end
    
%% 标记检测的绑定框和标准人脸
    flag = zeros(1, rowBboxes); % 判断是否误检的标志量	
    displayFrame = imageGather{i, 1};
    
    % 加载标准人脸集
    if ~isempty(data)
        load(data); 
        [rowData,colData] = size(Data);
        TotalLabeledFrontalFaces = rowData;     
        for ii = 1 : rowData
            isInBox = false; % 判断脸是否漏检的标志量
            if strcmpi(Data.FileName(ii),imageGather{i, 2}) % Data1是table
                Face = Data(ii, 2:13); 
                Face = table2array(Face);
                X = Face(1:2:11);
                Y = Face(2:2:12);
                X = X';
                Y = Y';
                Point = [X, Y];
                displayFrame = insertMarker(displayFrame, Point);
                
                % 判断单个标准人脸点是否在检测框内
                if ~isempty(bboxes)   
                    for b = 1:rowBboxes
                        x0 = bboxes(b,1);
                        y0 = bboxes(b,2);
                        length = bboxes(b,3);
                        width = bboxes(b,4);
                        x = [ x0 x0+length x0+length x0 x0 ];
                        y = [ y0 y0 y0+width y0+length y0 ];
                        in = inpolygon(X, Y, x, y);
                        if isequal(in, [1; 1; 1; 1; 1; 1])
                            CorrectDetectionNum = CorrectDetectionNum + 1;
                            flag(b) = 1;
                            isInBox = true;
                            break;
                        end
                    end
                    
                    % 框出漏检人脸
                    if isInBox == false
                        drawFalNeg(Point);
                    end                   
                else
                    drawFalNeg(Point);
                    imwrite(displayFrame, [saveFolder, '/resultImage-', sprintf('%03d', i), '.jpg']) % 保存文件名序号为3位数，如位数不足前面补0;sprintf（'格式'，i）将i保存为需要格式的字符
                end
            end
        end
        
        % 标记检测出的人脸
        if ~isempty(bboxes)  
        markFace(flag);   
        end
        imwrite(displayFrame,[saveFolder, '/resultImage-', sprintf('%03d',i), '.jpg']) % 保存文件名序号为3位数，如位数不足前面补0;sprintf（'格式'，i）将i保存为需要格式的字符
    else
        markFaceCommon();  % 未导入标准人脸集，直接标记人脸
        imwrite(displayFrame, [saveFolder, '/resultImage-', sprintf('%03d',i), '.jpg'])
    end

%% 添加进度条
    if maxIndex-i <= 1
        waitbar(i/maxIndex, mywait, 'Completing...');
        pause(0.05);
    else
        str = ['Processing', num2str(round(100*i/maxIndex)), '%'];
        waitbar(i/maxIndex, mywait, str);
        pause(0.05);
    end
end
close(mywait);


function drawFalNeg(points)
%% 绘制漏检人脸框
global displayFrame
    X = points(:, 1);
    Y = points(:, 2);
    left = min(X);
    right = max(X);
    botton = min(Y);
    top = max(Y);
    box = [left-(right-left) / 2 botton-(top-botton) / 2 (right-left) * 2.5 (top-botton) * 2.5];
    displayFrame = insertObjectAnnotation(displayFrame, 'rectangle', box, 'FNeg',...
        'Color', 'blue', 'TextBoxOpacity', 1);
    
    
function markFace(flag)
%% 标定有标准人脸集情况下的人脸框
global displayFrame
global bboxes
global rowBboxes
for i = 1 : rowBboxes
    box = bboxes(i,:);
    if flag(i) == 1 % flag 是一个一维数组
        displayFrame = insertObjectAnnotation(displayFrame, 'rectangle', box,...
            num2str(i), 'Color', 'green', 'TextBoxOpacity', 1);
    else
        displayFrame = insertObjectAnnotation(displayFrame, 'rectangle', box, ...
            strcat(num2str(i), 'FPos'), 'Color', 'red', 'TextBoxOpacity', 1);
    end
end


function markFaceCommon()
%% 标定无标准人脸集情况下的人脸框
global bboxes
global rowBboxes
global displayFrame
if ~isempty(bboxes)
    for i = 1 : rowBboxes
    box = bboxes(i, :);
    displayFrame = insertObjectAnnotation(displayFrame, 'rectangle', box,...
        num2str(i), 'Color', 'green');
    end
end