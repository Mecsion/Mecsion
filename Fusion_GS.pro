pro Fusion_GS
  ;基于ENVI_doit对多光谱和全色数据进行Gram-Schmidt融合

  ;打开数据
  fn=dialog_pickfile(title='选择多光谱文件')
  envi_open_file, fn, r_fid=fid_mult
  envi_file_query, fid_mult, nb=nb, dims=dims_mult
  fn=dialog_pickfile(title='选择全色文件')
  envi_open_file, fn, r_fid=fid_pan
  envi_file_query, fid_pan, dims=dims_pan

  ;Gram-Schmidt融合
  pos=[0:nb-1]
  o_fn=dialog_pickfile(title='结果保存为')
  envi_doit, 'envi_gs_sharpen_doit', fid=fid_mult, dims=dims_mult, $
    pos=pos, hires_fid=fid_pan, hires_dims=dims_pan, hires_pos=0, $
    r_fid=fid_GS, out_name=o_fn, method=0, interp=1

end
