clc,clear;
time=[0:0.1:4000];
[e_mu_const,e_mu_dop,e_D_const,e_D_dop,taon,e_tau_T,e_tau_T_exp,L_n] = parameter_e(5e14,300);
[h_mu_const,h_mu_dop,h_D_const,h_D_dop,taop,h_tau_T,h_tau_T_exp,L_p] = parameter_h(1e19,300);
dose=1e8;
t_delay=500;
T_pulse=1000;
w=1e-4;
taop_s=taop*1e9;
taon_s=taon*1e9;
[photocurrent] = calculate_photocurrent(time,T_pulse,t_delay,w,L_p,L_n,taop_s,taon_s,dose);
save('calculation_dose1e8.txt','data_out','-ascii')
plot(time,photocurrent,'r');
grid on ;