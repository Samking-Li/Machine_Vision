function Img_lap=laplace(Img,threshold)

lenna_3=mat2gray(Img);   %图像矩阵的归一化
[m,n]=size(lenna_3);
lenna_4=lenna_3;       %保留图像的边缘一个像素
L=0;
t=threshold;          %设定阈值
%Laplace算子
for j=2:m-1 
    for k=2:n-1
        L=abs(8*lenna_3(j,k)-lenna_3(j-1,k)-lenna_3(j+1,k)-lenna_3(j,k+1)-lenna_3(j-1,k-1)-lenna_3(j-1,k+1)-lenna_3(j+1,k)-lenna_3(j+1,k+1)-lenna_3(j+1,k-1));
        if(L > t)
            Img_lap(j,k)=255;  %白
        else
            Img_lap(j,k)=0;    %黑
        end
    end
end
