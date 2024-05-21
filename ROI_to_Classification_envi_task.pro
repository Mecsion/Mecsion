pro ROI_to_Classification_envi_task
;基于ENVITask将ROI转为分类文件

  e=envi()

  ;读入遥感图像文件和ROI文件
  fn=dialog_pickfile(title='选择遥感数据')
  raster=e.openRaster(fn)
  fn_roi=dialog_pickfile(title='选择ROI文件')
  roi=e.openRoi(fn_ROI)

  ;将ROI转为分类对象
  task=ENVITask('ROIToClassification')
  task.input_raster=raster
  task.input_roi=roi
  task.output_raster_uri=dialog_pickfile(title='结果保存为')
  task.execute

  ;载入显示
  dataColl=e.data
  dataColl.add, task.output_raster
  view=e.getView()
  layer=view.createLayer(task.output_raster)

end