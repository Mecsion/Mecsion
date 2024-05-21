pro PCA_transform
  ;基于ENVI_doit进行主成分变换

  fn=dialog_pickfile(title='选择遥感数据')
  envi_open_file, fn, r_fid=fid
  envi_file_query, fid, nb=nb, dims=dims

  pos=[0:nb-1]
  O_fn=dialog_pickfile(title='结果保存为')
  envi_doit,'envi_stats_doit', fid=fid, dims=dims, pos=pos, $
    comp_flag=5, mean=avg, eval=eval, evec=evec
  envi_doit, 'pc_rotate', fid=fid, dims=dims, pos=pos, $
    r_fid=fid_PCA, out_dt=4, out_name=o_fn, /forward, $
    mean=avg, eval=eval, evec=evec

end