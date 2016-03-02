function [] = setEdits(edit1, edit2, edit3, edit4, edit5)

%% 定义全局变量
global CorrectDetectionNum
global DetectionNum
global TotalLabeledFrontalFaces
global TotalImages
global FalsePositivesNum
global DetectionRate

%% 计算参数
FalsePositivesNum = DetectionNum - CorrectDetectionNum;
DetectionRate = CorrectDetectionNum / TotalLabeledFrontalFaces;
set(edit1, 'String', FalsePositivesNum);
set(edit2, 'String', CorrectDetectionNum);
set(edit3, 'String', DetectionRate);
set(edit4, 'String', TotalLabeledFrontalFaces);
set(edit5, 'String', TotalImages);