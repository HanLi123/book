# -*- coding: utf-8 -*-
"""
Created on Mon Feb  4 10:48:47 2019

@author: lihan
"""
import numpy as np
from common import DAYS_IN_YEAR, ROOT_DAYS_IN_YEAR
import matplotlib.pyplot as plt


def skew_returns_annualised(annualSR=1.0, want_skew=0.0, voltarget=0.20, size=10000):
    annual_rets=annualSR*voltarget
    daily_rets=annual_rets/DAYS_IN_YEAR
    daily_vol=voltarget/ROOT_DAYS_IN_YEAR
    
    return skew_returns(want_mean=daily_rets,  want_stdev=daily_vol,want_skew=want_skew, size=size)

def skew_returns(want_mean,  want_stdev, want_skew, size=10000):
    
    EPSILON=0.0000001
    shapeparam=(2/(EPSILON+abs(want_skew)))**2
    scaleparam=want_stdev/(shapeparam)**.5
    
    sample = list(np.random.gamma(shapeparam, scaleparam, size=size))
    
    if want_skew<0.0:
        signadj=-1.0
    else:
        signadj=1.0
    
    natural_mean=shapeparam*scaleparam*signadj
    mean_adjustment=want_mean - natural_mean 

    sample=[(x*signadj)+mean_adjustment for x in sample]
    
    return sample


ans=skew_returns_annualised(annualSR=1.0, want_skew=1.0, size=2500)
plt.hist(list(ans), 50, density=True, facecolor='g', alpha=0.75)
plt.grid(True)
plt.show()

ans=skew_returns_annualised(annualSR=1.0, want_skew=-1.0, size=2500)
plt.hist(list(ans), 50, density=True, facecolor='g', alpha=0.75)
plt.grid(True)
plt.show()

