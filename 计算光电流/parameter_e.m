function [mu_const,mu_dop,D_const,D_dop,tau,tau_T,tau_T_exp,Ln] = parameter_e(N,T)
%TAO_N 此处显示有关此函数的摘要
%   P区参数
%
mumax	= 1.4170e+03 ;   %4.7050e+02	# [cm^2/(Vs)]
Exponent= 2.5;           %2.2	# [1]
mutunnel= 0.05;          %	0.05	# [cm^2/(Vs)]
T0=300;
mu_const = mumax*(T/T0)^(-Exponent);
%
mumin1	= 52.2;          %	44.9	# [cm^2/Vs]
mumin2	= 52.2;          %	0.0000e+00	# [cm^2/Vs]
mu1     = 43.4;          %	29	# [cm^2/Vs]
Pc      = 0.0000e+00;    %	9.2300e+16	# [cm^3]
Cr      = 9.6800e+16;    %	2.2300e+17	# [cm^3]
Cs      = 3.4300e+20;    %	6.1000e+20	# [cm^3]
alpha	= 0.68;          %	0.719	# [1]
beta	= 2;             %	2	# [1]
mu_dop    = mumin1*exp(-Pc/N) + (mu_const - mumin2)/(1+(N/Cr)^alpha)- mu1/(1+(Cs/N)^beta);

k=1.38e-23;
T=300;
q=1.6E-19;
c=k*T/q;
D_const=(k*T/q)*mu_const;
D_dop=(k*T/q)*mu_dop;

taumin	= 0.0000e+00;   %	0.0000e+00	# [s]
taumax	= 6.5421e-07 ;  %		5.6757e-07	# [s]
Nref	= 1.0000e+16 ;  %		1.0000e+16	# [cm^(-3)]
gamma	= 1 ;           %		1	# [1]
Talpha	= -1.5000e+00 ; %		-1.5000e+00	# [1]
Tcoeff	= 2.55;         %		2.55	# [1]
Etrap	= 0.0000e+00;   %	# [eV]
tau = taumin + ( taumax - taumin ) / ( 1 + ( N/Nref )^gamma);
tau_T = tau * ( (T/300)^Talpha );
tau_T_exp = tau * exp( Tcoeff * ((T/300)-1) );
Ln=(D_dop*tau)^0.5;
end

