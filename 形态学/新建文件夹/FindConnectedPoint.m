function R=FindConnectedPoint(p,Beta_pad,ind,n_l)
    %����߽��������
    Obj=[];
    %��pΪ���ĵ㣬�ӱ߽�ͼ��ȡ��3*3��С�Ŀ�����
    Block=Beta_pad(p(1,1)-n_l:p(1,1)+n_l,p(1,2)-n_l:p(1,2)+n_l);
    Obj=p;
    %��ͼ���е�p������
    Beta_pad(p(1,1),p(1,2))=0;
    %���������е�p������
    Block(n_l+1,n_l+1)=0;
    A=cell(1,3);
    %��p����±������ɾ��
    for j=1:size(ind,1)
        if ind(j,:)==p
            ind(j,:)=[];
            break;
        end
    end
    %Ѱ�ҿ�������Ϊ1�ĵ���±�
    [rows,cols]=find(Block==1);
    ind_sub=cat(2,rows,cols);
    if ~isempty(ind_sub)
        %ȷ��������ֵΪ1�ĵ������
        for i=1:size(ind_sub,1) 
            p_next=[];
            if ind_sub(i,1)<=n_l+1
                p_next(1,1)=p(1,1)-abs(n_l+1-ind_sub(i,1));
                if ind_sub(i,2)<=n_l+1                    
                    p_next(1,2)=p(1,2)-abs(n_l+1-ind_sub(i,2));
                else
                    p_next(1,2)=p(1,2)+abs(n_l+1-ind_sub(i,2));                    
                end
            else
                p_next(1,1)=p(1,1)+abs(n_l+1-ind_sub(i,1));
                if ind_sub(i,2)<=n_l+1                    
                    p_next(1,2)=p(1,2)-abs(n_l+1-ind_sub(i,2));
                else
                    p_next(1,2)=p(1,2)+abs(n_l+1-ind_sub(i,2));                    
                end                
            end
            if Beta_pad(p_next(1,1),p_next(1,2))~=0                        
                A=FindConnectedPoint(p_next,Beta_pad,ind,n_l);
                Obj=cat(1,A{1,1},Obj);   
            end                       
            %�����±����
            ind=A{1,2};
            Beta_pad=A{1,3};
        end
    end
    %���ؽ��
    R={Obj,ind,Beta_pad};
end
