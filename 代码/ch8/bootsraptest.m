clear all;
close all;
load ret;
load data;
ret_asset=log(hs300(2:end))-log(hs300(1:end-1));
ret_asset=[ret_asset;-1*ret_asset];
bootstat = bootstrp(10000,@mean,ret_asset);
benchmark=mean(ret);
hist(bootstat,100)
hold on
plot(ones(350,1)*benchmark,1:350)