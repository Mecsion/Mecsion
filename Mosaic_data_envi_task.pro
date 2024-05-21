pro Mosaic_data_envi_task
;基于ENVITask读取两个文件进行镶嵌处理

  e=envi()

  ;读入待镶嵌图像文件
  fn=dialog_pickfile(title='选择待镶嵌文件1')
  raster1=e.OpenRaster(fn)
  fn=dialog_pickfile(title='选择待镶嵌文件2')
  raster2=e.OpenRaster(fn)

  ;设置元数据中的data ignore value值
  rasters=[raster1, raster2]
  for i=0, 1 do begin
    tRaster=rasters[i]
    metadata=tRaster.metadata
    tags_meta=metadata.tags
    if max(strcmp(tags_meta, 'data ignore value', /fold_case)) $
      ge 1 then begin
      metadata.updateItem, 'data ignore value', 0
    endif else begin
      metadata.addItem, 'data ignore value', 0
    endelse
  endfor

  ;进行镶嵌
  task=ENVITask('BuildMosaicRaster')
  task.input_rasters=rasters
  task.color_matching_method='Histogram Matching'
  task.color_matching_actions=['reference', 'none']
  task.feathering_method='seamline'
  task.data_ignore_value=0
  task.output_raster_uri=dialog_pickfile(title='镶嵌结果保存为')
  task.execute
  raster_mosaic=task.output_raster

  ;载入显示
  dataColl=e.data
  dataColl.add, raster_mosaic
  view=e.getView()
  layer=view.createLayer(raster_mosaic, bands=[4,3,2])
  view.Zoom, /full_extent

end
