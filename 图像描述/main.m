close all;
clear all;
clc;
filename = 'lena.jpg';
f = imread(filename);     

Info = imfinfo(filename); 
if (Info.BitDepth > 8)
    f = rgb2gray(f);
end

%Harris�ǵ���
%����ͼ������f(x,y)�ڵ�(x,y)�����ݶ�-----------------------------------------------
ori_im = double(f) / 255;                   
fx = [-2 -1 0 1 2];                     % x�����ݶ�����
Ix = filter2(fx, ori_im);                

fy = [-2; -1; 0; 1; 2];                     % y�����ݶ�����
Iy = filter2(fy, ori_im);                % y�����˲�

%��������ؾ���---------------------------------------------------------------
Ix2 = Ix .^ 2;
Iy2 = Iy .^ 2;
Ixy = Ix .* Iy;

clear Ix;
clear Iy;

h= fspecial('gaussian', [7 7], 2);        % ����7*7�ĸ�˹��������sigma=2

Ix2 = filter2(h,Ix2);
Iy2 = filter2(h,Iy2);
Ixy = filter2(h,Ixy);

%��ȡ������---------------------------------------------------------------
height = size(ori_im, 1);
width = size(ori_im, 2);
result = zeros(height, width);           % ��¼�ǵ�λ�ã��ǵ㴦ֵΪ1

R = zeros(height, width);
Rmax = 0;                              % ͼ��������Rֵ
k = 0.06;

for i = 1 : height
    for j = 1 : width
        M = [Ix2(i, j) Ixy(i, j); Ixy(i, j) Iy2(i, j)];            
        R(i,j) = det(M) - k * (trace(M)) ^ 2;                     % ����R
        if R(i,j) > Rmax
            Rmax = R(i, j);
        end
    end
end

T = 0.01 * Rmax;%�̶���ֵ����R(i, j) > Tʱ�����ж�Ϊ��ѡ�ǵ�

%���оֲ��Ǽ���ֵ����-------------------------------------
cnt = 0;
for i = 2 : height-1
    for j = 2 : width-1
        if (R(i, j) > T && R(i, j) > R(i-1, j-1) && R(i, j) > R(i-1, j) && R(i, j) > R(i-1, j+1) && R(i, j) > R(i, j-1) && ...
                R(i, j) > R(i, j+1) && R(i, j) > R(i+1, j-1) && R(i, j) > R(i+1, j) && R(i, j) > R(i+1, j+1))
            result(i, j) = 1;
            cnt = cnt+1;
        end
    end
end

i = 1;
    for j = 1 : height
        for k = 1 : width
            if result(j, k) == 1
                corners1(i, 1) = j;
                corners1(i, 2) = k;
                i = i + 1;
            end
        end
    end
[posc, posr] = find(result == 1);
figure(1)
subplot(121);
imshow(f);
title("ԭͼ")
subplot(122);
imshow(ori_im);
hold on;
plot(posr, posc, 'r+');
title("Harris�ǵ�����ͼ")

%SIFT�ǵ���
pic = f;
[M N]=size(pic);%����ͼ������ֵ  
mask=[0 0 1 1 1 0 0;...  
      0 1 0 0 0 1 0;...  
      1 0 0 0 0 0 1;...  
      1 0 0 0 0 0 1;...  
      1 0 0 0 0 0 1;...  
      0 1 0 0 0 1 0;...  
      0 0 1 1 1 0 0];%����16��Բ�ܵ㵥λ����  
mask=uint8(mask);%�Ѵ���255����ǿ��Ϊ255��Ҳ���ǰѻҶ�ֵӳ�䵽0-255��  
threshold=25;%���巧ֵ
figure(2);
subplot(121);
imshow(f);
title("ԭͼ")
subplot(122);
imshow(pic);%��ʾ�Ҷ�ͼ��f
title('SIFT�ǵ�����ͼ');hold on;  
for i=4:M-3  
    for j=4:N-3%��I1��I9������I0�Ĳ��С����ֵ�����Ǻ�ѡ��  
        %����p1��p9��p5��p13������p�����ز�
        delta1=abs(pic(i-3,j)-pic(i,j))>threshold;  
        delta9=abs(pic(i+3,j)-pic(i,j))>threshold;  
        delta5=abs(pic(i,j+3)-pic(i,j))>threshold;  
        delta13=abs(pic(i,j-3)-pic(i,j))>threshold;  
        if sum([delta1 delta9 delta5 delta13])>=3%���ز����ֵ�ĸ���  
            block=pic(i-3:i+3,j-3:j+3);  
            block=block.*mask;%��ȡԲ��16����  
            pos=find(block);%����Բ�ܵ��еķ�0��  
            block1=abs(block(pos)-pic(i,j))/threshold;  
            block2=floor(block1);%��block1�е����������ȡ��  
            res=find(block2);  
            if size(res,1)>=12  %ɸѡ
                plot(j,i,'ro');  
            end  
        end  
    end  
end

%sobel��Ե���
[high,width] = size(f);   % ���ͼ��ĸ߶ȺͿ��
F2 = double(f);        
U = double(f);       
uSobel = f;
for i = 2:high - 1  
    for j = 2:width - 1
        Gx = (U(i+1,j-1) + 2*U(i+1,j) + F2(i+1,j+1)) - (U(i-1,j-1) + 2*U(i-1,j) + F2(i-1,j+1));
        Gy = (U(i-1,j+1) + 2*U(i,j+1) + F2(i+1,j+1)) - (U(i-1,j-1) + 2*U(i,j-1) + F2(i+1,j-1));
        uSobel(i,j) = sqrt(Gx^2 + Gy^2); 
    end
end 
subplot(121);imshow(f);title('ԭͼ');
subplot(122);imshow(im2uint8(uSobel));title('Sobel���ӱ�Ե�����ͼ');  %������Ե�����ͼ��

%Canny���ӱ�Ե���
I = im2double(f);
BW4=edge(I,'canny');
figure(4)
subplot(121),imshow(f),title("ԭͼ");
subplot(122),imshow(BW4),title("Canny���ӱ�Ե�����ͼ");

%LBP������
x=size(f,1);
y=size(f,2);
texture=uint8(zeros(x,y));

for i=2:1:x-1
    for j=2:1:y-1
        neighbor=uint8(zeros(1,8));
       
        neighbor(1,1)=f(i-1,j);
        neighbor(1,2)=f(i-1,j+1);
        neighbor(1,3)=f(i,j+1);
        neighbor(1,4)=f(i+1,j+1);
        neighbor(1,5)=f(i+1,j);
        neighbor(1,6)=f(i+1,j-1);
        neighbor(1,7)=f(i,j-1);
         neighbor(1,8)=f(i-1,j-1);
        center=f(i,j);
        temp=uint8(0);
        for k=1:1:8
             temp =temp+ (neighbor(1,k) >= center)* 2^(k-1);
        end
        texture(i,j)=temp;
       
    end
end
figure(5)
subplot(121),imshow(f),title("ԭͼ")
subplot(122),imshow(texture),title("LBP��������ͼ");


%HOG������ȡ
[featureVector,hogVisualization] = extractHOGFeatures(f);
figure(6);
subplot(121),imshow(f),title("ԭͼ");
subplot(122);
imshow(f),title("HOG������ȡ���ͼ");
hold on;
plot(hogVisualization);

