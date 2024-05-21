pro Classification_ML
;基于ENVI_doit进行最大似然法分类

  ;读入数据文件
  fn=dialog_pickfile(title='选择遥感数据')
  envi_open_file, fn, r_fid=fid
  envi_file_query, fid, ns=ns, nl=nl, nb=nb, dims=dims
  pos=[0:nb-1]

  ;读入ROI文件
  fn_roi=dialog_pickfile(title='选择ROI文件')
  envi_restore_rois, fn_roi
  roi_ids=envi_get_roi_ids(fid=fid, roi_colors=rcolors, $
    roi_names=cnames)

  ;设置分类参数
  cnames=['Unclassified', cnames]  ;类别名称（增加一类“未分类”）
  nc=n_elements(roi_ids)  ;类别数目
  lookup=bytarr(3, nc+1)
  lookup[*, 1:nc]=rcolors  ;类别颜色

  ;获取每个类别ROI的统计信息
  means=fltarr(nb, nc)  ;类别均值
  stdv=fltarr(nb, nc)  ;类别标准差
  cov=fltarr(nb, nb, nc)  ;类别均方差
  for j=0, nc-1 do begin
    roi_dims=[envi_get_roi_dims_ptr(roi_ids[j]), 0, 0, 0, 0]
    envi_doit,'envi_stats_doit',fid=fid, dims=roi_dims, pos=pos,$
      comp_flag=4, mean=c_mean, stdv=c_stdv, cov=c_cov
    means[*, j]=c_mean
    stdv[*, j]=c_stdv
    cov[*, *, j]=c_cov
  endfor

  ;进行分类
  o_fn=dialog_pickfile(title='分类结果保存为')
  envi_doit, 'class_doit', fid=fid, dims=dims, pos=pos, $
    r_fid=r_fid, out_name=o_fn, method=2, mean=means, $
    stdv=stdv, cov=cov, num_classes=nc, lookup=lookup, $
    class_names=cnames

end