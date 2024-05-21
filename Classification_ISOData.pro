pro Classification_ISOData
;运用ENVITask进行ISOData法分类

  e=envi()

  ;读入遥感图像文件
  fn=dialog_pickfile(title='选择遥感图像文件')
  raster=e.openRaster(fn)

  ;进行ISOData分类
  task=ENVITask('ISODATAClassification')
  task.input_raster=raster
  task.output_raster_uri=dialog_pickfile(title='分类结果保存为')
  task.number_of_classes=7
  task.iterations=20
  task.change_threshold_percent=5
  task.execute

  ;载入显示
  dataColl=e.data
  dataColl.add, task.output_raster
  view=e.getView()
  layer=view.createLayer(task.output_raster)

end
