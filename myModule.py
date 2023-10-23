import numpy as np
pi=3.14
def area (R):
    surface_area=4*pi*R*R
    return surface_area

def stastics(list):
    MAX=max(list)
    MIN=min(list)
    Average=sum(list)/len(list)
    Std=np.std(list)
    print("该表中数据的最大值为",MAX)
    print("该表中数据的最小值为",MIN)
    print("该表中数据的平均值为",Average)
    print("该表中数据的标准方差为",Std)