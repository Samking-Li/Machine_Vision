close all;
clear all;
clc;
filename = 'lena.JPG';
f = imread(filename);     
Info = imfinfo(filename); 
if (Info.BitDepth > 8)
    f = rgb2gray(f);
end

[high,width] = size(f);   % ���ͼ��ĸ߶ȺͿ��
F2 = double(f);        
U = double(f);       
uSobel = f;
for i = 2:high - 1   %sobel��Ե���
    for j = 2:width - 1
        Gx = (U(i+1,j-1) + 2*U(i+1,j) + F2(i+1,j+1)) - (U(i-1,j-1) + 2*U(i-1,j) + F2(i-1,j+1));
        Gy = (U(i-1,j+1) + 2*U(i,j+1) + F2(i+1,j+1)) - (U(i-1,j-1) + 2*U(i,j-1) + F2(i+1,j-1));
        uSobel(i,j) = sqrt(Gx^2 + Gy^2); 
    end
end 
subplot(121);imshow(f);title('ԭͼ');
subplot(122);imshow(im2uint8(uSobel));title('Sobel���ӱ�Ե�����ͼ');  %������Ե�����ͼ��

