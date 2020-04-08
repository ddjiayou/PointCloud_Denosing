function  [s_idx, seg]    =  Proc_cls_idx( cls_idx )

[idx,  s_idx]    =  sort(cls_idx);%分类从1-32，s_idx是每个类的坐标

idx2   =  idx(1:end-1) - idx(2:end);
seq    =  find(idx2);%返回不是0的坐标

seg    =  [0; seq; length(cls_idx)];