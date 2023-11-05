# coding=utf-8
#-*- coding:utf-8 -*-
import random
class charactor:
    def __init__(self):
        self.name=input('游戏开始！！！！，输入你的ID:')
    def guess(self):
        result=str(input('你的选择是？石头/剪刀/布:'))
        print(self.name+'选择'+result)
        return result

class computer:
    def __init__(self):
        self.name = '永不言败的超级猜拳系统'
    def guess(self):
        array = ['石头','剪刀','布']
        result=random.choice(array)
        print(self.name+'选择'+result)
        return result

class gameRules:
    def __init__(self,name,p1,p2,times):
        self.name=name
        self.p1=p1
        self.p2=p2
        print(self.name+'判定为:')
    def cauclate(self,p1,p2,chuquan):
        if chuquan[0]==chuquan[1]:
            print('双方平手')
        elif chuquan[0]=='石头'and chuquan[1]=='布':
            print(p2.name+'胜')
            return 2
        elif chuquan[0]=='石头'and chuquan[1]=='剪刀':
            print(p1.name+'胜')
            return 1
        elif chuquan[0]=='剪刀'and chuquan[1]=='石头':
            print(p2.name+'胜')
            return 2
        elif chuquan[0] == '剪刀' and chuquan[1] == '布':
            print(p1.name+'胜')
            return 1
        elif chuquan[0]=='布'and chuquan[1]=='石头':
            print(p1.name+'胜')
            return 1
        elif chuquan[0] == '布' and chuquan[1] == '剪刀':
            print(p2.name+'胜')
            return 2
    def __del__(self):
        print('游戏结束.'+self.name+'启动自毁程序')

switch='是'
cout=1
p1 = charactor()
p2 = computer()
p1_score=0
p2_score=0
while switch=='是':
    result1=p1.guess()
    result2=p2.guess()
    Kusuru=gameRules('不可名状的猜拳系统',result1,result2,0)
    item=Kusuru.cauclate(p1,p2,[result1,result2])
    print('这是第'+str(cout)+'局')
    cout+=1
    if(item==1):
        p1_score+=1
    elif(item==2):
        p2_score+=1
    print('当前比分为:'+str(p1_score)+':'+str(p2_score))
    switch=input('本局游戏结束，是否要进行下一句游戏？是/否:')
