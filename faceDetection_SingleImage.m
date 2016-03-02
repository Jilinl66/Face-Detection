%% ��ⵥ��ͼƬ�е�����
function [] = faceDetection_SingleImage(AXES, mergeThreshold, scaleFactor, data, saveFolder)
%% ����ȫ�ֱ�������ʼ��
global CorrectDetectionNum
global DetectionNum
global TotalLabeledFrontalFaces
global TotalImages
CorrectDetectionNum = 0;
TotalImages = 1;
global src_img

%% ����ȫ�ֱ���
global displayFrame
global bboxes % M * 4 ������
global rowBboxes

%% ʵ�������������
faceDetector = vision.CascadeObjectDetector(); % Finds faces by default
faceDetector.MergeThreshold = mergeThreshold;
faceDetector.ScaleFactor = scaleFactor;

%% �� Viola-Jones �㷨���м��
disp('Processing Image ...');
frameSize = size(src_img);
if numel(frameSize)>2 % ����ĸ�������3������RGBͼ�񣻵���2��grayͼ��
    frame = rgb2gray(src_img);
else
    frame = src_img;
end
    bboxes = faceDetector.step(frame);


%% ���� DetectionNum,���� flag
if ~isempty(bboxes)
	[rowBboxes,colBboxes] = size(bboxes); % bboxes�� rowBboxes by 4�ľ���
 	DetectionNum = rowBboxes;
end
flag = zeros(1,rowBboxes);% �ж��Ƿ����ı�־��
    
%% ��Ǽ��İ󶨿�ͱ�׼����
	displayFrame = src_img;
    % Load standard face set
if ~isempty(data)
    load(data);  
   	[rowData,colData] = size(Data);
 	TotalLabeledFrontalFaces = rowData;
   	for ii = 1:rowData
        isInBox = false; % �ж����Ƿ�©��ı�־��
        Face = Data(ii,2:13); 
    	Face = table2array(Face);
        X = Face(1:2:11);
        Y = Face(2:2:12);
        X = X';
        Y = Y';
        Point = [X,Y];
        displayFrame = insertMarker(displayFrame,Point); % ��Ǳ�׼����
        
        % �жϵ�����׼�������Ƿ��ڼ�����
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
        % ��δ�����κ�����
        	drawFalNeg(Point);
            axes(AXES);
            imshow(displayFrame);
            imwrite(displayFrame,['/Users/apple/STUDY/Graduate Design/Single_Image','/resultImage','.jpg'])
        end
    end
   % ���������������ȷ���ĺ����������
    markFace(flag);
    axes(AXES);
    imshow(displayFrame);
    imwrite(displayFrame,[saveFolder,'/resultImage','.jpg'])
else
% δ�����׼��������ֱ�ӱ������
    markFaceCommon();  
    axes(AXES);
    imshow(displayFrame);
    imwrite(displayFrame,[saveFolder,'/resultImage','.jpg'])
end


function drawFalNeg(point)
%% ����©��������
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
%% �궨�б�׼����������µ�������
global bboxes
global rowBboxes
global displayFrame
for i = 1:rowBboxes
    box = bboxes(i,:);
    if flag(i) == 1 % flag ��һά���飬���������Ϊһ��ͼƬ�м�����������
        displayFrame = insertObjectAnnotation(displayFrame, 'rectangle',box,num2str(i),'Color','green');
    else
        displayFrame = insertObjectAnnotation(displayFrame, 'rectangle',box,strcat(num2str(i),'FPos'),'Color','red');

    end
end


function markFaceCommon()
%% �궨�ޱ�׼����������µ�������
global bboxes
global rowBboxes
global displayFrame
if ~isempty(bboxes)
    for i = 1:rowBboxes
    box = bboxes(i,:);
    displayFrame = insertObjectAnnotation(displayFrame, 'rectangle',box,num2str(i),'Color','green');
    end
end

