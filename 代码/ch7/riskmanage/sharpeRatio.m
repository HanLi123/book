  function sharpe=sharpeRatio(s)

riskless=2.5/100;
length=365;
length2=252;
dailyret=[0;s(2:end)./s(1:end-1)-1];
%   dailyret=price2ret(s);
cash=(1+riskless)^(1/length)-1;
excessRet=dailyret-cash;
sharpe=sqrt(length2)*mean(excessRet)/std(excessRet);

