function [photocurrent] = calculate_photocurrent(t,T,t_delay,w,L_p,L_n,taop,taon,dose)
%CALCULATE_PHOTOCURRENT 此处显示有关此函数的摘要
%   此处显示详细说明
q=1.6e-19; %电子所带电荷 C/e
g_gamma=4e13*dose; %h-e pairs / cm^3/rad
A=1e-4; %结面积cm^2
%w_n=0.2e-3;%n型硅中耗尽层长度cm
%w_p=1e-3;%p型硅中耗尽层长度cm
%w=w_n+w_p;%耗尽区长度
%L_p=3.2764e-5;%diffusion length for holes in n-type silicon;
%L_n=4.7e-3;%diffusion length for electrons in p-type silicon;
%taop=0.567;%n区的少子寿命ns
%taon=620;%p区的少子寿命ns
%T=1000;%脉冲持续时间时间ns
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


