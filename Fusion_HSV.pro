pro Fusion_HSV
;基于ENVI_doit对多光谱和全色数据进行HSV融合

  ;打开数据
  fn=dialog_pickfile(title='选择多光谱文件')
  envi_open_file, fn, r_fid=fid_mult
  envi_file_query, fid_mult, nb=nb, dims=dims_mult
  fn=dialog_pickfile(title='选择全色文件')
  envi_open_file, fn, r_fid=fid_pan
  envi_file_query, fid_pan, dims=dims_pan

  ;进行2%线性拉伸
  pos=[0:nb-1]
  envi_doit, 'stretch_doit', fid=fid_mult, dims=dims_mult, $
    pos=pos, r_fid=fid_stretched, /in_memory, method=1, out_dt=1, $
    range_by=0, i_min=2.0, i_max=98.0, out_min=0, out_max=255

  ;HSV融合
  fids=replicate(fid_stretched, 3)
  pos=[3, 2, 1]  ;取第4、3、2波段RGB合成后融合
  out_bname=['Red', 'Green', 'Blue']
  o_fn=dialog_pickfile(title='结果保存为')
  envi_doit, 'sharpen_doit', fid=fids, pos=pos, f_fid=fid_pan, $
    f_dims=dims_pan, f_pos=0, r_fid=fid_HSV, out_name=o_fn, $
    method=0, interp=1, out_bname=out_bname

end
