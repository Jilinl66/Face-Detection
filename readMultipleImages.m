% ������ȡͼƬ
function [] = readMultipleImages(AXES)

%% ����ȫ�ֱ���
global imageGather
global maxIndex
global i

%% uigetdir�������ѡ���ļ���
directoryname = uigetdir('','��ѡ��ͼƬ�ļ���');
if isequal(directoryname,0)
    disp('Users Selected Canceled');
else
    addpath(directoryname);
    imgstr = dir(directoryname); % imgstr��һ���ṹ�����飬�����ļ����������ļ�
    row = numel(imgstr);
end

%% �ļ��еĹ���,ֻ����ͼ���ļ�
i = 0;
mywait = waitbar(0,'Please wait...');
for x = 1:row
    if imgstr(x).isdir == 1
    else if ~isempty(strfind(imgstr(x).name,'.jpg'))||~isempty(strfind(imgstr(x).name,'.bmp'))...
                ||~isempty(strfind(imgstr(x).name,'.gif'))||~isempty(strfind(imgstr(x).name,'.png'))
            i = i + 1;
            if numel(size(imread(imgstr(x).name))) > 2
                imageGather{i, 1} = imread(imgstr(x).name);
                imageGather{i, 2} = imgstr(x).name;
            else
                [I, map] = imread(imgstr(x).name); % ����ӳ��ͼ��ת��Ϊ�Ҷȣ����ȣ�ͼ��
                I2 = ind2gray(I, map);
                imageGather{i, 1} = I2;
                imageGather{i, 2} = imgstr(x).name;
            end
         end       
    end
    
%% ��ӽ�����
    if row-x <= 1
        waitbar(x/row, mywait, 'Completing...');
        pause(0.05);
    else
        str = ['Loading ', num2str(round(100*x/row)), '%'];
        waitbar(x/row, mywait, str);
        pause(0.05);
    end 
end

close(mywait);
axes(AXES);
imshow(imageGather{1, 1});
maxIndex = i;
i = 1;