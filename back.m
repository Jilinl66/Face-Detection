function [] = back(AXES1,AXES2)

%% 申明全局变量
global imageGather;
global i;
global maxIndex;

global RSimageGather;
global RSi;
global RSmaxIndex;

%% 浏览原始图片
if i == 1
    i = maxIndex;
else
i = i - 1;
end
axes(AXES1);
imshow(imageGather{i});

%% 浏览结果图片
if RSi == 1
    RSi = RSmaxIndex;
else
RSi = RSi - 1;
end
axes(AXES2);
imshow(RSimageGather{RSi});