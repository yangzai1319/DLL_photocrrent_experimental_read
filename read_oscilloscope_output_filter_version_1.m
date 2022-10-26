clc,clear;
%file path&filename
file_direction='C:\\Users\\yangzai\\OneDrive\\article_summary\\PDN_ralated\\photocurrent_fitting\\2021_sip_experimental_results\\20211217/1/during_pulse\\';
file_name='40750#3V3_3#_and_4#.csv';
file_path_and_name=strcat(file_direction,file_name);
output_file_name='20211217_3#_pwl.txt'
%chanel of date option[1,2,3,4]
CH=3; %CH is a manual input.

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
output_plot=plot(time_of_CH_double,output_of_CH_double,'-');
%formation of figure
legend(legend_txt,'FontSize',14); %legend and FontSize
xlabel('time(s)','FontSize',14);  %lable and FontSize
ylabel('current (A) or voltate (V)','FontSize',14); %lable and FontSize
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

%FFT part
% Y = fft(output_of_CH_double);
% L=length(output_of_CH_double);
% delt=4e-9;
% Fs=1/delt;

dt=4e-9;%采样间隔
N=length(output_of_CH_double);%采样点数
t=0:dt:(N-1)*dt;%采样时刻
fs=1/dt;%采样频率，与才采样间隔互为倒数
n=0:1:N-1;
f=(fs/N).*n;%X轴每个点对应的频率
x=output_of_CH_double;%信号
figure(1)
plot(t,x)
y=fft(x);%傅里叶变换得到一个复数
Ay=abs(y);%取模
Ayy=Ay*2/N;%转换成实际的幅值
figure(2)
plot(f(1:N/2),Ayy(1:N/2))
xlim([-1e3 50e3]);
f1=500e3;
f2=(fs/N).*(N-1);
yy=zeros(1,length(y));
for m=0:N-1
   if(m*(fs/N)>f1&m*(fs/N)&&(fs-f2)&m*(fs/N)<(fs-f1));%将奈奎斯特之后的频率也滤除点掉
       yy(m+1)=0;
   else
       yy(m+1)=y(m+1);
   end
end      %将频率为8Hz-12Hz的信号的幅值置0
yyi=abs(yy);
figure(3)
plot(f(1:N/2),yyi(1:N/2))
xlim([-1e3 50e3]);
yi=ifft(yy);
figure(4)
plot(t,real(yi))



% P2 = abs(Y/L);
% P1 = P2(1:L/2+1);
% P1(2:end-1) = 2*P1(2:end-1);
% f = Fs*(0:(L/2))/L;
% subplot(1,2,1)
% plot(f,P1) ;
% title('Single-Sided Amplitude Spectrum of X(t)');
% xlabel('f (Hz)');
% ylabel('|P1(f)|');
% xlim([-1e3 50e3]);
% 
% %
% f1=0;f2=5e3;                                             %要滤除频率的上下限
% N=length(output_of_CH_double);
% dt=delt;
% y=fft(output_of_CH_double);
% yy=zeros(1,length(output_of_CH_double));                                  %设置与y相同的元素数组
% for m=0:N-1                                             %将频率落在该频率范围内及其大于奈奎斯特的波滤除
%     %小于奈奎斯特频率的滤波范围
%     if (m/(N*dt)>f1&m/(N*dt)<f2)|(m/(N*dt)>(1/dt-f2)&m/(N*dt)<(1/dt-f1));
%         %大于奈奎斯特频率的滤波范围
%         %1/dt为一个频率周期
%         yy(m+1)=0;                                      %将落在此频率范围内的振幅设置为0
%     else
%         if m<(length(output_of_CH_double)-1);                                       %确定数组y(m+1)不溢出
%         yy(m+1)=y(m+1);                                 %其余频率范围内的信号保持不变
%         end
%     end
% end
% P2 = abs(yy/L);
% P1 = P2(1:L/2+1);
% P1(2:end-1) = 2*P1(2:end-1);
% 
% subplot(1,2,2);
% 
% plot(f,P1);                     %绘制滤波后的振幅谱
% xlim([-1e3 50e3]);
% xlabel('频率/Hz');ylabel('振幅');
% gstext=sprintf('自%4.1f-%4.1fHz的频率被滤除',f1,f2);
% %将滤波范围显示作为标题
% title(gstext);




