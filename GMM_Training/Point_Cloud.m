clear;
t0 = clock;
TD_path = '.\PCD_model_1';
% Set the parameters
step = 3;
delta = 0.001;
win = 40;
ne_num = 10;      %邻域大小
nlsp = 10;        %相似数目
cls_num  = 32;
model.cls_num  = 32;
model.iter = 10;
% read natural point cloud

fpath       =   fullfile(TD_path, '*.pcd');
im_dir      =   dir(fpath);
im_num      =   length(im_dir);
X           =  [];
X0          =  [];
for  i  =  1:im_num
   % im         =   im2double( imread(fullfile(TD_path, im_dir(i).name)) );
    t1=clock;
    cloud_ptr = pcread(fullfile(TD_path, im_dir(i).name));
    [Px, Px0] = Get_PG(cloud_ptr,win, ne_num ,nlsp,step,delta);
    clear cloud_ptr;
    X0 = [X0 Px0];%X0非常相似
    X   = [X Px];%X不是特别像似，方差大
    clear Px Px0;
    t2=clock;
    etime(t2,t1)
end

global data
data=X;

% PG-GMM Training
[model,ll_D,label] = Gmm(data,model,nlsp);
[s_idx, seg]    =  Proc_cls_idx( label );
for  i  =  1 : length(seg)-1
    idx    =   s_idx(seg(i)+1:seg(i+1));
    cls    =   label(idx(1));
    [P,S,~] = svd(model.covs(:,:,i));
    S = diag(S);
    GMM.D{cls}    =  P;
    GMM.S{cls}    =  S;
    Xc{cls} = data(:, idx);
end
modelname = sprintf('point_cloud%dx_win%d_nlsp%d_delta%2.3f_cls%d.mat',ne_num,win,nlsp,delta,cls_num);
save(modelname,'model','nlsp','GMM','cls_num','delta','win','ne_num','-v7.3');
tn = clock;
etime(tn,t0)