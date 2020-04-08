function [im_out] = PGs2Normals(Y_hat,W_hat,Par,dis_near_number)

para_p =0.25;
para_n = 0.0025;
count =Par.count; 
normal_temp = Y_hat./W_hat;
normal = zeros(3,count);
sum_count = zeros(3,count);
for j=1:Par.count
    for i=1:Par.ne_num
        k=(i-1)*3+1;
        normal(:,dis_near_number(i,j)) = normal(:,dis_near_number(i,j)) + normal_temp(k:k+2,j);
        sum_count(:,dis_near_number(i,j)) = sum_count(:,dis_near_number(i,j)) + ones(3,1);
    end
end
normal_out = normal./sum_count;
search_size_update = 20;         %此处标记，参数待调试
location = zeros(count,3);
for ite = 1
    for i =1:count
        searchPoint = Par.nim.Location(i,:);
        searchPoint_normal = normal_out(:,i);
        [indices, ~] = findNearestNeighbors(Par.nim,searchPoint,search_size_update);
        ne_point = Par.nim.Location(indices,:);
        ne_normal = normal_out(:,indices);
        factor1 = sum((bsxfun(@minus,ne_point, searchPoint).^2),2)'/(2*para_p);
        factor2 = sum((bsxfun(@minus,ne_normal, searchPoint_normal).^2),1)/(2*para_n);
        w_temp = exp(-(factor1 + factor2));
        w = w_temp/sum(w_temp);
        ne_p = bsxfun(@minus,searchPoint, ne_point)';
        delta_p = sum(w.*sum((ne_normal .* ne_p)) .* searchPoint_normal,2);
       location(i,:) =  searchPoint+delta_p';
    end
end
ptCloud = pointCloud(single(location(:,1:3)));
Par.nim = ptCloud;
im_out = Par.nim;
    


    