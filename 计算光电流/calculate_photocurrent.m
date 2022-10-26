function [photocurrent] = calculate_photocurrent(t,T,t_delay,w,L_p,L_n,taop,taon,dose)
%CALCULATE_PHOTOCURRENT �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
q=1.6e-19; %����������� C/e
g_gamma=4e13*dose; %h-e pairs / cm^3/rad
A=1e-4; %�����cm^2
%w_n=0.2e-3;%n�͹��кľ��㳤��cm
%w_p=1e-3;%p�͹��кľ��㳤��cm
%w=w_n+w_p;%�ľ�������
%L_p=3.2764e-5;%diffusion length for holes in n-type silicon;
%L_n=4.7e-3;%diffusion length for electrons in p-type silicon;
%taop=0.567;%n������������ns
%taon=620;%p������������ns
%T=1000;%�������ʱ��ʱ��ns
t2=T+t_delay;
photocurrent=zeros(size(t));
for i=1:1:length(t)
    if(t(i)<t_delay)
      photocurrent(i)=0;  
    else
        if(t(i)>=t_delay && t(i)<=t2)
            photocurrent(i)=q*g_gamma*A*(w+L_p*erf(sqrt((t(i)-t_delay)/taop))+L_n*erf(sqrt((t(i)-t_delay)/taon)));
        else
             if(t(i)>t2)
             photocurrent(i)=q*g_gamma*A*(L_p*(erf(sqrt((t(i)-t_delay)/taop))-erf(sqrt((t(i)-t2)/taop)))+L_n*(erf(sqrt((t(i)-t_delay)/taon))-erf(sqrt((t(i)-t2)/taon))));
             end
        end
     end
end
end


