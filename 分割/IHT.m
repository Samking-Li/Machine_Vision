function BW = IHT(Img)
%初始化阈值
T=0.5*(double(min(Img(:)))+double(max(Img(:))));
d=false;
%通过迭代求最佳阈值
while~d
g=Img>=T;
Tn=0.5*(mean(Img(g))+mean(Img(~g)));
d=abs(T-Tn)<0.5;
T=Tn;
end
% 根据最佳阈值进行图像分割
level=Tn/255;
BW=im2bw(Img,level);
end

