function [] = showResults(path, AXES)

%% ����ȫ�ֱ���
global RSimageGather;
global RSi;
global RSmaxIndex;

%% ����ȫ�ֱ���
global maxIndex;

%% ����cell���飬��һ����ļ����е��ļ�
RSimageGather = cell(maxIndex, 1);
for RSi = 1 : maxIndex
    imageName = strcat(path, '/resultImage-', sprintf('%03d', RSi), '.jpg'); % Convert number to string
    RSimageGather{RSi} = imread(imageName); % cell():ָ����Ԫ��Ԫ��,����[]����cell{}:ָԪ��Ԫ���е�ֵ
end
axes(AXES);
imshow(RSimageGather{1});
RSmaxIndex = maxIndex;
RSi = 1;