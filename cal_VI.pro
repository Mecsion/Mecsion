function cal_VI, r, nir, key=key
;计算NDVI或者RVI
;参数r和nir分别为红波段和近红外波
;关键字key用于设置计算NDVI还是RVI

  if key eq 0 then begin
    ;计算NDVI
    return, (float(nir)-r)/(float(nir)+r)
  endif else begin
    ;计算RVI
    return, float(nir)/r
  endelse

end