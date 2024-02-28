close all;
clear all;
clc;

% %��ȡͼ��
data = imread('lena.jpg');
%��ʾԭʼͼ��
figure(1);
imshow(data),title('ԭʼͼ��');
%�ж϶�ȡͼ���Ƿ��ǻҶ�ͼ
[o,j,p]=size(data);
if p==3
    %��ʾ��ͨ��ͼ��
    %����ɫͼ��תΪ�Ҷ�ͼ
    data = rgb2gray(data);
else   
end

Img_roberts = edge(data,'roberts');  %reberts
Img_sobel=edge(data,'sobel');  %sobel
Img_kir=kirsch(data);
Img_lap=laplace(data,0.3);  %laplace
figure(2)
subplot(221);imshow(Img_roberts),title('roberts����');
subplot(222);imshow(Img_sobel),title('sobel����');
subplot(223);imshow(Img_kir);title('����ϣ����');
subplot(224);imshow(Img_lap);title('������˹����');

Img_RS=edge_search(data,60);
figure(3)
imshow(Img_RS,[]),title('��դɨ��');

Img_IHT=IHT(data);
figure(4)
imshow(Img_IHT),title('������ֵ��');

Img_grow=grow(data);
figure(5)
imshow(Img_grow),title('����������');