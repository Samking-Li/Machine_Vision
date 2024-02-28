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
%���Ҷ�ͼ��ת��Ϊ��ֵͼ��

%��ͼ��ת��Ϊ˫����
% i = im2double(data);

se=strel('disk',6);   % ����Բ�νṹԪ��
A1 = imdilate(data,se);   %   ����
A2 = imerode(data,se);    %   ��ʴ
A3 = imopen(data,se);     %   ������
A4 = imclose(data,se);    %   �ղ���
figure(2);
subplot(231),imshow(data),title('��ֵͼ��');
subplot(232),imshow(A1),title('���ͺ�Ķ�ֵͼ��');
subplot(233),imshow(A2),title('��ʴ��Ķ�ֵͼ��');
subplot(234),imshow(se.Neighborhood),title('�ṹԪ');
subplot(235),imshow(A3),title('�������Ķ�ֵͼ��');
subplot(236),imshow(A4),title('�������Ķ�ֵͼ��');

A5 =data-imerode(data,se);  %�߽���ȡ��ԭͼ��ȥ��ʴ���ͼ
% ͼ�����
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
%��ͨ������ȡ
[rows,cols]=find(data==1);
%��x,y�������ϳ��±����
index=cat(2,rows,cols);
%5*5�ṹԪ��
n=5;
B=ones(n,n);
n_l=floor(n/2);
%�Ա߽�ͼ�������䣬���ܸ���2�С�2��0����ṹԪ�صĴ�С���Ӧ����Ŀ����Ϊ�˴���߽��
I_pad=padarray(data,[n_l,n_l]);
%���±�����2
index=index+2;
%����������ͨ����
Objs={};
%�趨�ݹ�����
set(0,'RecursionLimit',10000);
%�ݹ�Ѱ����ͨ����
while 1
    %ȡ���±�����еĵ�һ��ֵ
    if isempty(index)
        break;
    end
    %ȡ���±�����еĵ�һ������
    p=index(1,:);
    A=FindConnectedPoint(p,I_pad,index,n_l);  
    %���߽��߶��󱣴�������
    Objs=cat(1,Objs,A{1,1}-n_l);
    index=A{1,2}; 
    I_pad=A{1,3};        
end
%��ʾ��ͨ����
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

%�Ǽܴ���
bw = bwmorph(data,'thin',Inf);

figure(3);
subplot(231),imshow(data),title('��ֵͼ��');
subplot(232),imshow(se.Neighborhood),title('�ṹԪ');
subplot(233),imshow(A5),title('��ֵͼ��߽���ȡ');
subplot(234),imshow(B2),title('��ֵͼ�����');
subplot(235),imshow(J),title('��ֵͼ����ͨ������ȡ');
subplot(236),imshow(bw),title('��ֵͼ��Ǽܴ���');

%�Ҷ�ͼ��ʴ�����͡���������
se=strel('disk',6);   % ����Բ�νṹԪ��
H1 = imdilate(data,se);   %   ����
H2 = imerode(data,se);    %   ��ʴ
H3 = imopen(data,se);     %   ������
H4 = imclose(data,se);    %   �ղ���
figure(4);
subplot(231),imshow(data),title('�Ҷ�ͼ��');
subplot(232),imshow(H1),title('���ͺ�ĻҶ�ͼ��');
subplot(233),imshow(H2),title('��ʴ��ĻҶ�ͼ��');
subplot(234),imshow(se.Neighborhood),title('�ṹԪ');
subplot(235),imshow(H3),title('�������ĻҶ�ͼ��');
subplot(236),imshow(H4),title('�������ĻҶ�ͼ��');

%�Ҷ�ͼ���ع�
%��ʴͼ��
mark = imerode(data,ones(14,1));
figure;
imshow(mark);
% ��̬ѧ�ع�
Z = imreconstruct(mark,data);
figure(5);
subplot(221),imshow(data),title('ģ��ͼ��');
subplot(222),imshow(mark),title('���ͼ��');
subplot(223),imshow(ones(14,1)),title('�ṹԪ');
subplot(224),imshow(Z),title('�ع�ͼ��');