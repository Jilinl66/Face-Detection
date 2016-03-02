function [] = showResults(path, AXES)

%% 定义全局变量
global RSimageGather;
global RSi;
global RSmaxIndex;

%% 申明全局变量
global maxIndex;

%% 创建cell数组，逐一存放文件夹中的文件
RSimageGather = cell(maxIndex, 1);
for RSi = 1 : maxIndex
    imageName = strcat(path, '/resultImage-', sprintf('%03d', RSi), '.jpg'); % Convert number to string
    RSimageGather{RSi} = imread(imageName); % cell():指整个元组元素,型如[]，而cell{}:指元组元素中的值
end
axes(AXES);
imshow(RSimageGather{1});
RSmaxIndex = maxIndex;
RSi = 1;