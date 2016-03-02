function [] = readResults(AXES)

global imageGather;
global RSi;
global RSmaxIndex;
directoryname = uigetdir('', '请选择图片文件夹'); % uigetdir函数可以浏览选择文件夹
addpath(directoryname);
imgstr = dir(directoryname);
row = numel(imgstr);

% 文件夹的过滤,只保留图像文件
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
                [I,map] = imread(imgstr(i).name); % 索引映射图像转化为灰度（亮度）图像
                I2 = ind2gray(I, map);
                imageGather{RSi} = I2;
            end
         end       
    end
    
%% 添加进度条
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