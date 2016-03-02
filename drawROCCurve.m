function [] = drawROCCurve()

%% ����ͳ�Ʊ�
load('table.mat');

%% ����ROC����
[p, ~, mu] = polyfit(FalsePositivesNum_Array, DetectionRate_Array, 3);

FalsePositivesNum_Array1 = 0: 0.1: 70;
f = polyval(p,FalsePositivesNum_Array1, [], mu);

figure('Name', 'ROC curve for face detection', 'NumberTitle', 'off');
plot(FalsePositivesNum_Array, DetectionRate_Array,'*')
hold on
plot(FalsePositivesNum_Array1, f)

%% ��ͼ���б�ע
title('ROC curve')
xlabel('false positives')
ylabel('detection rate')
grid on;
axis([-10 70 0.75 1])