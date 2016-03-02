function [] = readResults(AXES)

global imageGather;
global RSi;
global RSmaxIndex;
directoryname = uigetdir('', '��ѡ��ͼƬ�ļ���'); % uigetdir�����������ѡ���ļ���
addpath(directoryname);
imgstr = dir(directoryname);
row = numel(imgstr);

% �ļ��еĹ���,ֻ����ͼ���ļ�
RSi = 0;
mywait = waitbar(0,'Please wait...');
for i = 1:row
    if imgstr(i).isdir == 1
    else if ~isempty(strfind(imgstr(i).name, '.jpg')) || ~isempty(strfind(imgstr(i).name,'.bmp'))...
                || ~isempty(strfind(imgstr(i).name,'.gif')) || ~isempty(strfind(imgstr(i).name,'.png'))
            RSi = RSi + 1;
            if numel(size(imread(imgstr(i).name)))>2
                imageGather{RSi} = imread(imgstr(i).name);
            else
                [I,map] = imread(imgstr(i).name); % ����ӳ��ͼ��ת��Ϊ�Ҷȣ����ȣ�ͼ��
                I2 = ind2gray(I, map);
                imageGather{RSi} = I2;
            end
         end       
    end
    
%% ��ӽ�����
    if row-i <= 1
        waitbar(i/row,mywait, 'Completing...');
        pause(0.05);
    else
        str = ['Loading ', num2str(round(100*i/row)), '%'];
        waitbar(i/row, mywait, str);
        pause(0.05);
    end 
end
close(mywait);
axes(AXES);
imshow(imageGather{1});
RSmaxIndex = RSi;
RSi = 1;