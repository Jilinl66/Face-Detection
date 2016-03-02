% 读入指定路径中的一张图片
function [] = readSingleImage(AXES)

global src_img   % 定义一个全局变量
[filename, pathname] = uigetfile({'*.*'; '*.jpg'; '*.bmp'; '*.tif'; '*.png'; '*.gif'}, 'select one image'); % 选择图片路径
if isequal(filename, 0)
    disp('Users Selected Canceled');
else
str = [pathname filename]; % 合成路径+文件名
src_img = imread(str);
    if numel(size(src_img)) > 2 % 数组的个数等于3,是RGB图像；等于2是gray图像
    else
        [I, map] = imread(str); % 索引映射图像转化为灰度（亮度）图像
        src_img = ind2gray(I, map);   
    end
axes(AXES); % 使用第一个axes,创建axes对象
imshow(src_img); % 显示图片
end