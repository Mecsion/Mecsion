import random
import myModule

earthRadius=6317
moonRadius=1737
list1=[]
for i in range(10):
    list1.append(random.randint(1,10))

print("地球的表面积为",myModule.area(earthRadius))
print("月球的表面积为",myModule.area(moonRadius))
myModule.stastics(list1)