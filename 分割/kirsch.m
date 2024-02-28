function Img_kir=kirsch(Img)

%提取图象边缘
t=[0.8 1.0 1.5 2.0 2.5].*10^5 ;     %设定阈值
Img=double(Img);            
[m,n]=size(Img);             
g=zeros(m,n); 
d=zeros(1,8);
%利用Kirsch算子进行边缘提取
for i=2:m-1
   for j=2:n-1
       d(1) =(5*Img(i-1,j-1)+5*Img(i-1,j)+5*Img(i-1,j+1)-3*Img(i,j-1)-3*Img(i,j+1)-3*Img(i+1,j-1)-3*Img(i+1,j)-3*Img(i+1,j+1))^2; 
       d(2) =((-3)*Img(i-1,j-1)+5*Img(i-1,j)+5*Img(i-1,j+1)-3*Img(i,j-1)+5*Img(i,j+1)-3*Img(i+1,j-1)-3*Img(i+1,j)-3*Img(i+1,j+1))^2; 
       d(3) =((-3)*Img(i-1,j-1)-3*Img(i-1,j)+5*Img(i-1,j+1)-3*Img(i,j-1)+5*Img(i,j+1)-3*Img(i+1,j-1)-3*Img(i+1,j)+5*Img(i+1,j+1))^2; 
       d(4) =((-3)*Img(i-1,j-1)-3*Img(i-1,j)-3*Img(i-1,j+1)-3*Img(i,j-1)+5*Img(i,j+1)-3*Img(i+1,j-1)+5*Img(i+1,j)+5*Img(i+1,j+1))^2; 
       d(5) =((-3)*Img(i-1,j-1)-3*Img(i-1,j)-3*Img(i-1,j+1)-3*Img(i,j-1)-3*Img(i,j+1)+5*Img(i+1,j-1)+5*Img(i+1,j)+5*Img(i+1,j+1))^2; 
       d(6) =((-3)*Img(i-1,j-1)-3*Img(i-1,j)-3*Img(i-1,j+1)+5*Img(i,j-1)-3*Img(i,j+1)+5*Img(i+1,j-1)+5*Img(i+1,j)-3*Img(i+1,j+1))^2; 
       d(7) =(5*Img(i-1,j-1)-3*Img(i-1,j)-3*Img(i-1,j+1)+5*Img(i,j-1)-3*Img(i,j+1)+5*Img(i+1,j-1)-3*Img(i+1,j)-3*Img(i+1,j+1))^2; 
       d(8) =(5*Img(i-1,j-1)+5*Img(i-1,j)-3*Img(i-1,j+1)+5*Img(i,j-1)-3*Img(i,j+1)-3*Img(i+1,j-1)-3*Img(i+1,j)-3*Img(i+1,j+1))^2;      
       g(i,j) = max(d);
    end
end

%显示边缘提取后的图象
for k=1:5
    for i=1:m
        for j=1:n
            if g(i,j)>t(k)
                Img_kir(i,j)=255;           
            else
                Img_kir(i,j)=0;
            end
        end
    end
end