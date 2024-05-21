pro Code_chapter8


;***************    8.4 ENVI Classic二次开发     ***************

envi, /restore_base_save_files
envi_batch_init
envi_batch_exit



;***************    8.4.1 常用的ENVI函数      ***************

; 1. 打开文件

fn=envi_pickfile(/multiple_file, title='Select RS images')
help, fn
print, fn

envi_select, fid=fid, dims=dims, pos=pos
help, fid, dims, pos
dims
pos

fids=envi_get_file_ids()
help, fids
print, fids

fn=envi_pickfile(title='选择ENVI格式文件')
envi_open_file, fn, r_fid=fid
help, fid

fn=envi_pickfile(title='选择GeoTIFF文件')
envi_open_data_file, fn, r_fid=fid1
help, fid1

;2. 查询文件信息

envi_file_query, fid, ns=ns, nl=nl, nb=nb, dims=dims, $
data_type=data_type, interleave=interleave, bnames=bnames
print, ns, nl, nb
dims
help, data_type, interleave
print, bnames

map_info=envi_get_map_info(fid=fid)
help, map_info

;3. 读取数据
envi_file_query, fid, ns=ns, nl=nl, nb=nb, dims=dims, $
  data_type=data_type
;按波段读取数据
dims1=[-1, 101, 200, 51, 300]
data_band=envi_get_data(fid=fid, dims=dims1, pos=1)
help, data_band

data=make_array(ns, nl, nb, type=data_type)
for i=0, nb-1 do data[*,*,i]=envi_get_data(fid=fid, $
  dims=dims, pos=i)
  
;按行读取数据
data_line=envi_get_slice(fid=fid, line=10)
help, data_line
data_line=envi_get_slice(fid=fid, line=5, pos=[0:3], $
xs=20, xe=80)
help, data_line

;4. 保存文件

envi_write_envi_file, data, out_name='Data_ENVI', $
map_info=map_info

o_fn=dialog_pickfile(title='文件保存为')
openw, lun, o_fn, /get_lun
writeu, lun, data
free_lun, lun
envi_setup_head, fname=o_fn, /write, /open, ns=ns, nl=nl, $
nb=nb, data_type=data_type, interleave=interleave, offset=0

envi_enter_data, data, map_info=map_info

pos=[0:nb-1]
envi_output_to_external_format, fid=fid, out_name='Data.tif', $
dims=dims, pos=pos, /tiff

;5. 关闭文件

envi_select, fid=fid
envi_file_mng, id=fid, /remove, /delete

;6. 投影坐标

mc=[0.0, 0.0, 73.42, 53.55]   ;左上角像元对应的经纬度
ps=[0.01, 0.01]   ;分辨率0.01度
map_info=envi_map_info_create(/geographic, mc=mc, ps=ps, $
datum='WGS-84')
help, map_info

ps=[30, 30]
mc=[0.0, 0.0, 661857, 3557313]
map_info=envi_map_info_create(/utm, zone=50, mc=mc, ps=ps, $
datum='WGS-84')

proj=envi_proj_create(/geographic, datum='WGS-84')
help, proj

proj=envi_proj_create(/utm, zone=50, datum='WGS-84')

params=[6378245, 6356863, 0, 117, 500000, 0, 1]
name='TM_117'
proj=envi_proj_create(type=3, name=name, params=params)
print, proj.params

params=[6378245, 6356863, 0, 105, 0, 0, 25, 47]
name='Albers_105'
proj=envi_proj_create(type=9, name=name, params=params)
print, proj.params

envi_select, fid=fid
xf=[10, 100, 200]
yf=[20, 200, 240]
envi_convert_file_coordinates, fid, xf, yf, xmap, ymap, /to_map
print, xmap, ymap
envi_convert_file_coordinates, fid, xf, yf, 662000, 3560000
print, xf, yf

i_proj=envi_proj_create(/geographic, datum='WGS-84')
params=[6378245, 6356863, 0, 105, 0, 0, 25, 47]
o_proj=envi_proj_create(type=9, name='Albers_105', $
params=params)
ixmap=[109, 118]
iymap=[40, 32]
envi_convert_projection_coordinates, ixmap, iymap, i_proj, $
oxmap, oymap, o_proj
print, oxmap, oymap

;7. 矢量文件操作

fn=envi_pickfile(title='选择EVF文件')
evf_id=envi_evf_open(fn)
help, evf_id

envi_evf_info, evf_id, num_recs=nrecs, projection=proj, $
layer_name=layer_name
help, nrecs
help, proj
help, layer_name

o_fn='out_shp'
envi_evf_to_shapefile, evf_id, o_fn

record=envi_evf_read_record(evf_id, 0, type=type)
help, record
print, record[*,0:5]
help, type

envi_evf_close, evf_id
help, evf_id

proj=envi_proj_create(/geographic, datum='WGS-84')
o_fn='Line'
evf_ptr=envi_evf_define_init(o_fn+'.evf', projection=proj, $
data_type=4, layer_name='line')

pts_line=[[118, 32], [119, 32], [120, 29], [118, 29]]
envi_evf_define_add_record, evf_ptr, pts_line

evf_id=envi_evf_define_close(evf_ptr, /return_id)
envi_evf_close, evf_id

attributes={ID: 1, name: 'L1'}
envi_write_dbf_file, o_fn+'.dbf', attributes

proj=envi_proj_create(/geographic, datum='WGS-84')
o_fn='Points'
evf_ptr=envi_evf_define_init(o_fn+'.evf', projection=proj, $
data_type=4, layer_name='points')
pts_point=[[118, 32], [119, 32], [120, 29], [118, 29]]
for i=0,3 do envi_evf_define_add_record, evf_ptr, $
pts_point[*, i]
evf_id=envi_evf_define_close(evf_ptr, /return_id)
envi_evf_close, evf_id
atts=replicate({ID: 1}, 4)
atts.ID=[1:4]
envi_write_dbf_file, o_fn+'.dbf', atts

o_fn='Polygon'
evf_ptr=envi_evf_define_init(o_fn+'.evf', projection=proj, $
data_type=4, layer_name='polygon')
pts_polygon=[[118,32], [119,32], [120,29], [118,29], [118,32]]
envi_evf_define_add_record, evf_ptr, pts_polygon
evf_id=envi_evf_define_close(evf_ptr, /return_id)
envi_evf_close, evf_id
atts={ID: 1}
envi_write_dbf_file, o_fn+'.dbf', atts

;8. ROI操作

fn=envi_pickfile(title='选择ROI文件')
envi_restore_rois, fn

fn=envi_pickfile(title='选择ENVI文件')
envi_open_file, fn, r_fid=fid
roi_ids=envi_get_roi_ids(fid=fid, roi_names=rnames, $
roi_colors=rcolors)
help, roi_ids
print, roi_ids
help, rnames
print, rnames
help, rcolors
print, rcolors

envi_get_roi_information, roi_ids, roi_names=rnames, $
npts=npts, roi_colors=rcolors
help, npts
print, npts
help, rnames, rcolors

roi_loc=envi_get_roi(roi_ids[0], roi_name=rname)
help, rname
help, roi_loc
print, roi_loc[0:5]

roi_pointer=envi_get_roi_dims_ptr(roi_ids[0])
help, roi_pointer

envi_file_query, fid, ns=ns, nl=nl
roi_id_new=envi_create_roi(ns=ns, nl=nl, name='new roi', $
color=1)

xpts=[100, 105, 120, 105]
ypts=[200, 200, 240, 240]
envi_define_roi, roi_id_new, /polygon, xpts=xpts, ypts=ypts

fn=envi_pickfile(title='ROI保存为')+'.roi'
envi_save_rois, fn, roi_ids

data_roi=envi_get_roi_data(roi_ids[0], fid=fid, pos=[2, 3, 4])
help, data_roi
print,data_roi[*, 0:5]

print, roi_ids
envi_delete_rois, roi_ids[0:2]
roi_ids=envi_get_roi_ids(fid=fid)
print, roi_ids


;***************    8.4.2 envi_doit函数      ***************

;1. 文件统计

fn=dialog_pickfile(title='选择要进行统计的ENVI文件')
envi_open_file, fn, r_fid=fid
envi_file_query, fid, ns=ns, nl=nl, nb=nb, dims=dims
pos=[2:5]
envi_doit,'envi_stats_doit', fid=fid, dims=dims, pos=pos, $
comp_flag=3, dmin=dmin, dmax=dmax, mean=avg, stdv=stdv, hist=hist
print, dmin, dmax, avg, stdv
help, hist

;2. 文件储存顺序转换

fn=dialog_pickfile(title='选择ENVI文件')
envi_open_file, fn, r_fid=fid
envi_file_query, fid, nb=nb, dims=dims, interleave=interleave
print,interleave  ;原数据存储顺序
pos=[0:nb-1]
envi_doit, 'convert_doit', fid=fid, dims=dims, pos=pos, $
r_fid=fid_BIP, out_name='Data_BIP', o_interleave=2
envi_file_query, fid_BIP, interleave=interleave
print,interleave  ;转换后数据存储顺序

;3. 影像裁切与重采样

fn=dialog_pickfile(title='选择ENVI文件')
envi_open_file, fn, r_fid=fid
envi_file_query, fid, nb=nb, dims=dims
pos=[0:nb-1]
dims=[-1, 100, 499, 200, 499]
envi_doit, 'resize_doit', fid=fid, dims=dims, pos=pos, $
r_fid=fid_resized, /in_memory, interp=3, rfact=[2,2]

;6. 直方图拉伸

fn=dialog_pickfile(title='选择要进行拉伸的OLI文件')
envi_open_file, fn, r_fid=fid
envi_file_query, fid, ns=ns, nl=nl, nb=nb, dims=dims
pos=[5, 4, 3]
envi_doit, 'stretch_doit', fid=fid, dims=dims, pos=pos, $
r_fid=fid_stretched, /in_memory, method=1, out_dt=1, range_by=0, $
i_min=2.0, i_max=98.0, out_min=0, out_max=255


;***************    8.5.1 常用的ENVI对象      ***************

;1. ENVI对象

e=envi()
help, e
print, e

fn=dialog_pickfile(title='Select ENVI file')
raster=e.OpenRaster(fn)
fn=dialog_pickfile(title='Select evf file')
vec=e.OpenVector(fn)
view=envi.GetView()
help, raster, vec, view

e.data

;2. ENVIRaster对象

data=raster.getData(bands=[0,1,2], sub_rect=[0, 0, 199, 299])
help, data
raster.nband
raster.data_type
raster.metadata

data_full=raster.GetData()
tfn=e.GetTemporaryFilename()
raster1=enviRaster(data_full, URI=tfn, inherits_from=raster)
raster1.setData, data_full
raster1.save
o_fn=dialog_pickfile(title='Save as')
raster.export, o_fn, 'envi'

fid=ENVIRasterToFID(raster)
envi_file_query, fid, nb=nb, dims=dims
pos=[0:nb-1]
envi_doit, 'resize_doit', fid=fid, dims=dims, pos=pos, $
r_fid=fid_resized, /in_memory, rfact=[2,2]
raster_resized=ENVIFIDToRaster(fid_resized)

;3. ENVIVector对象

vec.data_range
vec.coord_sys
vec.close
e.data


;4. ENVIRasterMetadata对象

metadata=raster.metadata
metadata

metadata.UpdateItem, 'band names', $
['b1', 'b2', 'b3', 'b4', 'b5', 'b6', 'b7']
metadata

bnames=metadata['band names']
print, bnames

;5. ENVIStandardRasterSpatialRef对象

spatialRef=raster.spatialRef
spatialRef
xf=[10, 100, 200]
yf=[20, 200, 240]
spatialRef.ConvertFileToMap, xf, yf, xmap, ymap
print, xmap, ymap
spatialRef.ConvertMapToLonLat, xmap, ymap, lon, lat
print, lon, lat

spatialRef1=ENVIStandardRasterSpatialRef(/geoGCS , $
coord_sys_code=4326, pixel_size=[0.01, 0.01], $
tie_point_pixel=[0, 0],  tie_point_map=[-180, 90])
spatialRef1
spatialRef.ConvertMapToMap, xmap, ymap, xmap1, ymap1,$
spatialRef1
print, xmap1, ymap1


;6. ENVIDataCollection对象

dataColl=e.data
dataColl.count()
raster2=ENVISubsetRaster(Raster, sub_rect=[100, 100, 299, 399])
dataColl.add, raster2
print, dataColl.get()

;7. ENVIView对象

view=e.GetView()
layer=view.CreateLayer(raster)


;***************    8.5.2 ENVI Task      ***************

e.Task_Names

;1. 文件统计

e=envi()
fn=dialog_pickfile(title='选择遥感数据')
raster=e.openraster(fn)
task=envitask('rasterstatistics')
task.input_raster=raster
compute_histograms=1
task.output_report_uri='stat.txt'
task.compute_histograms=1
task.execute
print, task.mean, task.min, task.max, format='(7f9.1)'

;2. 文件储存顺序转换

print, raster.interleave
task=ENVITask('ConvertInterleave')
task.input_raster=raster
task.interleave='BIL'
task.execute
raster1=task.output_raster
print, raster1.interleave

;3. 影像裁切与重采样

task=ENVITask('SubsetRaster')
task.input_raster=raster
task.sub_rect=[100, 200, 499, 499]
task.execute
raster_clip=task.output_raster
task=ENVITask('PixelScaleResampleRaster')
task.input_raster=raster_clip
task.pixel_scale=[2, 2]
task.output_raster_uri='Data_resized'
task.execute


end