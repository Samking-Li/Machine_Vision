clear all;
close all;
clc;

img = imread('lena.jpg');
imgsize=size(img);
figure(1);subplot(1,2,1);imshow(img);title("ԭͼ��")
if numel(imgsize)>2 %�ж�ͨ������ԭͼΪRGB���ǻҶ�ͼ
    grayimg = rgb2gray(img);
    figure(1);subplot(1,2,2);imshow(grayimg);title("�Ҷ�ͼ��")
else
    grayimg = img;
    figure(1);subplot(1,2,2);imshow(grayimg);title("ԭͼ��Ϊ�Ҷ�ͼ��")
end

wnimg = imnoise(grayimg,'gaussian') ;%��������
spimg = imnoise(grayimg,'salt & pepper',0.1);
figure(2);subplot(1,2,1);imshow(wnimg);title("�������Ҷ�ͼ��")%��ʾ���������ͼ
figure(2);subplot(1,2,2);imshow(spimg);title("���������Ҷ�ͼ��")

H=ones(3,3)/9;
k1=imfilter(wnimg,H); 
figure(3);subplot(1,3,1);imshow(k1);title("�԰��������а�����ƽ���������˲����ͼ��")

H1=[1 1 1,1 2 1,1 1 1]/10;
k2=imfilter(wnimg,H1);
figure(3);subplot(1,3,2);imshow(k2);title("�԰��������м�Ȩƽ���������˲����ͼ��")

k3=medfilt2(spimg);
figure(3);subplot(1,3,3);imshow(k3);title("�Խ�������������ֵ�������˲����ͼ��")

k4=k1-imfilter(k1,fspecial('laplacian',0),'replicate'); 
k5=k1-imfilter(k1,fspecial('laplacian',1),'replicate'); 
figure(4);subplot(1,2,1);imshow(k4);title("�԰���������ͼ�����������������˹��");
figure(4);subplot(1,2,2);imshow(k5);title("�԰���������ͼ����а�����������˹��");

F=fft2(img);%����Ҷ�任
F1=log(abs(F)+1);%ȡģ����������
Fs=fftshift(F);%��Ƶ��ͼ����Ƶ�ʳɷ��ƶ���Ƶ��ͼ����
S=log(abs(Fs)+1);%ȡģ����������
fr=real(ifft2(ifftshift(Fs)));  %Ƶ���򷴱任���ռ��򣬲�ȡʵ��
ret=im2uint8(mat2gray(fr));    %����ͼ������
figure(5);subplot(1,3,1),imshow(F1,[]),title('����Ҷ�任Ƶ��ͼ');
figure(5);subplot(1,3,2),imshow(S,[]),title('Ƶ�ƺ��Ƶ��ͼ');
figure(5);subplot(1,3,3),imshow(ret),title('����Ҷ��任');
figure;
a=100;
b=100;
U=0:a;
V=0:b;
M=length(U);N=length(V);
D0=10; %D0��Ƶ�������İ뾶;W��Ƶ���Ŀ��
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
        %��˹��ͨ����
        H(u,v) = (U(u) - 50) .* (U(u)-50) + (V(v) - 50) .* (V(v) - 50);
        
    end
end
%�ڻ��Ƹ�˹�����ʱ�򣬼����������룬��ʾ������
fangcha=50;
H = -H/(2*fangcha);
H = exp(H) / (sqrt(2*pi) * sqrt(fangcha));
 
surf(U,V,H),title('��˹��ͨ�˲���͸��ͼ');
 
d0=50;  %��ֵ
[M ,N]=size(img);
 
img_f = fft2(double(img));%����Ҷ�任�õ�Ƶ��
img_f=fftshift(img_f);  %�Ƶ��м�
 
m_mid=floor(M/2);%���ĵ�����
n_mid=floor(N/2);  
 
h = zeros(M,N);%��˹��ͨ�˲�������
for i = 1:M
    for j = 1:N
        d = ((i-m_mid)^2+(j-n_mid)^2);
        h(i,j) = exp(-(d)/(2*(d0^2)));      
    end
end
 
img_lpf = h.*img_f;
 
img_lpf=ifftshift(img_lpf);    %����ƽ�ƻ�ԭ��״̬
img_lpf=uint8(real(ifft2(img_lpf)));  %������Ҷ�任,ȡʵ������
figure(7);imshow(img_lpf);title('��˹��ͨ�˲�d=50');
 
I_D=im2double(img);
M0=M/2;
N0=N/2;
J=fft2(I_D);
J_shift=fftshift(J);
 
A=2;
for x=1:M
    for y=1:N
        %����Ƶ����������˹����
        h_hp=1+4*((x-M0)^2+(y-N0)^2)/(M0*N0);
        h_bp=(A-1)+h_hp;
        J_shift(x,y)=J_shift(x,y)*h_bp;
    end
end
 
J=ifftshift(J_shift);
I_D_rep=ifft2(J);
figure(8);imshow(I_D_rep),title('Ƶ��������˹�˲�');

