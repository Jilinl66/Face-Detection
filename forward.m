function [] = forward(AXES1,AXES2)

%% ����ȫ�ֱ���
global imageGather;
global i;
global maxIndex;

global RSimageGather;
global RSi;
global RSmaxIndex;

%% ���ԭʼͼƬ
if mod(i, maxIndex) == 0
    i = 1;
else
i = i + 1;
end
axes(AXES1);
imshow(imageGather{i});

%% ������ͼƬ
if mod(RSi, RSmaxIndex) == 0
    RSi = 1;
else
RSi = RSi + 1;
end
axes(AXES2);
imshow(RSimageGather{RSi});