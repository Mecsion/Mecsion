function spectra_deriv, spectra
  ;对波谱曲线平滑后求导

  spectra_smoothed=smooth(spectra, 3)  ;平滑滤波
  return, deriv(spectra_smoothed)  ;一阶求导

end