function BW = IHT(Img)
%��ʼ����ֵ
T=0.5*(double(min(Img(:)))+double(max(Img(:))));
d=false;
%ͨ�������������ֵ
while~d
g=Img>=T;
Tn=0.5*(mean(Img(g))+mean(Img(~g)));
d=abs(T-Tn)<0.5;
T=Tn;
end
% ���������ֵ����ͼ��ָ�
level=Tn/255;
BW=im2bw(Img,level);
end

