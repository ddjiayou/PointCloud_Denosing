function [cov_mat] = covMat(cloud_ptr,index,ne_num,ne_normals)
    %�˺�������Э����������
    
global init_normals  %ȫ�ֱ�������ʼ����
K1=ne_num;           %��ȷ��Ҫ��Ҫֱ�ӵ���ne_num����
searchPoint = cloud_ptr.Location(index,:);
[indices, ~] = findNearestNeighbors(cloud_ptr,searchPoint,K1); %indicesΪindex���������ص�ı�ź;��룬~����dists                                                            %Ѱ��Ŀ����Ƹ�����K1����
%  for i = 1:K1  
%      avg_normal = avgNormal(i);
%      cov = init_normals(indices(i),:)-avg_normal;       %��ʼ���� - ƽ������
%      cov_mat = bsxfun(@plus,cov_mat, cov*cov');          %�������   
%  end
 avg_normal = mean(ne_normals(:,:,index),2);%ԭ����������i,Ӧ���ǲ��Եģ��˴�Ӧ��search point��ƽ��������
 cov_temp = bsxfun(@minus,init_normals(indices,:)',avg_normal);
 cov_mat = cov_temp*cov_temp'; 
 cov_mat = cov_mat./K1;%Э����������