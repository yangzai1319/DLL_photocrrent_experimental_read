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




