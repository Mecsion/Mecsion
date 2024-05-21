pro Reg_image_envi_task
;基于ENVITask对遥感图像自动寻找控制点进行配准

  e=envi()

  ;读入基准图像和待校正图像文件
  fn=dialog_pickfile(title='选择基准图像')
  raster1=e.OpenRaster(fn)
  fn=dialog_pickfile(title='选择待校正图像')
  raster2=e.OpenRaster(fn)

  ;自动寻找控制点
  task=ENVITask('GenerateTiePointsByCrossCorrelation')
  task.input_raster1=raster1
  task.input_raster2=raster2
  task.execute
  tiePoints1=task.output_tiepoints

  ;进行控制点筛选
  task_filter=ENVITask('FilterTiePointsByGlobalTransform')
  task_filter.input_tiepoints=tiePoints1
  task_filter.execute
  tiePoints2=task_filter.output_tiepoints

  ;进行配准
  task_reg=ENVITask('ImageToImageRegistration')
  task_reg.input_tiepoints=tiePoints2
  task_reg.polynomial_degree=2
  task_reg.output_raster_uri=dialog_pickfile(title='结果保存为')
  task_reg.execute
  raster_reg=task_reg.output_raster

  ;载入显示
  dataColl=e.data
  dataColl.add, raster_reg
  view=e.getView()
  layer1=view.createLayer(raster1, bands=[3,2,1])
  layer2=view.createLayer(raster2, bands=[3,2,1])
  layer3=view.createLayer(raster_reg, bands=[3,2,1])

end
