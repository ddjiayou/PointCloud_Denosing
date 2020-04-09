function [cov_mat] = covMat(cloud_ptr,index,ne_num,ne_normals)
    %此函数计算协方差描述子
    
global init_normals  %全局变量，初始法线
K1=ne_num;           %不确定要不要直接等于ne_num？？
searchPoint = cloud_ptr.Location(index,:);
[indices, ~] = findNearestNeighbors(cloud_ptr,searchPoint,K1); %indices为index复数，返回点的标号和距离，~代表dists                                                            %寻找目标点云附近的K1个点
%  for i = 1:K1  
%      avg_normal = avgNormal(i);
%      cov = init_normals(indices(i),:)-avg_normal;       %初始法线 - 平均法线
%      cov_mat = bsxfun(@plus,cov_mat, cov*cov');          %矩阵相加   
%  end
 avg_normal = mean(ne_normals(:,:,index),2);%原来的这里是i,应该是不对的，此处应是search point的平均法向量
 cov_temp = bsxfun(@minus,init_normals(indices,:)',avg_normal);
 cov_mat = cov_temp*cov_temp'; 
 cov_mat = cov_mat./K1;%协方差描述子