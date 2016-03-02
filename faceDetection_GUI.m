function varargout = faceDetection_GUI(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @faceDetection_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @faceDetection_GUI_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


function faceDetection_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;

% 在GUI创建时定义全局变量
global CorrectDetectionNum
global DetectionNum
global TotalLabeledFrontalFaces
global TotalImages
global FalsePositivesNum
global DetectionRate
CorrectDetectionNum = 0;
DetectionNum = 0;
TotalLabeledFrontalFaces= 0;
TotalImages = 0;
FalsePositivesNum = 0;
DetectionRate = 0;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes faceDetection_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


function varargout = faceDetection_GUI_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;


function selectSingleImage_Callback(hObject, eventdata, handles)
readSingleImage(handles.axes1);


function selectMultipleImages_Callback(hObject, eventdata, handles)
readMultipleImages(handles.axes1);


function faceDetection_SingleImage_Callback(hObject, eventdata, handles)
switch get(handles.selectAlgorithmPopupmenu, 'Value');
    case 1
        warndlg('Please select an algorithm!', 'Warning');
    case 2
        mergeThreshold=str2num(get(handles.edit6, 'string'));
        scaleFactor=str2num(get(handles.edit7, 'string'));  
        faceDetection_SingleImage(handles.axes2, mergeThreshold, scaleFactor,get(handles.edit9, 'string'), get(handles.edit10, 'string')); % 要将handles.axes2整个作为函数传递的变量
        setEdits(handles.edit1 ,handles.edit2, handles.edit3, handles.edit4, handles.edit5);
    otherwise
end


function faceDetection_MultipleImages_Callback(hObject, eventdata, handles)
global i
global imageGather
switch get(handles.selectAlgorithmPopupmenu, 'Value');
    case 1
        warndlg('Please select an algorithm!', 'Warning');
    case 2
        mergeThreshold = str2num(get(handles.edit6, 'string'));
        scaleFactor = str2num(get(handles.edit7, 'string'));     
        faceDetection_MultipleImages(mergeThreshold, scaleFactor, get(handles.edit9, 'string'), get(handles.edit10, 'string'));
        showResults(get(handles.edit10, 'string'), handles.axes2);
        axes(handles.axes1)
        imshow(imageGather{1, 1})
        i = 1;
        setEdits(handles.edit1, handles.edit2, handles.edit3, handles.edit4, handles.edit5);
        saveToTable(str2num(get(handles.edit8, 'string')));
    otherwise
end


function backOriginalImage_Callback(hObject, eventdata, handles)
back(handles.axes1, handles.axes2);

function forwardOriginalImage_Callback(hObject, eventdata, handles)
forward(handles.axes1, handles.axes2);


function backResultImage_Callback(hObject, eventdata, handles)
back(handles.axes1, handles.axes2);


function forwardResultImage_Callback(hObject, eventdata, handles)
forward(handles.axes1, handles.axes2);


function readResults_Callback(hObject, eventdata, handles)
readResults(handles.axes2);


function selectAlgorithmPopupmenu_Callback(hObject, eventdata, handles)

function selectAlgorithmPopupmenu_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject, 'BackgroundColor'), get(0, 'defaultUicontrolBackgroundColor'))
    set(hObject, 'BackgroundColor', 'white');
end


function drawROCCurve_Callback(hObject, eventdata, handles)
drawROCCurve();


function edit1_Callback(hObject, eventdata, handles)

function edit1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject, 'BackgroundColor'), get(0, 'defaultUicontrolBackgroundColor'))
    set(hObject, 'BackgroundColor', 'white');
end


function edit2_Callback(hObject, eventdata, handles)

function edit2_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject, 'BackgroundColor'), get(0, 'defaultUicontrolBackgroundColor'))
    set(hObject, 'BackgroundColor', 'white');
end



function edit3_Callback(hObject, eventdata, handles)

function edit3_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject, 'BackgroundColor'), get(0, 'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor', 'white');
end



function edit4_Callback(hObject, eventdata, handles)

function edit4_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject, 'BackgroundColor'), get(0, 'defaultUicontrolBackgroundColor'))
    set(hObject, 'BackgroundColor', 'white');
end



function edit5_Callback(hObject, eventdata, handles)

function edit5_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject, 'BackgroundColor'), get(0, 'defaultUicontrolBackgroundColor'))
    set(hObject, 'BackgroundColor', 'white');
end


function edit6_Callback(hObject, eventdata, handles)

function edit6_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit7_Callback(hObject, eventdata, handles)

function edit7_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit8_Callback(hObject, eventdata, handles)

function edit8_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function drawUITable_Callback(hObject, eventdata, handles)
drawUITable();


function selectImageSaveFolder_Callback(hObject, eventdata, handles)
path = uigetdir('','select folder');
if isequal(path, 0)
   disp('Users Selected Canceled');
else
    set(handles.edit10, 'string', path);
end


function selectStandardFaceSet_Callback(hObject, eventdata, handles)
[filename,pathname] = uigetfile({'*.*'; '*.mat'}, 'select standard face set'); %选择文件路径
if isequal(filename,0)
   disp('Users Selected Canceled');
else
    set(handles.edit9, 'string', filename);
end


function edit9_Callback(hObject, eventdata, handles)

function edit9_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit10_Callback(hObject, eventdata, handles)

function edit10_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit11_Callback(hObject, eventdata, handles)

function edit11_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function createStandardFaceSet_Callback(hObject, eventdata, handles)
faceLabelTool(get(handles.edit11, 'string'));


function zoomIn_Callback(hObject, eventdata, handles)
h = zoom;
set(h, 'Enable', 'on');


function zoomOff_Callback(hObject, eventdata, handles)
zoom out


function panOn_Callback(hObject, eventdata, handles)
ha = pan;
ha.Enable = 'on';


function panOff_Callback(hObject, eventdata, handles)
pan off
