pro Reg_image
;基于ENVI_doit对遥感图像进行基于地理坐标的配准

  ;读入图像文件
  fn=dialog_pickfile(title='选择待配准文件')
  envi_open_file, fn, r_fid=fid_warp
  envi_file_query, fid_warp, ns=ns, nl=nl, nb=nb, dims=dims_warp
  pos_warp=indgen(nb)

  ;读入配准控制点信息
  fn=dialog_pickfile(title='选择控制点文件')
  data=read_csv(fn, count=npts)
  pts=fltarr(4, npts)
  for i=0, 3 do pts[i, *]=data.(i)

  ;将控制点的经纬度转换为UTM投影下坐标
  i_proj=envi_proj_create(/geographic, datum='WGS-84')
  proj=envi_proj_create(/utm, zone=50, datum='WGS-84')
  envi_convert_projection_coordinates, pts[0, *], pts[1, *], $
    i_proj, oxmap, oymap, proj
  pts[0, *]=oxmap
  pts[1, *]=oymap

  ;进行配准
  pixel_size=[30, 30]  ;像元分辨率
  o_fn=dialog_pickfile(title='配准结果保存为')
  envi_doit, 'envi_register_doit', w_fid=fid_warp, $
    w_dims=dims_warp, w_pos=pos_warp, r_fid=fid_reg, $
    out_name=o_fn, pts=pts,  proj=proj, method=4, $
    pixel_size=pixel_size

end
