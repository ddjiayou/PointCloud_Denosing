function   [Px, Px0] =  Get_PG( cloud_ptr,win, ne_num ,nlsp,step,delta)

count        = cloud_ptr.Count;
dim = ne_num*3;
%location     = cloud_ptr.Location;
global init_normals  %ȫ�ֱ�������ʼ����
init_normals= pcnormals(cloud_ptr,50);%�ڶ�������Ϊ��ʼ��������Ҫ����Ĵ�С
ne_normals = zeros(3,ne_num,count);  %������
avg_normal_all = zeros(3,count);    %���е�ƽ��������
cov_mat_all = zeros(3,3,count);     %���е�����������
Px0 = [];
Px  = [];

for i=1:count
    ne_normals(:,:,i) = neNormal(cloud_ptr,i,ne_num);
    avg_normal_all(:,i) = mean(ne_normals(:,:,i),2);%��ƽ��������
    cov_mat_all(:,:,i) = covMat(cloud_ptr,i,ne_num,ne_normals);%����Э����������
end

for i=1:count
    avg_normal = avg_normal_all(:,i);%��ƽ��������
    searchPoint = cloud_ptr.Location(i,:);
    cov_mat = cov_mat_all(:,:,i);
    [indices, ~] = findNearestNeighbors(cloud_ptr,searchPoint,win);%�ȼ���Ŀ����Э���������Ӻ�ƽ��������
    
    dis =zeros(win,2);
    %����ѭ����ʹ��
    avg_normal_ne = avg_normal_all(:,indices);%������ƽ��������
    cov_mat_ne = cov_mat_all(:,:,indices); %�����Э����������
    Factor1 = bsxfun(@minus,avg_normal,avg_normal_ne);
    Factor2 = bsxfun(@plus,cov_mat,cov_mat_ne);
    dis(:,1) = indices;
    for j =1:win
        dis(j,2) = sqrt(Factor1(:,j)'*(inv(Factor2(:,:,j)))*Factor1(:,j));%Ϊʲô�����Ǹ����� 
    end
    
%     for j =1:win
%         avg_normal_ne = avg_normal_all(:,indices(j));%����������ƽ��������
%         cov_mat_ne = cov_mat_all(:,:,indices(j)); %���������Э����������
%         Factor1 = avg_normal-avg_normal_ne;
%         Factor2 = cov_mat+cov_mat_ne;
%         dis(j,1) = indices(j);
%         dis(j,2) = sqrt(Factor1'*(inv(Factor2))*Factor1);%Ϊʲô�����Ǹ����� 
%     end     
    dis = sortrows(dis,2);%�ź���,��һ���Ǳ�ţ��ڶ����Ǿ���
    similar_patch = dis(1:nlsp,:);%ѡǰnlsp�������ƵĿ�
    X = zeros(dim,nlsp);
    for k=1:nlsp
        X(:,k) = reshape(ne_normals(:,:,similar_patch(k,1)),[],1);
    end
    DC_temp = mean(X,2);
    DC = repmat(DC_temp,[1 nlsp ]);
    X =X - DC;
    Px =[Px,X];   
end




