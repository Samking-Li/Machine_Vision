function gdata2 = grow(gdata1)

gdata = gdata1;
labelflag = zeros(size(gdata1));   %标记信号
[width,height ] = size(gdata1);
yuzhi = 40;  %阈值为40

if( exist('x','var') == 0 && exist('y','var') == 0)
    imshow(gdata1);title('灰度图');
    gdata1 = double(gdata1);
    [y,x] = getpts;%鼠标取点  回车确定
    x1 = round(x(1));%选择种子点
    y1 = round(y(1));
end

 gdata2 = zeros(size(gdata));
 gdata2(:,:) = 255;
 array_x = x1; array_y = y1;
 [h,l] = size(array_x);
 labelflag(x1,y1) = 1;
 array_all = gdata1(x1,y1);
 while l ~= 0 && h ~= 0
     array_x;
     x = array_x(1); y = array_y(1);
     gdata2(x,y) = 0;

     for u = -1:1
         for v = -1:1
             if x+u>0 && x+u <=width && y+v <=height && y+v>0
                 if (abs(mean(array_all) - gdata1(x + u,y + v)) < yuzhi...
                                 && labelflag(x + u,y + v) == 0)
                             
                     array_all = [gdata1(x1,y1),gdata(x+u,y+v)];
                     labelflag(x + u,y + v) = 1;  
                     array_x = [array_x,x + u];  
                     array_y = [array_y,y + v]; 
                 end
             end
         end
     end
     array_x(1) = [];array_y(1) = [];   %把已经涂过的点去掉
     [h,l] = size(array_x);
 end
end

