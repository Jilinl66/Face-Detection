function [] = faceLabelTool(filename)

global imageSet
i = 0; % ���ͼƬ����
j = 0; % ͳ������ͼƬ�е���������
directoryname = uigetdir('', '��ѡ��ͼƬ�ļ���'); % uigetdir�����������ѡ���ļ���
addpath(directoryname);
imgstr = dir(directoryname); % imgstr��һ���ṹ�����飬�����ļ����������ļ�
row = numel(imgstr);
variableNames = {'filename', 'VarName2', 'VarName3', 'VarName4', 'VarName5', 'VarName6',...
    'VarName7', 'VarName8', 'VarName9', 'VarName10', 'VarName11', 'VarName12', 'VarName13'};
f = figure; % �½�ͼ�㣬�������ͼƬ��ʾ��figure��

% �ļ��еĹ���,ֻ����ͼ���ļ�
for x = 1:row
    if imgstr(x).isdir == 1
    else if ~isempty(strfind(imgstr(x).name, '.jpg')) || ~isempty(strfind(imgstr(x).name, '.bmp'))...
                || ~isempty(strfind(imgstr(x).name, '.gif')) || ~isempty(strfind(imgstr(x).name, '.png'))
            i = i + 1;
            if numel(size(imread(imgstr(x).name))) > 2
                imageSet{i, 1} = imread(imgstr(x).name);
                imageSet{i, 2} = imgstr(x).name;
            else
                [I, map] = imread(imgstr(x).name); % ����ӳ��ͼ��ת��Ϊ�Ҷȣ����ȣ�ͼ��
                I2 = ind2gray(I, map);
                imageSet{i, 1} = I2;
                imageSet{i, 2} = imgstr(x).name;
            end
            
            % ��һͼƬ��Ǳ�׼����
            imshow(imageSet{i, 1});                     
            while(1)
                zoom on;
                pause(3.0);
                j = j + 1;
                [X, Y, BOTTON] = ginput(6);
                zoom off;
                Cell(j, :) = {imageSet{i, 2} X(1) Y(1) X(2) Y(2) X(3) Y(3) X(4) Y(4) X(5) Y(5) X(6) Y(6)};
                if BOTTON(6) == 3 % 1:������, 2:����м��, 3:����Ҽ�
                    break;
                end
            end       
        end
    end
end

% ���洴���ı�׼������
Data = cell2table(Cell, 'VariableNames', variableNames);
save(filename, 'Data');