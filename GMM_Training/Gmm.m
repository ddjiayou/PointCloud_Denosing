function [model,ll_D,label] = Gmm(data,model,nlsp)
model.nvec    = size(data,2);
model.ndim    = size(data,1);
model = Init(model);
label = [];%��¼ÿ�����������ĸ���
for iteration = 1:model.iter
 [lf_z,ll_D] = expectation(data,model,nlsp);% [lf_z,ll_D]��ʾ����ϵ���������Ȼ����ֵ
 model       = maximization(data,lf_z,nlsp);
 [~,label] = max(lf_z,[],2);
 fprintf( 'runing...%d,ll_D=%d\n',iteration,ll_D);
end




