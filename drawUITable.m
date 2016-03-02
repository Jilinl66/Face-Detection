function [] = drawUITable()

%% 加载表的相关参数
load('table.mat');
f = figure('Name','DetectionRates-FalsePositivesNum on test set', 'NumberTitle', 'off');
rownames = {'False Positives', 'Correct Detection Rate'};
colnames = {'Group1', 'Group2', 'Group3', 'Group4', 'Group5', 'Group6',...
    'Group7', 'Group8', 'Average'}; % 最多可获得8组测试数据

%% 计算误检数和检测率的平均值
col1 = numel(FalsePositivesNum_Array);
sum1 = 0;
for i = 1:col1
    sum1 = sum1+FalsePositivesNum_Array(i);
    ave1 = sum1/col1;
end
FalsePositivesNum_Array(9) = ave1;

col2 = numel(DetectionRate_Array);
sum2 = 0;
for i = 1:col2
    sum2 = sum2+DetectionRate_Array(i);
    ave2 = sum2/col2;
end
DetectionRate_Array(9) = ave2;

%% 绘制uitable
data = [FalsePositivesNum_Array; DetectionRate_Array];
table = uitable(f, 'Data', data, 'RowName', rownames, 'ColumnName', ...
    colnames, 'Position',[60 220 600 70],'FontSize',14);
table.Position(3) = table.Extent(3);
table.Position(4) = table.Extent(4);