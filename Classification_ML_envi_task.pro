pro Classification_ML_envi_task
;基于ENVITask进行最大似然法分类

  e=envi()

  ;读入遥感图像文件和ROI文件
  fn=dialog_pickfile(title='选择遥感数据')
  raster=e.openRaster(fn)
  fn_roi=dialog_pickfile(title='选择ROI文件')
  roi=e.openRoi(fn_ROI)

  ;获取每个类别ROI的信息
  nc=n_elements(roi)
  class_name=strarr(nc)
  class_color=bytarr(3, nc)
  for i=0, nc-1 do begin
    tRoi=roi[i]
    class_name[i]=tRoi.name
    class_color[*, i]=tRoi.color
  endfor
  StatTask=ENVITask('ROIStatistics')
  StatTask.input_raster=raster
  StatTask.input_roi=roi
  StatTask.execute

  ;进行最大似然法分类
  task=ENVITask('MaximumLikelihoodClassification')
  task.input_raster=raster
  task.output_raster_uri=dialog_pickfile(title='分类结果保存为')
  task.class_names=class_name
  task.class_colors=class_color
  task.covariance=StatTask.covariance
  task.mean=StatTask.mean
  task.execute

  ;载入显示
  dataColl=e.data
  dataColl.add, task.output_raster
  view=e.getView()
  layer=view.createLayer(task.output_raster)

end
