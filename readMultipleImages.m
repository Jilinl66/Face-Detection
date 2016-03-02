% 批量读取图片
function [] = readMultipleImages(AXES)

%% 定义全局变量
global imageGather
global maxIndex
global i

%% uigetdir函数浏览选择文件夹
directoryname = uigetdir('','请选择图片文件夹');
if isequal(directoryname,0)
    disp('Users Selected Canceled');
else
    addpath(directoryname);
    imgstr = dir(directoryname); % imgstr是一个结构体数组，包含文件夹内所有文件
    row = numel(imgstr);
end

%% 文件夹的过滤,只保留图像文件
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
                [I, map] = imread(imgstr(x).name); % 索引映射图像转化为灰度（亮度）图像
                I2 = ind2gray(I, map);
                imageGather{i, 1} = I2;
                imageGather{i, 2} = imgstr(x).name;
            end
         end       
    end
    
%% 添加进度条
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