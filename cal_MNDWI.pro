function cal_MNDWI, data
  ;对内存中的OLI数据计算MNDWI

  G=data[*, *, 2]
  SWIR=data[*, *, 5]
  MNDWI=(float(G)-SWIR)/(float(G)+SWIR)

  return, MNDWI

end