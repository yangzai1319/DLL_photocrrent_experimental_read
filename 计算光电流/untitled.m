clc,clear;
fun1=inline('beta(1).*(1-exp(-beta(2).*t))','beta','t');
fun2=inline('beta(1).*(1-exp(-beta(2).*beta(4)))*exp(-beta(3)*(t-beta(4)))','beta','t');
fun=@(beta,t)((t<0.5).*fun1(beta,t)+(t>=0.5).*fun2(beta,t));
t=[0 0.0833 0.25 0.5 1 2];
c=[0 0.0833 1.2491 1.7025 0.2623 0.0757];
beta=nlinfit(t,c,fun,[-0.05  -6.8 3.7 0.5]);
A=beta(1);
k1=beta(2);
k2=beta(3);
T=beta(4);
warning off all
c1=beta(1).*(1-exp(-beta(2).*t(1:4)));
c2=beta(1).*(1-exp(-beta(2).*beta(4))).*exp(-beta(3).*(t(4:6)-beta(4)));
cfit(1:4)=c1;
cfit(4:6)=c2;
plot(t,c,'*')
hold on;
plot(t,cfit,'r-')
