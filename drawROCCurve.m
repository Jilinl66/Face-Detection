function [] = drawROCCurve()

%% 加载统计表
load('table.mat');

%% 绘制ROC曲线
[p, ~, mu] = polyfit(FalsePositivesNum_Array, DetectionRate_Array, 3);

FalsePositivesNum_Array1 = 0: 0.1: 70;
f = polyval(p,FalsePositivesNum_Array1, [], mu);

figure('Name', 'ROC curve for face detection', 'NumberTitle', 'off');
plot(FalsePositivesNum_Array, DetectionRate_Array,'*')
hold on
plot(FalsePositivesNum_Array1, f)

%% 对图进行标注
title('ROC curve')
xlabel('false positives')
ylabel('detection rate')
grid on;
axis([-10 70 0.75 1])