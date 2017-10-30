function [defl_bl, base] = BaseLineFit(defl,ZApp, lb,ub)


[m ind] = min(abs(ZApp(1:floor(length(ZApp)/2))-lb));
[m ind2] = min(abs(ZApp(1:floor(length(ZApp)/2))-ub)); 

base = defl(min(ind,ind2):max(ind,ind2));
ZAppFit = ZApp(min(ind,ind2):max(ind,ind2));
BLF = polyfit(ZAppFit,base, 1);

defl_bl = defl - polyval(BLF, ZApp);
