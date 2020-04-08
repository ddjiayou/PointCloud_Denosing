function model = Init(model)

%初始化聚类中心
global data
ndim = model.ndim;
npat = model.cls_num;
nvec =model.nvec;

means = zeros(ndim,npat);%初始化聚类中心
%u_num = unidrnd(nvec,npat,1); %从nvec中返回npat*1的随机数
u_num = randsample(nvec,npat);
for i=1:npat  %初始化均值向量
    means(:,i) = data(:,u_num(i));
end
delta=zeros(ndim);
for i=1:ndim
    for j=1:ndim
        if (i==j)
            delta(i,j) = 0.1;
            %delta(i,j) =1/ndim;
        end
    end
end
for i=1:npat
    sigma(:,:,i) = delta;
end

for i=1:npat  %初始化pi,每个分量的比例
    plfPi(i) = 1/npat;
end

model.mixweights = plfPi;
model.means = means;
model.covs = sigma;