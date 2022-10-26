%fitting fuction of global phtotocurrent on PDNs of SiP
% clc,clear;
disp('version_1.0');
q=1.6e-19; % q iss the magnitude of the electonic harge/ e
g0=4.3e13;% g0 is the generation constant/ pairs cm-3
P0=2.8e9; % P0 is the dose rate rad(Si)/s
Apn=1.5*1.5*0.01; % Apn is the area of the pn juction/ legth*width*percenty cm^2
Wpn=1.0E-4; % Wpn is the junction depletion width / cm
Dd=10; % Dd is the base diffusion coefficient cm^2/s
tao=1*10^-6; %tao is the lifetime in the substrate/ s
Tp=19.6*10^-9; % Tp is the radiation pulse width/ s
time=[0:1E-10:1e-6]; %time / s
time_delay=1e-7; %photocurrent delay time/ s
D0=0.8*Tp*P0;
output_file=fopen('output_pwl_dose_2_8e9.txt', 'wt');
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
    fprintf(output_file,'%g\t',time(i));
    fprintf(output_file,'%g\n',photocurrent(i));
end

photocurrent_plot=plot(time,photocurrent,'*')
fclose(output_file);

grid on;
hold on
