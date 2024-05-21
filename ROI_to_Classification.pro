pro ROI_to_Classification
;基于ENVI_doit将ROI转为分类文件
  
  ;读入遥感图像文件和ROI文件
  fn_image=envi_pickfile(title='选择遥感数据')
  envi_open_file, fn_image, r_fid=fid
  fn_ROI=envi_pickfile(title='选择ROI文件')
  envi_restore_rois, fn_ROI
  roi_ids=envi_get_roi_ids(fid=fid)
  
  ;将ROI转为分类对象 
  o_fn=envi_pickfile(title='结果保存为')
  envi_doit,'envi_roi_to_image_doit', fid=fid, roi_ids=roi_ids, $
  r_fid=fid_class, out_name=o_fn

end