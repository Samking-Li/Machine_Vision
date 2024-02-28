function Img_lap=laplace(Img,threshold)

lenna_3=mat2gray(Img);   %ͼ�����Ĺ�һ��
[m,n]=size(lenna_3);
lenna_4=lenna_3;       %����ͼ��ı�Եһ������
L=0;
t=threshold;          %�趨��ֵ
%Laplace����
for j=2:m-1 
    for k=2:n-1
        L=abs(8*lenna_3(j,k)-lenna_3(j-1,k)-lenna_3(j+1,k)-lenna_3(j,k+1)-lenna_3(j-1,k-1)-lenna_3(j-1,k+1)-lenna_3(j+1,k)-lenna_3(j+1,k+1)-lenna_3(j+1,k-1));
        if(L > t)
            Img_lap(j,k)=255;  %��
        else
            Img_lap(j,k)=0;    %��
        end
    end
end
