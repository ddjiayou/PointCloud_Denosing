function [normals] = neNormal(cloud_ptr,index,ne_num)
    %计算目标点的邻域法线，存储在normals中
global init_normals  %全局变量，初始法线
searchPoint = cloud_ptr.Location(index,:);
[indices, ~] = findNearestNeighbors(cloud_ptr,searchPoint,ne_num); %indices为index复数，返回点的标号和距离，~代表dists
                                                                 %寻找目标点云附近的50个点
%  for i = 1:ne_num    
%      normals(:,i) = init_normals(indices(i),:)'; %求邻域的法线
%  end
 normals = init_normals(indices,:)';
 
 
      