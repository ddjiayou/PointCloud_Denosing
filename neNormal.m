function [normals] = neNormal(cloud_ptr,index,ne_num)
    %����Ŀ���������ߣ��洢��normals��
global init_normals  %ȫ�ֱ�������ʼ����
searchPoint = cloud_ptr.Location(index,:);
[indices, ~] = findNearestNeighbors(cloud_ptr,searchPoint,ne_num); %indicesΪindex���������ص�ı�ź;��룬~����dists
                                                                 %Ѱ��Ŀ����Ƹ�����50����
%  for i = 1:ne_num    
%      normals(:,i) = init_normals(indices(i),:)'; %������ķ���
%  end
 normals = init_normals(indices,:)';
 
 
      