function [model,ll_D,label] = Gmm(data,model,nlsp)
model.nvec    = size(data,2);
model.ndim    = size(data,1);
model = Init(model);
label = [];%记录每个数据属于哪个类
for iteration = 1:model.iter
 [lf_z,ll_D] = expectation(data,model,nlsp);% [lf_z,ll_D]表示隐含系数和最大似然函数值
 model       = maximization(data,lf_z,nlsp);
 [~,label] = max(lf_z,[],2);
 fprintf( 'runing...%d,ll_D=%d\n',iteration,ll_D);
end




