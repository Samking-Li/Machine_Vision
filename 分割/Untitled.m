close all;
clear all;
clc;

% %读取图像
data = imread('lena.jpg');
%显示原始图像
figure(1);
imshow(data),title('原始图像');
%判断读取图像是否是灰度图
[o,j,p]=size(data);
if p==3
    %显示三通道图像
    %将彩色图像转为灰度图
    data = rgb2gray(data);
else   
end

Img_roberts = edge(data,'roberts');  %reberts
Img_sobel=edge(data,'sobel');  %sobel
Img_kir=kirsch(data);
Img_lap=laplace(data,0.3);  %laplace
figure(2)
subplot(221);imshow(Img_roberts),title('roberts算子');
subplot(222);imshow(Img_sobel),title('sobel算子');
subplot(223);imshow(Img_kir);title('基尔希算子');
subplot(224);imshow(Img_lap);title('拉普拉斯算子');

Img_RS=edge_search(data,60);
figure(3)
imshow(Img_RS,[]),title('光栅扫描');

Img_IHT=IHT(data);
figure(4)
imshow(Img_IHT),title('迭代阈值法');

Img_grow=grow(data);
figure(5)
imshow(Img_grow),title('质心生长法');