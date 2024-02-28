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
grayimg=im2double(grayimg);

a=0;
b=0.1;

A=1;
ray_n=a+b*raylrnd(A,imgsize(1),imgsize(2));
ray_img=ray_n+grayimg;

A=1;B=2;
gam_n=a+b*gamrnd(A,B,imgsize);
gam_img=gam_n+grayimg;

mu=2;
exp_n=a+b*exprnd(mu,imgsize);
exp_img=exp_n+grayimg;

mean_n=a+b*unifrnd(A,B,imgsize);
mean_img=mean_n+grayimg;

figure(2);subplot(2,2,1);imshow(ray_img);title("���������Ҷ�ͼ��")
figure(2);subplot(2,2,2);imshow(gam_img);title("٤�������Ҷ�ͼ��")
figure(2);subplot(2,2,3);imshow(exp_img);title("ָ�������Ҷ�ͼ��")
figure(2);subplot(2,2,4);imshow(mean_img);title("��ֵ�����Ҷ�ͼ��")

mean_f_img=ordfilt2(ray_img,5,ones(3,3));
min_f_img=ordfilt2(ray_img,1,ones(3,3));
max_f_img=ordfilt2(ray_img,9,ones(3,3));

figure;
subplot(1,3,1);imshow(mean_f_img);title("����������������ֵ�˲����ͼ��");
subplot(1,3,2);imshow(min_f_img);title("����������������С�˲����ͼ��");
subplot(1,3,3);imshow(max_f_img);title("������������������˲����ͼ��");

mean_f_img=ordfilt2(gam_img,5,ones(3,3));
min_f_img=ordfilt2(gam_img,1,ones(3,3));
max_f_img=ordfilt2(gam_img,9,ones(3,3));

figure;
subplot(1,3,1);imshow(mean_f_img);title("��٤������������ֵ�˲����ͼ��");
subplot(1,3,2);imshow(min_f_img);title("��٤������������С�˲����ͼ��");
subplot(1,3,3);imshow(max_f_img);title("��٤��������������˲����ͼ��");

mean_f_img=ordfilt2(exp_img,5,ones(3,3));
min_f_img=ordfilt2(exp_img,1,ones(3,3));
max_f_img=ordfilt2(exp_img,9,ones(3,3));

figure;
subplot(1,3,1);imshow(mean_f_img);title("��ָ������������ֵ�˲����ͼ��");
subplot(1,3,2);imshow(min_f_img);title("��ָ������������С�˲����ͼ��");
subplot(1,3,3);imshow(max_f_img);title("��ָ��������������˲����ͼ��");

mean_f_img=ordfilt2(mean_img,5,ones(3,3));
min_f_img=ordfilt2(mean_img,1,ones(3,3));
max_f_img=ordfilt2(mean_img,9,ones(3,3));

figure;
subplot(1,3,1);imshow(mean_f_img);title("�Ծ�ֵ����������ֵ�˲����ͼ��");
subplot(1,3,2);imshow(min_f_img);title("�Ծ�ֵ����������С�˲����ͼ��");
subplot(1,3,3);imshow(max_f_img);title("�Ծ�ֵ������������˲����ͼ��");