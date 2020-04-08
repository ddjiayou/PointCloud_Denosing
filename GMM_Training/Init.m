function model = Init(model)

%��ʼ����������
global data
ndim = model.ndim;
npat = model.cls_num;
nvec =model.nvec;

means = zeros(ndim,npat);%��ʼ����������
%u_num = unidrnd(nvec,npat,1); %��nvec�з���npat*1�������
u_num = randsample(nvec,npat);
for i=1:npat  %��ʼ����ֵ����
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

for i=1:npat  %��ʼ��pi,ÿ�������ı���
    plfPi(i) = 1/npat;
end

model.mixweights = plfPi;
model.means = means;
model.covs = sigma;