function   [nDCnlX,blk_arr,DC,par,dis_near_number] = PointCloud2PG( cloud_out,par)
    %nDCnlxΪԭ����X��DC��ֵ��blk_arrΪ���ƿ�ı��
count        = cloud_out.Count;
ne_num = par.ne_num;
nlsp = par.nlsp;
win = par.win;
blk_arr   =  zeros(1, par.count*par.nlsp ,'double');
% Patch Group Means
DC = zeros(par.dim,par.count*par.nlsp,'double');
% non-local patch groups
nDCnlX = zeros(par.dim,par.count*par.nlsp,'double');
%location     = cloud_out.Location;
global init_normals  %ȫ�ֱ�������ʼ����
init_normals= pcnormals(cloud_out,50);%�ڶ�������Ϊ��ʼ��������Ҫ����Ĵ�С
ne_normals = zeros(3,ne_num,count);  %������
avg_normal_all = zeros(3,count);    %���е�ƽ��������
cov_mat_all = zeros(3,3,count);     %���е�����������

for i=1:count
    ne_normals(:,:,i) = neNormal(cloud_out,i,ne_num);
    avg_normal_all(:,i) = mean(ne_normals(:,:,i),2);%��ƽ��������
    cov_mat_all(:,:,i) = covMat(cloud_out,i,ne_num,ne_normals);%����Э����������
end

dis_near_number = zeros(ne_num,count);%��¼����������������ne_num����ı��,�⼸�������������Ŀ�
for i=1:count
    avg_normal = avg_normal_all(:,i);%��ƽ��������
    searchPoint = cloud_out.Location(i,:);
    cov_mat = cov_mat_all(:,:,i);
    [indices, ~] = findNearestNeighbors(cloud_out,searchPoint,win);%�ȼ���Ŀ����Э���������Ӻ�ƽ��������
    dis_near_number(:,i) = indices(1:ne_num);
    
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
    dis = sortrows(dis,2);%�ź���,��һ���Ǳ�ţ��ڶ����Ǿ���
    similar_patch = dis(1:nlsp,:);%ѡǰnlsp�������ƵĿ�
    blk_arr(:,(i-1)*par.nlsp+1:i*par.nlsp)  =  dis(1:nlsp,1);
    X = zeros(par.dim,nlsp);
    for k=1:nlsp
        X(:,k) = reshape(ne_normals(:,:,similar_patch(k,1)),[],1);
    end
    DC_temp = mean(X,2);
    DC(:,(i-1)*par.nlsp+1:i*par.nlsp) = repmat(DC_temp,[1 par.nlsp ]);
   
    nDCnlX(:,(i-1)*par.nlsp+1:i*par.nlsp) =X - DC(:,(i-1)*par.nlsp+1:i*par.nlsp);   
end




