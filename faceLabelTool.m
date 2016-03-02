function [] = faceLabelTool(filename)

global imageSet
i = 0; % 标记图片总数
j = 0; % 统计所有图片中的人脸总数
directoryname = uigetdir('', '请选择图片文件夹'); % uigetdir函数可以浏览选择文件夹
addpath(directoryname);
imgstr = dir(directoryname); % imgstr是一个结构体数组，包含文件夹内所有文件
row = numel(imgstr);
variableNames = {'filename', 'VarName2', 'VarName3', 'VarName4', 'VarName5', 'VarName6',...
    'VarName7', 'VarName8', 'VarName9', 'VarName10', 'VarName11', 'VarName12', 'VarName13'};
f = figure; % 新建图层，将待标记图片显示在figure中

% 文件夹的过滤,只保留图像文件
for x = 1:row
    if imgstr(x).isdir == 1
    else if ~isempty(strfind(imgstr(x).name, '.jpg')) || ~isempty(strfind(imgstr(x).name, '.bmp'))...
                || ~isempty(strfind(imgstr(x).name, '.gif')) || ~isempty(strfind(imgstr(x).name, '.png'))
            i = i + 1;
            if numel(size(imread(imgstr(x).name))) > 2
                imageSet{i, 1} = imread(imgstr(x).name);
                imageSet{i, 2} = imgstr(x).name;
            else
                [I, map] = imread(imgstr(x).name); % 索引映射图像转化为灰度（亮度）图像
                I2 = ind2gray(I, map);
                imageSet{i, 1} = I2;
                imageSet{i, 2} = imgstr(x).name;
            end
            
            % 逐一图片标记标准人脸
            imshow(imageSet{i, 1});                     
            while(1)
                zoom on;
                pause(3.0);
                j = j + 1;
                [X, Y, BOTTON] = ginput(6);
                zoom off;
                Cell(j, :) = {imageSet{i, 2} X(1) Y(1) X(2) Y(2) X(3) Y(3) X(4) Y(4) X(5) Y(5) X(6) Y(6)};
                if BOTTON(6) == 3 % 1:鼠标左键, 2:鼠标中间键, 3:鼠标右键
                    break;
                end
            end       
        end
    end
end

% 保存创建的标准人脸集
Data = cell2table(Cell, 'VariableNames', variableNames);
save(filename, 'Data');