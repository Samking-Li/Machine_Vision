clear all;
close all;
clc;

img = imread('lena.jpg');
imgsize=size(img);
figure(1);subplot(1,2,1);imshow(img);title("原图像")
if numel(imgsize)>2 %判断通道数，原图为RGB还是灰度图
    grayimg = rgb2gray(img);
    figure(1);subplot(1,2,2);imshow(grayimg);title("灰度图像")
else
    grayimg = img;
    figure(1);subplot(1,2,2);imshow(grayimg);title("原图即为灰度图像")
end

wnimg = imnoise(grayimg,'gaussian') ;%加上噪声
spimg = imnoise(grayimg,'salt & pepper',0.1);
figure(2);subplot(1,2,1);imshow(wnimg);title("白噪声灰度图像")%显示加噪声后的图
figure(2);subplot(1,2,2);imshow(spimg);title("椒盐噪声灰度图像")

H=ones(3,3)/9;
k1=imfilter(wnimg,H); 
figure(3);subplot(1,3,1);imshow(k1);title("对白噪声进行八邻域平均法处理滤波后的图像")

H1=[1 1 1,1 2 1,1 1 1]/10;
k2=imfilter(wnimg,H1);
figure(3);subplot(1,3,2);imshow(k2);title("对白噪声进行加权平均法处理滤波后的图像")

k3=medfilt2(spimg);
figure(3);subplot(1,3,3);imshow(k3);title("对椒盐噪声进行中值法处理滤波后的图像")

k4=k1-imfilter(k1,fspecial('laplacian',0),'replicate'); 
k5=k1-imfilter(k1,fspecial('laplacian',1),'replicate'); 
figure(4);subplot(1,2,1);imshow(k4);title("对八邻域处理后的图像进行四邻域拉普拉斯锐化");
figure(4);subplot(1,2,2);imshow(k5);title("对八邻域处理后的图像进行八邻域拉普拉斯锐化");

F=fft2(img);%傅里叶变换
F1=log(abs(F)+1);%取模并进行缩放
Fs=fftshift(F);%将频谱图中零频率成分移动至频谱图中心
S=log(abs(Fs)+1);%取模并进行缩放
fr=real(ifft2(ifftshift(Fs)));  %频率域反变换到空间域，并取实部
ret=im2uint8(mat2gray(fr));    %更改图像类型
figure(5);subplot(1,3,1),imshow(F1,[]),title('傅里叶变换频谱图');
figure(5);subplot(1,3,2),imshow(S,[]),title('频移后的频谱图');
figure(5);subplot(1,3,3),imshow(ret),title('傅里叶逆变换');
figure;
a=100;
b=100;
U=0:a;
V=0:b;
M=length(U);N=length(V);
D0=10; %D0是频带的中心半径;W是频带的宽度
x1=50;y1=50;
x0=-50;y0=-50;
m=fix(M/2); n=fix(N/2);
H=zeros(M,N);
 
for u=1:M
    for v=1:N
        D1=((u-m-x0)^2+(v-n-y0).^2)^0.5;
        D2=((u-m+x0)^2+(v-n+y0).^2)^0.5;
        D11=((u-m-x1)^2+(v-n-y1).^2)^0.5;
        D21=((u-m+x1)^2+(v-n+y1).^2)^0.5;
        %高斯低通曲面
        H(u,v) = (U(u) - 50) .* (U(u)-50) + (V(v) - 50) .* (V(v) - 50);
        
    end
end
%在绘制高斯曲面的时候，加上下述代码，显示得美观
fangcha=50;
H = -H/(2*fangcha);
H = exp(H) / (sqrt(2*pi) * sqrt(fangcha));
 
surf(U,V,H),title('高斯低通滤波器透视图');
 
d0=50;  %阈值
[M ,N]=size(img);
 
img_f = fft2(double(img));%傅里叶变换得到频谱
img_f=fftshift(img_f);  %移到中间
 
m_mid=floor(M/2);%中心点坐标
n_mid=floor(N/2);  
 
h = zeros(M,N);%高斯低通滤波器构造
for i = 1:M
    for j = 1:N
        d = ((i-m_mid)^2+(j-n_mid)^2);
        h(i,j) = exp(-(d)/(2*(d0^2)));      
    end
end
 
img_lpf = h.*img_f;
 
img_lpf=ifftshift(img_lpf);    %中心平移回原来状态
img_lpf=uint8(real(ifft2(img_lpf)));  %反傅里叶变换,取实数部分
figure(7);imshow(img_lpf);title('高斯低通滤波d=50');
 
I_D=im2double(img);
M0=M/2;
N0=N/2;
J=fft2(I_D);
J_shift=fftshift(J);
 
A=2;
for x=1:M
    for y=1:N
        %计算频率域拉普拉斯算子
        h_hp=1+4*((x-M0)^2+(y-N0)^2)/(M0*N0);
        h_bp=(A-1)+h_hp;
        J_shift(x,y)=J_shift(x,y)*h_bp;
    end
end
 
J=ifftshift(J_shift);
I_D_rep=ifft2(J);
figure(8);imshow(I_D_rep),title('频域拉普拉斯滤波');

