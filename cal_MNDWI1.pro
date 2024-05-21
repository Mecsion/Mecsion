pro cal_MNDWI1
;读取OLI数据，计算MNDWI并保存

  ;打开OLI数据文件
  fn=dialog_pickfile(title='选择OLI数据')
  envi_open_file, fn, r_fid=fid
  envi_file_query, fid, ns=ns, nl=nl, nb=nb, dims=dims
  map_info=envi_get_map_info(fid=fid)

  ;计算MNDWI
  G=envi_get_data(fid=fid, dims=dims, pos=2)
  SWIR=envi_get_data(fid=fid, dims=dims, pos=5)
  MNDWI=(float(G)-SWIR)/(float(G)+SWIR)

  ;保存MNDWI
  o_fn=dialog_pickfile(title='MNDWI保存为')
  envi_write_envi_file, MNDWI, out_name=o_fn, bnames='MNDWI', $
    map_info=map_info

end