function connected = edge_search(I,parameter)


%ת��Ϊ��Ǿ���
%L=bwlabel(BW,n) ����һ����BW��С��ͬ��L���󣬰����˱����BW��ÿ����ͨ���������ǩ��n��ֵΪ4/8��Ĭ��Ϊ8����ͨѰ�ң�
I = I >parameter;   %�õ�logical�;���
L = bwlabel(I);

%�����ͨͼ��
[row,col] = size(L);
connected = zeros(row,col);
labeled = [];
coor = {};
curr_coor = [];

%8��������
offsets = [0 -1; -1 -1; -1 0; -1 1; 0 1; 1 1; 1 0; 1 -1; 0 -1];
flag = true;


for i = 1:row
    for j = 1:col
        %�ж�L(i,j)Ϊǰ�� �� δ����� �� ������δ�����
        %[ismember(a,b),������a��С��ͬ���߼��������a��Ԫ������b,a����Ӧλ�÷���1�����򷵻�0]
        if L(i,j) ~= 0 && connected(i,j) == 0 && ~ismember(L(i,j),labeled)
            %��ʼ����
            dir = 2;
            %���浱ǰ�����ǩ
            labeled = [labeled L(i,j)];
            pix = [i,j];
            curr_coor = [curr_coor; i j];
            %�������
            flag = true;
            while flag
                flag = false;
                %ѭ����ÿȦ��ʼʱ�������ʼ��
                if pix(1,1) == i && pix(1,2)== j
                    dir = 2;
                end
                %��������
                for k = dir:dir+7
                    tmp = mod(k,8);
                    if tmp == 0
                        tmp = 8;
                    end
                    n_pix = bsxfun(@plus,pix, offsets(tmp,:));
                    %ÿȦ��ֹ
                    if pix(1,1) == i && pix(1,2)== j && length(curr_coor) > 2 && n_pix(1,1) == curr_coor(2,1) && n_pix(1,2) == curr_coor(2,2)
                        flag = false;
                        break;
                    end
                    %�ж������ڷ�Χ��
                    if n_pix(1) >= 1 && n_pix(1) <= row && n_pix(2) >= 1 && n_pix(2) <= col
                        if L(n_pix(1),n_pix(2)) ~= 0
                            %��ǣ���ͼ
                            connected(n_pix(1),n_pix(2)) = 255;                            
                            %��������ֵ
                            curr_coor = [curr_coor; n_pix(1) n_pix(2)];                                               
                            %��������
                            pix = [n_pix(1),n_pix(2)];
                            flag = true;
                            %���·��������һ����
                            dir = mod(tmp + 5,8);
                            if dir == 0
                                dir = 8;
                            end
                            break;
                        end
                    end
                end
            end
            %����һȦ����
            coor = [coor; curr_coor];
            curr_coor = [];
        end
    end
end


%�����ʾ
end

