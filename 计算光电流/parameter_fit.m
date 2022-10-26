clc,clear;
load('data01.mat');
t=data_01(:,1);
t2=[0:1e-8:1e-6];
photocurrent=data_01(:,2);
% 用法为fittype('自定义函数','independent','自变量','coefficients',{'系数1','系数2'……});
% f=fittype('a*cos(k*t)*exp(w*t)','independent','t','coefficients',{'a','k','w'});
plot(t,photocurrent,'r*');
hold on;
f=fittype('A*(w+L_p*erf(sqrt(t/taop))+L_n*erf(sqrt(t/taon)))','independent','t','coefficients',{'A','w','L_p','L_n','taop','taon'});
cfun=fit(t2,photocurrent,f);%根据自定义拟合函数f来拟合数据x，y
t=data_01(:,1);
yi=cfun(t);
plot(t,yi,'b-')


