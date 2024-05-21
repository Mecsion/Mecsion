pro Mosaic_data
;基于ENVI_doit读取两个文件进行镶嵌处理

  fn=dialog_pickfile(title='选择待镶嵌文件1')
  envi_open_file, fn, r_fid=fid1
  envi_file_query, fid1, ns=ns1, nl=nl1, nb=nb1, dims=dims1, $
    data_type=data_type
  map_info=envi_get_map_info(fid=fid1)
  fn=dialog_pickfile(title='选择待镶嵌文件2')
  envi_open_file, fn, r_fid=fid2
  envi_file_query, fid2, ns=ns2, nl=nl2, nb=nb2, dims=dims2

  pos1=lindgen(nb1)
  pos2=lindgen(nb2)
  fids=[fid1, fid2]  ;待镶嵌各文件fid号数组
  dims=[[dims1], [dims2]]  ;待镶嵌各文件dims数组
  pos=[[pos1],[pos2]]  ;待镶嵌各文件pos数组
  use_see_through=[1, 1]  ;待镶嵌各文件背景值是否忽略
  see_through_val=[0, 0]  ;待镶嵌各文件背景值为0
  pixel_size=map_info.ps  ;镶嵌结果文件的空间分辨率

  ;调用georef_mosaic_setup计算xsize、ysize、x0、y0
  ;注意要先打开georef_mosaic_setup程序文件进行编译，或把该程序放到本程序后
  georef_mosaic_setup, fids=fids, dims=dims, map_info=map_info, $
    out_ps=pixel_size, xsize=xsize, ysize=ysize, x0=x0, y0=y0

  ;进行镶嵌
  o_fn=dialog_pickfile(title='镶嵌结果保存为')
  envi_doit, 'mosaic_doit', fid=fids, dims=dims, pos=pos, $
    r_fid=fid_mosaic, out_name=o_fn, /georef,  $
    map_info=map_info, see_through_val=see_through_val, $
    use_see_through=use_see_through, background=0, $
    pixel_size=pixel_size, out_dt=data_type, xsize=xsize, $
    ysize=ysize, x0=x0, y0=y0

end
