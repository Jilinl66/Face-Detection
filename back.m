function [] = back(AXES1,AXES2)

%% ����ȫ�ֱ���
global imageGather;
global i;
global maxIndex;

global RSimageGather;
global RSi;
global RSmaxIndex;

%% ���ԭʼͼƬ
if i == 1
    i = maxIndex;
else
i = i - 1;
end
axes(AXES1);
imshow(imageGather{i});

%% ������ͼƬ
if RSi == 1
    RSi = RSmaxIndex;
else
RSi = RSi - 1;
end
axes(AXES2);
imshow(RSimageGather{RSi});