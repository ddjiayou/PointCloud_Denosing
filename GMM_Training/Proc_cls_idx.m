function  [s_idx, seg]    =  Proc_cls_idx( cls_idx )

[idx,  s_idx]    =  sort(cls_idx);%�����1-32��s_idx��ÿ���������

idx2   =  idx(1:end-1) - idx(2:end);
seq    =  find(idx2);%���ز���0������

seg    =  [0; seq; length(cls_idx)];