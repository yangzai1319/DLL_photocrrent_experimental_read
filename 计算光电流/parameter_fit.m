clc,clear;
load('data01.mat');
t=data_01(:,1);
t2=[0:1e-8:1e-6];
photocurrent=data_01(:,2);
% �÷�Ϊfittype('�Զ��庯��','independent','�Ա���','coefficients',{'ϵ��1','ϵ��2'����});
% f=fittype('a*cos(k*t)*exp(w*t)','independent','t','coefficients',{'a','k','w'});
plot(t,photocurrent,'r*');
hold on;
f=fittype('A*(w+L_p*erf(sqrt(t/taop))+L_n*erf(sqrt(t/taon)))','independent','t','coefficients',{'A','w','L_p','L_n','taop','taon'});
cfun=fit(t2,photocurrent,f);%�����Զ�����Ϻ���f���������x��y
t=data_01(:,1);
yi=cfun(t);
plot(t,yi,'b-')


