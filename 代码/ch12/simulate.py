# coding=utf-8

'''
模拟数据验证模型有效性：

B股票的价格满足对数正态分布，其中µ，∆t，σ，和ǫ(tk)的均值方差需提前设置好
在此设µ=0.3
σ=0.1
∆t = 1/251
ǫ(tk)的均值为0，标准差为1.

价差的价格方程中需要设置
∆t = 1/251
δ(tk)分布的均值为0，标准差为1，且无自相关性
θ = 1
k = 5
η = 0.5
ǫ(tk) and δ(tk)的相关系数为0.19

初始B的价格为100,A初始价格为270
'''

import numpy as np
from math import exp
import pandas as pd
import matplotlib.pyplot as plt

'''生成B的价格序列(1000个),a1为随机扰动项'''
a1 = np.random.randn(1000, )
Blist = []
for i in range(1000):
    if i == 0:
        Blist.append(100)
    else:
        Blist.append(Blist[-1] * exp(0.3 / 251 + 0.1 * a1[i] * ((1 / 251) ** 0.5)))

'''生成X的价格序列，a2为随机扰动项'''
a2 = np.random.randn(1000, )
Xlist = []
for i in range(1000):
    if i == 0:
        Xlist.append(np.log(270 / 100))
    else:
        Xlist.append(1 * (1 - exp(-5 / 251)) + exp(-5 / 251) * Xlist[-1] + (
                (0.5 ** 2) / (2 * 5) * (1 - exp(-2 * 5 / 251))) ** 0.5 * a2[i])

'''由B和X可得A的价格序列'''
Alist = []
for i in range(1000):
    Alist.append(Blist[i] * exp(Xlist[i]))

'''动态仓位h,设 γ = −100'''
hlist = []
Vlist = [1]
T = 1
for i in range(1000):
    beta_t = 1 / (
            2 * 0.5 ** 2 * (1 - 101 ** 0.5 - (1 + 101 ** 0.5) * exp(2 * 5 * (T / 251 - 0 / 251) / (101 ** 0.5)))) * (
                     -100 * 101 ** 0.5 * (0.5 ** 2 + 2 * 0.19 * 0.5 * 0.1) * (
                     (1 - exp(2 * 5 * (T / 251 - 0 / 251) / (101 ** 0.5))) ** 2) + 100 * (
                             0.5 ** 2 + 2 * 0.19 * 0.5 * 0.1 + 2 * 5) * (
                             1 - exp(2 * 5 * (T / 251 - 0 / 251) / (101 ** 0.5))))
    alpha_t = 5 * (1 - 101 ** 0.5) / (2 * 0.5 ** 2) * (1 + 2 * 101 ** 0.5 / (
            1 - 101 ** 0.5 - (1 + 101 ** 0.5) * exp(2 * 5 * (T / 251 - 0 / 251) / (101 ** 0.5))))
    hlist.append(1 / 101 * (beta_t + 2 * Xlist[i] * alpha_t - 5 * (Xlist[i] - 1) / (0.5 ** 2) + 0.19 * 0.1 / 0.5 + 0.5))
    # 根据h计算动态增益,为了简化，忽略无风险利率,初始权益为1
    if 0 < i < 999:
        dV_t = Vlist[-1] * (
                hlist[i] * (Alist[i + 1] - Alist[i]) / Alist[i] - hlist[i] * (Blist[i + 1] - Blist[i]) / Blist[i])
        Vlist.append(Vlist[-1] + dV_t)

'''第一张图是收益曲线'''
pd.Series(Vlist).plot()
plt.show()

'''第二张图是A和B的价格曲线'''
pd.Series(Blist).plot()
pd.Series(Alist).plot()
plt.show()
