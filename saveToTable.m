function []=saveToTable(GroupNo)

%% 定义全局变量
global FalsePositivesNum
global DetectionRate
if GroupNo == 1
else
    load('table.mat');
end

%% 定义两个数组来存放统计数据
FalsePositivesNum_Array(GroupNo) = FalsePositivesNum;
DetectionRate_Array(GroupNo) = DetectionRate;
save('table.mat', 'FalsePositivesNum_Array', 'DetectionRate_Array');