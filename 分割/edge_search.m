function connected = edge_search(I,parameter)


%转化为标记矩阵
%L=bwlabel(BW,n) 返回一个和BW大小相同的L矩阵，包含了标记了BW中每个联通区域的类别标签，n的值为4/8，默认为8（连通寻找）
I = I >parameter;   %得到logical型矩阵
L = bwlabel(I);

%标记连通图像
[row,col] = size(L);
connected = zeros(row,col);
labeled = [];
coor = {};
curr_coor = [];

%8邻域坐标
offsets = [0 -1; -1 -1; -1 0; -1 1; 0 1; 1 1; 1 0; 1 -1; 0 -1];
flag = true;


for i = 1:row
    for j = 1:col
        %判断L(i,j)为前景 且 未被标记 且 该区域未被标记
        %[ismember(a,b),返回与a大小相同的逻辑数组如果a中元素属于b,a中相应位置返回1，否则返回0]
        if L(i,j) ~= 0 && connected(i,j) == 0 && ~ismember(L(i,j),labeled)
            %初始方向
            dir = 2;
            %保存当前区域标签
            labeled = [labeled L(i,j)];
            pix = [i,j];
            curr_coor = [curr_coor; i j];
            %坐标入队
            flag = true;
            while flag
                flag = false;
                %循环到每圈初始时将方向初始化
                if pix(1,1) == i && pix(1,2)== j
                    dir = 2;
                end
                %邻域搜索
                for k = dir:dir+7
                    tmp = mod(k,8);
                    if tmp == 0
                        tmp = 8;
                    end
                    n_pix = bsxfun(@plus,pix, offsets(tmp,:));
                    %每圈终止
                    if pix(1,1) == i && pix(1,2)== j && length(curr_coor) > 2 && n_pix(1,1) == curr_coor(2,1) && n_pix(1,2) == curr_coor(2,2)
                        flag = false;
                        break;
                    end
                    %判断坐标在范围内
                    if n_pix(1) >= 1 && n_pix(1) <= row && n_pix(2) >= 1 && n_pix(2) <= col
                        if L(n_pix(1),n_pix(2)) ~= 0
                            %标记（画图
                            connected(n_pix(1),n_pix(2)) = 255;                            
                            %保存坐标值
                            curr_coor = [curr_coor; n_pix(1) n_pix(2)];                                               
                            %更新坐标
                            pix = [n_pix(1),n_pix(2)];
                            flag = true;
                            %更新反方向的下一方向
                            dir = mod(tmp + 5,8);
                            if dir == 0
                                dir = 8;
                            end
                            break;
                        end
                    end
                end
            end
            %保存一圈坐标
            coor = [coor; curr_coor];
            curr_coor = [];
        end
    end
end


%输出显示
end

