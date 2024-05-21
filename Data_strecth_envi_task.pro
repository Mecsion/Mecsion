pro Data_strecth_envi_task
;基于ENVITask进行直方图线性拉伸

  e=envi()

  ;读入待图像文件
  fn=dialog_pickfile(title='选择遥感图像')
  raster=e.OpenRaster(fn)

  ;进行线性拉伸
  task=ENVITask('LinearPercentStretchRaster')
  task.input_raster=raster
  task.percent=2
  task.execute
  raster_stretched=task.output_raster

  ;载入显示
  dataColl=e.data
  dataColl.add, raster_stretched
  view=e.getView()
  layer=view.createLayer(raster_stretched)

end
