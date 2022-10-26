clc,clear;
time=[0:1e-10:1e-6];
n_start=10;%起始量级
n_end=10;%结束量级
for n=n_start:1:n_end
dose=1*10^n;%剂量率
t_delay=1e-7;
T_pulse=50e-9;
w=1.3e-4;
[e_mu_const,e_mu_dop,e_D_const,e_D_dop,taon,e_tau_T,e_tau_T_exp,L_n] = parameter_e(5e14,300);
[h_mu_const,h_mu_dop,h_D_const,h_D_dop,taop,h_tau_T,h_tau_T_exp,L_p] = parameter_h(1e19,300);
[photocurrent] = calculate_photocurrent(time,T_pulse,t_delay,w,L_p,L_n,taop,taon,dose);
plot(time,photocurrent,'r');

grid on;
hold on;
for i=1:1:length(time)
    data_out(i,1)=time(i);
    data_out(i,2)=photocurrent(i);
end
filename = ['calculation_dose1e' num2str(n) '.data' ];
save(filename,'data_out','-ascii')
end
%load -ASCII 'calculation_dose1e5.mat'

%global photocurrent calculation 
q=1.6e-19; % q iss the magnitude of the electonic harge/ e
g0=4.3e13;% g0 is the generation constant/ pairs cm-3
P0=1e10; % P0 is the dose rate rad(Si)/s
Apn=1*1*1e-4; % Apn is the area of the pn juction/ legth*width*percenty cm^2
Wpn=1.3E-4; % Wpn is the junction depletion width / cm
Dd=30; % Dd is the base diffusion coefficient cm^2/s  Dd=30 has a better result than Dd=20
tao=5*10^-6; %tao is the lifetime in the substrate/ s
Tp=50*10^-9; % Tp is the radiation pulse width/ s
time=[0:1E-10:1e-6]; %time / s
time_delay=1e-7; %photocurrent delay time/ s
D0=0.96*Tp*P0;

%photocurrent calculation
n=length(time);
for i=1:1:n
    if time(i)<time_delay  % time is less than time_delay
        photocurrent(i)=0;
    else
        time_temp_1 = time_delay+Tp;
        if time(i)>= time_delay && time(i) <= time_temp_1 %during the gamma pulse
            time_temp_2=time(i)-time_delay;
            photocurrent(i)=q*g0*P0*Apn*(Wpn+sqrt(4*Dd*time_temp_2/pi)*exp(-1*time_temp_2/tao));
        else
            time_temp_3=time_delay+5*Tp;
            if time(i) > time_temp_1 && time(i) <= time_temp_3 %after the pulse, but within 5 times of pulse duration
                time_temp_2=time(i)-time_delay;
                photocurrent(i)=q*g0*P0*Apn*2*sqrt(Dd*time_temp_2/pi)*exp(-1*time_temp_2/tao)*(1-sqrt(1-Tp/time_temp_2)*exp(Tp/tao));
            else
                if time(i) > time_temp_3 % after the 5 times of pulse duration
                    time_temp_2=time(i)-time_delay;
                    photocurrent(i)=q*g0*D0*Apn*exp(-1*time_temp_2/tao)/sqrt(pi*time_temp_2/Dd);
                else
                    disp('error!! photocurrent or time are out of range.')
                end
            end
        end
    end
end

photocurrent_plot=plot(time,photocurrent,'*')
legend ('J. L. Wirth','A. I. Chumakov');
xlabel('time/s');
ylabel('photocurrent/A');
annotation('textbox','String','doserate=1e10rad(Si)/s Duration=50ns');
grid on;
hold off