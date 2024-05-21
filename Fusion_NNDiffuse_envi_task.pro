pro Fusion_NNDiffuse_envi_task
;基于ENVITask对多光谱和全色数据进行NNDiffuse融合

  e=envi()

  ;读入遥感图像文件
  fn=dialog_pickfile(title='选择多光谱文件')
  raster_mult=e.OpenRaster(fn)
  fn=dialog_pickfile(title='选择全色文件')
  raster_pan=e.OpenRaster(fn)

  ;进行融合
  task=ENVITask('NNDiffusePanSharpening')
  task.input_low_resolution_raster=raster_mult
  task.input_high_resolution_raster=raster_pan
  task.output_raster_uri=dialog_pickfile(title='融合结果保存为')
  task.execute
  raster_fusion=task.output_raster

  ;载入显示
  dataColl=e.data
  dataColl.add, raster_fusion
  view=e.getView()
  layer=view.createLayer(raster_fusion, bands=[3,2,1])

end