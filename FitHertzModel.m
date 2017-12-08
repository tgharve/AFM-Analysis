function [Ecell, QoF] = FitHertzModel(force, disp, Rtip) 
nu = 0.45;
nu2 = 0.2;
E2 = 64E9;

F = force(find(disp > 0, 1):find(disp > 300, 1));
F = F - min(F); 
d = disp(find(disp > 0, 1):find(disp > 300, 1)); 
p = polyfitZero(d*1E-9, power(F*1E-9,(2/3))-F(1)^(2/3)*1E-9,1);  
Eeq = sqrt((9/16)*p(1)^3/(Rtip*1E-6));
Ecell = (E2*Eeq*(1-nu^2))/(E2-Eeq*(1-nu2^2));
F_calc = (4/3)*Eeq*sqrt(Rtip*1E-6).*power((d*1E-9),(3/2));
QoF = rsquare(F,F_calc*1E9);