clc,clear;
%file path&filename
file_direction='C:\\Users\\yangzai\\OneDrive\\article_summary\\PDN_ralated\\photocurrent_fitting\\2021_sip_experimental_results\\20211217/1/during_pulse\\';
file_name='40750#3V3_3#_and_4#.csv';
file_path_and_name=strcat(file_direction,file_name);
output_file_name='20211217_3#_pwl.txt'
%%%%%%%delay information
t_delay=2e-4;
output_file_name_delay_fliter='output_file_name_delay_fliter_pwl.txt';
output_file_name_delay='output_file_name_delay_pwl.txt';
%chanel of date option[1,2,3,4]
CH=4; %CH is a manual input.
lower_cut_off_frequency=5e6;%define lower_cut_off_frequency of Low pass fliter
%legend of plot 
legend_txt=strcat('Doserate=1.7e9, 22.5ns,3V3V, CH',num2str(CH));

%columes of time and output, each CH occupies six columes...
%Its time information is in the 4th col, and the output is in 5th col.
col_of_time_CH=6*(CH-1)+4;
col_of_output_CH=6*(CH-1)+5;

%print the path&filename to exmine.
disp(file_path_and_name);

% csvread(file_path_and_name); %csvread() is not suitable.(ref manual)

%first read method; output is double array.
%f1=readmatrix(file_path_and_name); 

%second read method; output is a table. 
%advantages: other values can display, such as sting.
%use the table2arry function to%transter data.
%readmatrix and table2array(readtable) has the same precision.
table_of_read_out_CSV=readtable(file_path_and_name);
%CH of time (double)
time_of_CH_double=table2array(table_of_read_out_CSV(:,col_of_time_CH));
%CH of output voltage or current (double)
output_of_CH_double=table2array(table_of_read_out_CSV(:,col_of_output_CH));
% examine length of time and output data
if length(time_of_CH_double)==length(output_of_CH_double)
    disp(strcat('Length of Time Data and Output Data are the same, they are ',num2str(length(time_of_CH_double)),'.')); %correct outoupt
else
    error(strcat('Length of Time Data and Output Data are different!!! Time is',...
        num2str(length(time_of_CH_double)),'. Output is ',num2str(length(output_of_CH_double))'.')); %error output
end

%plot output
figure(1)
output_plot=plot(time_of_CH_double,output_of_CH_double,'-');
%formation of figure
legend(legend_txt,'FontSize',14); %legend and FontSize
xlabel('time/s','FontSize',14);  %lable and FontSize
ylabel('current/A','FontSize',14); %lable and FontSize
set(gca,'FontSize',14); %size of axis
%xlim
%ylim()

%%%%output PWL profiles in a .txt file.
output_file=fopen(output_file_name, 'wt'); %open .txt file
for i = 1:1:length(time_of_CH_double)
    fprintf(output_file,'%g\t',time_of_CH_double(i));
    fprintf(output_file,'%d\n',output_of_CH_double(i));
end
fclose(output_file);%close .txt file

%%%%%%%%%%%%%%%%%%%%FFT part
%%%FFT configuration
dt=4e-9;%sampling interval 4ns
N=length(output_of_CH_double);%sampling Times 
t=0:dt:(N-1)*dt;%time t=time_of_CH_double
fs=1/dt;%sampling frequency  
n=0:1:N-1;
f=(fs/N).*n;% frequecy of the axis, from 0 to fs*(N-1)/N
x=output_of_CH_double;%primary 
figure(2)
subplot(2,2,1) %plot primary profiles
plot(t,x)
xlabel('time/s')
ylabel('current/A');
ylabel('aplitude');
title('primary profile');

%%%FFT convertion
y=fft(x);%傅里叶变换得到一个复数
Ay=abs(y);%取模
Ayy=Ay*2/N;%转换成实际的幅值
subplot(2,2,2)
plot(f(1:N/2),Ayy(1:N/2)) %plot FFT results
xlim([-1e3 50e3]);
xlabel('frequency/Hz');
ylabel('aplitude');
title('frequency spectrum of the primary profile');

%%%%fliter process
f1=lower_cut_off_frequency;  % lower cut-off frequency
f2=(fs/N).*(N-1); % upper cut-off frequency
yy=zeros(1,length(y));
for m=0:N-1
   if(m*(fs/N)>f1&m*(fs/N)&&(fs-f2)&m*(fs/N)<(fs-f1));%将奈奎斯特之后的频率也滤除点掉
       yy(m+1)=0;
   else
       yy(m+1)=y(m+1);
   end
end      %将频率为f1-f2的信号的幅值置0

yyi=abs(yy);
subplot(2,2,3)
plot(f(1:N/2),yyi(1:N/2)) %plot FFT results with filter
xlabel('frequency/Hz');
ylabel('aplitude');
title('frequency spectrum after filter');
xlim([-1e3 50e3]);

yi=ifft(yy);
subplot(2,2,4)
plot(time_of_CH_double,output_of_CH_double,'-');
hold on;
output_with_filter=real(yi);
plot(t,output_with_filter,'-') %plot profiles with filter in time domain.
xlabel('time/s')
ylabel('current/A');
title('profile after filter');
hold off;

%%%%  adding delay time
%t_delay=2e-4;
%%%%  adding delay time codes
if (t_delay~=0)
    t_add_delay(1)=0;
    output_with_filter_add_delay(1)=output_with_filter(1);
    output_add_delay(1)=output_of_CH_double(1);
    for i=1:1:(length(t))
        t_add_delay(i+1)=t(i)+t_delay;
        output_with_filter_add_delay(i+1)=output_with_filter(i);
        output_add_delay(i+1)=output_of_CH_double(i);

    end
else
    t_add_delay=t;
    output_with_filter_add_delay;
    output_add_delay=output_of_CH_double;
end
figure(3);
plot(t_add_delay,output_add_delay);
hold on;
plot(t_add_delay,output_with_filter_add_delay);
annotation('textbox',[0.16 0.57 0.2 0.065],'String',{'t\_delay=2e-4s'},'FontSize',12);
legend('frofile with no filter','frofile with filter','FontSize',12); %legend and FontSize
xlabel('time/s','FontSize',14);  %lable and FontSize
ylabel('current/A','FontSize',14); %lable and FontSize
set(gca,'FontSize',14); %size of axis

%%%%output PWL profiles in a .txt file.
%output_file_name_delay='output_file_name_delay_pwl.txt';
output_file=fopen(output_file_name_delay, 'wt'); %open .txt file
for i = 1:1:length(t_add_delay)
    fprintf(output_file,'%g\t',t_add_delay(i));
    fprintf(output_file,'%d\n',output_add_delay(i));
end
fclose(output_file);%close .txt file

%output_file_name_delay_fliter='output_file_name_delay_fliter_pwl.txt';
output_file=fopen(output_file_name_delay_fliter, 'wt'); %open .txt file
for i = 1:1:length(t_add_delay)
    fprintf(output_file,'%g\t',t_add_delay(i));
    fprintf(output_file,'%d\n',output_with_filter_add_delay(i));
end
fclose(output_file);%close .txt file


