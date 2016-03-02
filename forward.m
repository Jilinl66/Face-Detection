function [] = forward(AXES1,AXES2)

%% 申明全局变量
global imageGather;
global i;
global maxIndex;

global RSimageGather;
global RSi;
global RSmaxIndex;

%% 浏览原始图片
if mod(i, maxIndex) == 0
    i = 1;
else
i = i + 1;
end
axes(AXES1);
imshow(imageGather{i});

%% 浏览结果图片
if mod(RSi, RSmaxIndex) == 0
    RSi = 1;
else
RSi = RSi + 1;
end
axes(AXES2);
imshow(RSimageGather{RSi});