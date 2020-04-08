function model = maximization(X, R ,nlsp)
[d,n] = size(X);
R = R(reshape(ones(nlsp,1)*(1:size(R,1)),size(R,1)*nlsp,1),:);%将R每一行复制10次
k = size(R,2);

nk = sum(R,1);% R是中间变量，系数？
w = nk/n;  %还不太懂
% means = bsxfun(@times, X*R, 1./nk);
means = zeros(d,k);

Sigma = zeros(d,d,k);
sqrtR = sqrt(R);

for i = 1:k
    Xo = bsxfun(@minus,X,means(:,i));%减去第一列,会将means扩列
    Xo = bsxfun(@times,Xo,sqrtR(:,i)');%X0* R第一列转置再扩展为286230行，为什么要这么乘？
                                       %应该是yji*(x-mu)阶段，可能这也是为什么用sqrt的原因，因为公式是yji*(x-mu)*(x-mu)';
    Sigma(:,:,i) = Xo*Xo'/nk(i);
    Sigma(:,:,i) = Sigma(:,:,i)+eye(d)*(1e-6); % add a prior for numerical stability
end

model.dim = d;
model.nmodels = k;
model.mixweights = w;
model.means = means;
model.covs = Sigma;