clear all;
close all;
load data
rets=log(hs300(2:end))-log(hs300(1:end-1));
hist(rets,100)