function [] = faceDetection_MultipleImages(mergeThreshold, scaleFactor, data, saveFolder)

%% ����ȫ�ֱ�������ʼ��
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

%% ����ȫ�ֱ���
global displayFrame
global bboxes % M-by-4 ����
global rowBboxes

%% ʵ�������������
faceDetector = vision.CascadeObjectDetector();
faceDetector.MergeThreshold = mergeThreshold;
faceDetector.ScaleFactor = scaleFactor;

%% ��һ����ͼƬ
mywait = waitbar(0,'Please wait...');
for i = 1:maxIndex    
     x = ['Processing image', num2str(i),' ...'];
     disp(x);
     
%% �� Viola-Jones �㷨���м��
    frameSize = size(imageGather{i, 1});
    if numel(frameSize) > 2
        frame = rgb2gray(imageGather{i, 1});
    else
        frame = imageGather{i, 1};
    end
    bboxes = faceDetector.step(frame); % BBOX = step(detector,I)������ͼ��I��ִ��������

%% ���� DetectionNum
	if ~isempty(bboxes)
        [rowBboxes,colBboxes] = size(bboxes);
        DetectionNum = DetectionNum + rowBboxes;
	end
    
%% ��Ǽ��İ󶨿�ͱ�׼����
    flag = zeros(1, rowBboxes); % �ж��Ƿ����ı�־��	
    displayFrame = imageGather{i, 1};
    
    % ���ر�׼������
    if ~isempty(data)
        load(data); 
        [rowData,colData] = size(Data);
        TotalLabeledFrontalFaces = rowData;     
        for ii = 1 : rowData
            isInBox = false; % �ж����Ƿ�©��ı�־��
            if strcmpi(Data.FileName(ii),imageGather{i, 2}) % Data1��table
                Face = Data(ii, 2:13); 
                Face = table2array(Face);
                X = Face(1:2:11);
                Y = Face(2:2:12);
                X = X';
                Y = Y';
                Point = [X, Y];
                displayFrame = insertMarker(displayFrame, Point);
                
                % �жϵ�����׼�������Ƿ��ڼ�����
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
                    
                    % ���©������
                    if isInBox == false
                        drawFalNeg(Point);
                    end                   
                else
                    drawFalNeg(Point);
                    imwrite(displayFrame, [saveFolder, '/resultImage-', sprintf('%03d', i), '.jpg']) % �����ļ������Ϊ3λ������λ������ǰ�油0;sprintf��'��ʽ'��i����i����Ϊ��Ҫ��ʽ���ַ�
                end
            end
        end
        
        % ��Ǽ���������
        if ~isempty(bboxes)  
        markFace(flag);   
        end
        imwrite(displayFrame,[saveFolder, '/resultImage-', sprintf('%03d',i), '.jpg']) % �����ļ������Ϊ3λ������λ������ǰ�油0;sprintf��'��ʽ'��i����i����Ϊ��Ҫ��ʽ���ַ�
    else
        markFaceCommon();  % δ�����׼��������ֱ�ӱ������
        imwrite(displayFrame, [saveFolder, '/resultImage-', sprintf('%03d',i), '.jpg'])
    end

%% ��ӽ�����
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
%% ����©��������
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
%% �궨�б�׼����������µ�������
global displayFrame
global bboxes
global rowBboxes
for i = 1 : rowBboxes
    box = bboxes(i,:);
    if flag(i) == 1 % flag ��һ��һά����
        displayFrame = insertObjectAnnotation(displayFrame, 'rectangle', box,...
            num2str(i), 'Color', 'green', 'TextBoxOpacity', 1);
    else
        displayFrame = insertObjectAnnotation(displayFrame, 'rectangle', box, ...
            strcat(num2str(i), 'FPos'), 'Color', 'red', 'TextBoxOpacity', 1);
    end
end


function markFaceCommon()
%% �궨�ޱ�׼����������µ�������
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