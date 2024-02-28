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
%将灰度图像转换为二值图像

%将图像转化为双精度
% i = im2double(data);

se=strel('disk',6);   % 生成圆形结构元素
A1 = imdilate(data,se);   %   膨胀
A2 = imerode(data,se);    %   腐蚀
A3 = imopen(data,se);     %   开操作
A4 = imclose(data,se);    %   闭操作
figure(2);
subplot(231),imshow(data),title('二值图像');
subplot(232),imshow(A1),title('膨胀后的二值图像');
subplot(233),imshow(A2),title('腐蚀后的二值图像');
subplot(234),imshow(se.Neighborhood),title('结构元');
subplot(235),imshow(A3),title('开运算后的二值图像');
subplot(236),imshow(A4),title('闭运算后的二值图像');

A5 =data-imerode(data,se);  %边界提取：原图减去腐蚀后的图
% 图像填充
B0 = zeros(o,j);
B0(50, 150) = 1;
B1=imdilate(B0, se) & ~data;
B2=imdilate(B1, se) & ~data;
while 1
    imshow(B2);
    if B1 == B2
        break;
    else 
        B1 = B2;
        B2=imdilate(B1,se) & ~data;
    end
end
%连通分量提取
[rows,cols]=find(data==1);
%将x,y坐标点组合成下标矩阵
index=cat(2,rows,cols);
%5*5结构元素
n=5;
B=ones(n,n);
n_l=floor(n/2);
%对边界图进行扩充，四周各加2行、2列0（与结构元素的大小相对应），目的是为了处理边界点
I_pad=padarray(data,[n_l,n_l]);
%将下标矩阵加2
index=index+2;
%保存所有连通对象集
Objs={};
%设定递归上限
set(0,'RecursionLimit',10000);
%递归寻找连通对象
while 1
    %取出下标矩阵中的第一个值
    if isempty(index)
        break;
    end
    %取出下标矩阵中的第一个对象
    p=index(1,:);
    A=FindConnectedPoint(p,I_pad,index,n_l);  
    %将边界线对象保存至对象集
    Objs=cat(1,Objs,A{1,1}-n_l);
    index=A{1,2}; 
    I_pad=A{1,3};        
end
%显示连通对象
J=zeros(o,j);
if ~isempty(Objs)
    for t=1:size(Objs,1)
        Obj=Objs{t,1};
        for j=1:size(Obj,1)
            J(Obj(j,1),Obj(j,2))=1;
        end
    end
end
imshow(J)

%骨架处理
bw = bwmorph(data,'thin',Inf);

figure(3);
subplot(231),imshow(data),title('二值图像');
subplot(232),imshow(se.Neighborhood),title('结构元');
subplot(233),imshow(A5),title('二值图像边界提取');
subplot(234),imshow(B2),title('二值图像填充');
subplot(235),imshow(J),title('二值图像连通分量提取');
subplot(236),imshow(bw),title('二值图像骨架处理');

%灰度图像腐蚀、膨胀、开闭运算
se=strel('disk',6);   % 生成圆形结构元素
H1 = imdilate(data,se);   %   膨胀
H2 = imerode(data,se);    %   腐蚀
H3 = imopen(data,se);     %   开操作
H4 = imclose(data,se);    %   闭操作
figure(4);
subplot(231),imshow(data),title('灰度图像');
subplot(232),imshow(H1),title('膨胀后的灰度图像');
subplot(233),imshow(H2),title('腐蚀后的灰度图像');
subplot(234),imshow(se.Neighborhood),title('结构元');
subplot(235),imshow(H3),title('开运算后的灰度图像');
subplot(236),imshow(H4),title('闭运算后的灰度图像');

%灰度图像重构
%腐蚀图像
mark = imerode(data,ones(14,1));
figure;
imshow(mark);
% 形态学重构
Z = imreconstruct(mark,data);
figure(5);
subplot(221),imshow(data),title('模版图像');
subplot(222),imshow(mark),title('标记图像');
subplot(223),imshow(ones(14,1)),title('结构元');
subplot(224),imshow(Z),title('重构图像');