function []=saveToTable(GroupNo)

%% ����ȫ�ֱ���
global FalsePositivesNum
global DetectionRate
if GroupNo == 1
else
    load('table.mat');
end

%% �����������������ͳ������
FalsePositivesNum_Array(GroupNo) = FalsePositivesNum;
DetectionRate_Array(GroupNo) = DetectionRate;
save('table.mat', 'FalsePositivesNum_Array', 'DetectionRate_Array');