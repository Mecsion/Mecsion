pro PCA_transform_envi_task
;基于ENVITask对多光谱数据进行主成分变换

  e=envi()

  ;读入遥感图像文件
  fn=dialog_pickfile(title='选择遥感图像文件')
  raster=e.OpenRaster(fn)

  ;进行主成分变换
  task=ENVITask('ForwardPCATransform')
  task.input_raster=raster
  task.output_raster_uri=dialog_pickfile(title='结果保存为')
  task.execute

end