function   [nDCnlX,blk_arr,DC,par,dis_near_number] = PointCloud2PG( cloud_out,par)
    %nDCnlx为原来的X，DC均值，blk_arr为相似块的标号
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
global init_normals  %全局变量，初始法线
init_normals= pcnormals(cloud_out,50);%第二个参数为初始化法线需要邻域的大小
ne_normals = zeros(3,ne_num,count);  %邻域法线
avg_normal_all = zeros(3,count);    %所有的平均法向量
cov_mat_all = zeros(3,3,count);     %所有的特征描述符

for i=1:count
    ne_normals(:,:,i) = neNormal(cloud_out,i,ne_num);
    avg_normal_all(:,i) = mean(ne_normals(:,:,i),2);%求平均法向量
    cov_mat_all(:,:,i) = covMat(cloud_out,i,ne_num,ne_normals);%计算协方差描述子
end

dis_near_number = zeros(ne_num,count);%记录据搜索点距离最近的ne_num个点的标号,这几个点组成搜索点的块
for i=1:count
    avg_normal = avg_normal_all(:,i);%求平均法向量
    searchPoint = cloud_out.Location(i,:);
    cov_mat = cov_mat_all(:,:,i);
    [indices, ~] = findNearestNeighbors(cloud_out,searchPoint,win);%先计算目标点的协方差描述子和平均法向量
    dis_near_number(:,i) = indices(1:ne_num);
    
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
    dis = sortrows(dis,2);%排好序,第一列是标号，第二列是距离
    similar_patch = dis(1:nlsp,:);%选前nlsp个最相似的块
    blk_arr(:,(i-1)*par.nlsp+1:i*par.nlsp)  =  dis(1:nlsp,1);
    X = zeros(par.dim,nlsp);
    for k=1:nlsp
        X(:,k) = reshape(ne_normals(:,:,similar_patch(k,1)),[],1);
    end
    DC_temp = mean(X,2);
    DC(:,(i-1)*par.nlsp+1:i*par.nlsp) = repmat(DC_temp,[1 par.nlsp ]);
   
    nDCnlX(:,(i-1)*par.nlsp+1:i*par.nlsp) =X - DC(:,(i-1)*par.nlsp+1:i*par.nlsp);   
end




