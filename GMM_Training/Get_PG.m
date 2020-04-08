function   [Px, Px0] =  Get_PG( cloud_ptr,win, ne_num ,nlsp,step,delta)

count        = cloud_ptr.Count;
dim = ne_num*3;
%location     = cloud_ptr.Location;
global init_normals  %全局变量，初始法线
init_normals= pcnormals(cloud_ptr,50);%第二个参数为初始化法线需要邻域的大小
ne_normals = zeros(3,ne_num,count);  %邻域法线
avg_normal_all = zeros(3,count);    %所有的平均法向量
cov_mat_all = zeros(3,3,count);     %所有的特征描述符
Px0 = [];
Px  = [];

for i=1:count
    ne_normals(:,:,i) = neNormal(cloud_ptr,i,ne_num);
    avg_normal_all(:,i) = mean(ne_normals(:,:,i),2);%求平均法向量
    cov_mat_all(:,:,i) = covMat(cloud_ptr,i,ne_num,ne_normals);%计算协方差描述子
end

for i=1:count
    avg_normal = avg_normal_all(:,i);%求平均法向量
    searchPoint = cloud_ptr.Location(i,:);
    cov_mat = cov_mat_all(:,:,i);
    [indices, ~] = findNearestNeighbors(cloud_ptr,searchPoint,win);%先计算目标点的协方差描述子和平均法向量
    
    dis =zeros(win,2);
    %减少循环的使用
    avg_normal_ne = avg_normal_all(:,indices);%邻域点的平均法向量
    cov_mat_ne = cov_mat_all(:,:,indices); %邻域点协方差描述子
    Factor1 = bsxfun(@minus,avg_normal,avg_normal_ne);
    Factor2 = bsxfun(@plus,cov_mat,cov_mat_ne);
    dis(:,1) = indices;
    for j =1:win
        dis(j,2) = sqrt(Factor1(:,j)'*(inv(Factor2(:,:,j)))*Factor1(:,j));%为什么不会是复数呢 
    end
    
%     for j =1:win
%         avg_normal_ne = avg_normal_all(:,indices(j));%计算邻域点的平均法向量
%         cov_mat_ne = cov_mat_all(:,:,indices(j)); %计算邻域点协方差描述子
%         Factor1 = avg_normal-avg_normal_ne;
%         Factor2 = cov_mat+cov_mat_ne;
%         dis(j,1) = indices(j);
%         dis(j,2) = sqrt(Factor1'*(inv(Factor2))*Factor1);%为什么不会是复数呢 
%     end     
    dis = sortrows(dis,2);%排好序,第一列是标号，第二列是距离
    similar_patch = dis(1:nlsp,:);%选前nlsp个最相似的块
    X = zeros(dim,nlsp);
    for k=1:nlsp
        X(:,k) = reshape(ne_normals(:,:,similar_patch(k,1)),[],1);
    end
    DC_temp = mean(X,2);
    DC = repmat(DC_temp,[1 nlsp ]);
    X =X - DC;
    Px =[Px,X];   
end




