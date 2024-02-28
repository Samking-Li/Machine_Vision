close all;
clear all;
clc;
filename = 'lena.JPG';
picture = imread(filename);     

Info = imfinfo(filename); 
if (Info.BitDepth > 8)
    picture = rgb2gray(picture);
end
x=size(picture,1);
y=size(picture,2);
texture=uint8(zeros(x,y));

for i=2:1:x-1
    for j=2:1:y-1
        neighbor=uint8(zeros(1,8));
       
        neighbor(1,1)=picture(i-1,j);
        neighbor(1,2)=picture(i-1,j+1);
        neighbor(1,3)=picture(i,j+1);
        neighbor(1,4)=picture(i+1,j+1);
        neighbor(1,5)=picture(i+1,j);
        neighbor(1,6)=picture(i+1,j-1);
        neighbor(1,7)=picture(i,j-1);
         neighbor(1,8)=picture(i-1,j-1);
        center=picture(i,j);
        temp=uint8(0);
        for k=1:1:8
             temp =temp+ (neighbor(1,k) >= center)* 2^(k-1);
        end
        texture(i,j)=temp;
       
    end
end
figure
subplot(121),imshow(picture),title("原图")
subplot(122),imshow(texture),title("LBP纹理检测结果图");
