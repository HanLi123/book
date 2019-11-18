# coding=utf-8

'''
真实数据验证模型有效性：

使用建设银行和农业银行的日收盘价

'''

import pandas as pd
import numpy as np
from math import exp
import matplotlib.pyplot as plt

data = pd.read_excel('stock-data.xlsx',0 ,index_col=0)

data1 = data.iloc[:, 0].values
data2 = data.iloc[:, 1].values

Sdata = np.log(data2)
Xdata = np.log(data1) - np.log(data2)

'''
真实回测前,需预设一些参数：
'''
N = 60
T = 1
r = -100
Vlist = [1]

for i in range(N, len(data) - 1):  # 滚动窗口计算参数估计值
    m = (Sdata[i] - Sdata[i - N]) / N
    SS = (np.power((pd.Series(Sdata[i - N:i + 1]) - pd.Series(Sdata[i - N:i + 1]).shift(1)), 2)[1:].sum() - 2 * m * (
            Sdata[i] - Sdata[i - N]) + N * m ** 2) / N
    p = 1 / (N * np.power(Xdata[i - N:i], 2).sum() - Xdata[i - N:i].sum() ** 2) * (
            N * (pd.Series(Xdata[i - N:i + 1]) * pd.Series(Xdata[i - N:i + 1]))[1:].sum() - (
            Xdata[i] - Xdata[i - N]) * Xdata[i - N:i].sum() - np.power(Xdata[i - N:i].sum(), 2))
    if p<0:
        p=-p
    q = (Xdata[i] - Xdata[i - N] + Xdata[i - N:i].sum() * (1 - p)) / N
    VV = 1 / N * (Xdata[i] ** 2 - Xdata[i - N] ** 2 + (1 + p ** 2) * np.power(Xdata[i - N:i], 2).sum() -
                  2 * p * (pd.Series(Xdata[i - N:i + 1]) * pd.Series(Xdata[i - N:i + 1]))[1:].sum() - N * q)
    if VV<0:
        VV=-VV
    C = 1 / (N * VV ** 0.5 * SS ** 0.5) * (
            (pd.Series(Xdata[i - N:i + 1]) * (pd.Series(Sdata[i - N:i + 1]) - pd.Series(Sdata[i - N:i + 1]).shift(1)))[
            1:].sum() - p * (pd.Series(Xdata[i - N:i + 1]) * (
            pd.Series(Sdata[i - N:i + 1]).shift(-1) - pd.Series(Sdata[i - N:i + 1])))[:-1].sum() - m * (
                    Xdata[i] - Xdata[i - N]) - m * (1 - p) * pd.Series(Xdata[i - N:i]).sum())
    std_ = (SS / 1) ** 0.5
    u_ = m / 1 + 0.5 * std_ ** 2
    k_ = -(np.log(p) / 1)
    theta_ = q / (1 - p)
    eta_ = (2 * k_ * VV / (1 - p ** 2)) ** 0.5
    rho_ = k_ * C * (VV ** 0.5) * (SS ** 0.5) / (eta_ * theta_ * (1 - p))
    beta_t = 1 / (
            2 * eta_ ** 2 * (1 - 101 ** 0.5 - (1 + 101 ** 0.5) * exp(2 * k_ * (T  - 0) / (101 ** 0.5)))) * (
                     -100 * 101 ** 0.5 * (eta_ ** 2 + 2 * rho_ * std_* eta_) * (
                     (1 - exp(2 * k_ * (T  - 0 ) / (101 ** 0.5))) ** 2) + 100 * (
                             eta_ ** 2 + 2 * rho_ * std_ * eta_ + 2 * k_*theta_) * (
                             1 - exp(2 * k_ * (T  - 0) / (101 ** 0.5))))
    alpha_t=k_ * (1 - 101 ** 0.5) / (2 * eta_ ** 2) * (1 + 2 * 101 ** 0.5 / (
            1 - 101 ** 0.5 - (1 + 101 ** 0.5) * exp(2 * k_ * (T  - 0 ) / (101 ** 0.5))))
    h_t=1 / 101 * (beta_t + 2 * Xdata[i] * alpha_t - k_ * (Xdata[i] - theta_) / (eta_ ** 2) + rho_ * std_ / eta_ + 0.5)
    dV_t = Vlist[-1] * (
            h_t * (data1[i + 1] - data1[i]) / data1[i] - h_t * (data2[i + 1] - data2[i]) / data2[i])
    Vlist.append(Vlist[-1] + dV_t)


'''第一幅图为价差曲线'''
pd.Series(Xdata).plot()
plt.show()

'''第二幅图为收益曲线'''
pd.Series(Vlist).plot()
plt.show()