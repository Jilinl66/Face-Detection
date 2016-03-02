% ����ָ��·���е�һ��ͼƬ
function [] = readSingleImage(AXES)

global src_img   % ����һ��ȫ�ֱ���
[filename, pathname] = uigetfile({'*.*'; '*.jpg'; '*.bmp'; '*.tif'; '*.png'; '*.gif'}, 'select one image'); % ѡ��ͼƬ·��
if isequal(filename, 0)
    disp('Users Selected Canceled');
else
str = [pathname filename]; % �ϳ�·��+�ļ���
src_img = imread(str);
    if numel(size(src_img)) > 2 % ����ĸ�������3,��RGBͼ�񣻵���2��grayͼ��
    else
        [I, map] = imread(str); % ����ӳ��ͼ��ת��Ϊ�Ҷȣ����ȣ�ͼ��
        src_img = ind2gray(I, map);   
    end
axes(AXES); % ʹ�õ�һ��axes,����axes����
imshow(src_img); % ��ʾͼƬ
end