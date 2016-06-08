function compDynamics (id1, id2, varargin)
%compare dynamics features from two experimental conditions
%Features: 
%Interpeak time
%CV at each time point
%Max Value at each time point

%Time to peak
%Peak amplitude
%First peak integral
%Peak2 amp/peak 1 amp


%Total duration
%Consecutive duration

%Fraction oscillation
%Fraction active

%INPUT: id1, name1, id2, name2

[metrics1, fourier1, graph1, info1, ~] = nfkbmetrics (id1);
[metrics2, fourier2, graph2, info2, ~] = nfkbmetrics (id2);


if (nargin > 3)
    name1 = varargin{1};
    name2 = varargin{2};
else
    name1 = strsplit(info1.name, '_');
    name1 = name1{2};
    name2 = strsplit (info2.name,'_');
    name2 = name2 {2};
end
%mean
len = max (length (graph1.t), length (graph2.t));
endpt = ceil (len/12);
x = linspace(0,endpt,len);
figure ('Name', 'Summary Statistics')
subplot (2,2,1)

mean1 = nanmean (metrics1.time_series);
mean2 = nanmean (metrics2.time_series);
plot (x,mean1, 'Linewidth',2)
hold on;
plot (x,mean2, 'Linewidth',2)
title ('Mean')
xlabel (' Time (hours)')
ylabel ('A.U.')
legend (name1, name2,'Location', 'northeast') 

%median
subplot (2,2,2)

med1 = nanmedian(metrics1.time_series);
med2 = nanmedian (metrics2.time_series);
plot (x, med1,'Linewidth',2)
hold on;
plot (x, med2,'Linewidth',2)
title ('Median')
xlabel (' Time (hours)')
ylabel ('A.U.')
legend (name1, name2,'Location', 'northeast') 


%CV
subplot (2,2,3)

cv1 = nanstd(metrics1.time_series, 1)./nanmean(metrics1.time_series, 1);
cv2 = nanstd(metrics2.time_series, 1)./nanmean(metrics2.time_series, 1);
plot (x, cv1,'Linewidth',2)
hold on;
plot (x, cv2,'Linewidth',2)
title ('CV')
xlabel (' Time (hours)')
ylabel ('A.U.')
legend (name1, name2,'Location', 'northeast') 


%Max amplitude per time point
subplot (2,2,4)

max1 = nanmax(metrics1.time_series);
max2 = nanmax(metrics2.time_series);
plot (x, max1,'Linewidth',2)
hold on;
plot (x,max2,'Linewidth',2)
title('Max Response Per Time Point')
xlabel ('Time (hours)')
ylabel ('A.U.')
legend (name1, name2,'Location', 'northeast')

% %Peak Information
% figure ('Name', 'First Peaks')
% %Time to peak
% subplot (2,2,1)
% 
% t2p1 = metrics1.pk1_time*12;
% t2p2 = metrics2.pk1_time*12;
% histogram (t2p1, 'Normalization', 'probability')
% hold on;
% histogram (t2p2, 'Normalization', 'probability')
% title ('Time to peak')
% xlabel (' Times (mins)')
% ylabel ('Probability')
% legend (name1, name2,'Location', 'northeast')
% 
% %Interpeak time 
% subplot(2,2,2)
% 
% ipt1 = (metrics1.pk2_time)- (metrics1.pk1_time);
% ipt2 = (metrics2.pk2_time)- (metrics2.pk1_time);
% hist1 = histogram (ipt1*60, 'Normalization', 'probability');
% hist1.EdgeColor='k';
% hold on;
% hist2 = histogram (ipt2*60, 'Normalization', 'probability');
% hist2.EdgeColor='r';
% title( 'Interpeak times')
% xlabel ('Time (mins)')
% ylabel ('Probability')
% legend (name1, name2,'Location', 'northeast')
% 
% %Peak 1 amp
% subplot (2,2,3)
% pk1 = metrics1.pk1_amp;
% pk2 = metrics2.pk2_amp;
% hist1= histogram (pk1, 'Normalization', 'probability');
% hist1.EdgeColor='k';
% hold on;
% hist2 = histogram (pk2, 'Normalization', 'probability');
% hist2.EdgeColor='r';
% title( 'Peak 1 Amp')
% xlabel ('Amplitude')
% ylabel ('Probability')
% legend (name1, name2,'Location', 'northeast') 
% 
% %Peak2 amp/peak 1 am
% subplot (2,2,4)
% 
% pk_div_1 = metrics1.pk2_amp./metrics1.pk1_amp;
% pk_div_2 = metrics2.pk2_amp./metrics2.pk1_amp;
% hist1 = histogram (pk_div_1, 'Normalization', 'probability');
% hist1.EdgeColor='k';
% 
% hold on;
% hist2 = histogram (pk_div_2, 'Normalization', 'probability');
% hist2.EdgeColor='r';
% title( 'Peak 2 Amp/Peak 1 Amp')
% xlabel (' Fraction')
% ylabel ('Probability')
% legend (name1, name2,'Location', 'northeast')



%Duration Metrics
figure ('Name', 'Duration')
%Longest Consecutive Duration
subplot (2,2,1)
hist1 = histogram(nanmean(metrics1.envelope, 2)'*60, 'Normalization', 'probability');
hist1.FaceColor = 'auto';
hist1.EdgeColor = 'k';
hist1.Normalization = 'probability';
hold on;
hist2 = histogram(nanmean (metrics2.envelope, 2)'*60, 'Normalization', 'probability');
hist2.Normalization ='probability';
hist2.FaceColor = 'auto';
hist2.EdgeColor='r';
title( 'Longest Consecutive Duration')
xlabel ('Time (mins)')
ylabel ('Probability')
legend (name1, name2,'Location', 'northeast') 


%Duration above threshold
subplot (2,2,2)


hist1 = histogram(nanmean(metrics1.duration,2)'*60);
hist1.FaceColor = 'auto';
hist1.EdgeColor = 'k';
hist1.Normalization = 'probability';
hold on;
hist2 = histogram(nanmean(metrics2.duration,2)'*60);
hist2.Normalization ='probability';
hist2.FaceColor = 'auto';
hist2.EdgeColor='r';
title('Duration above Threshold')
xlabel ('Time (mins)')
ylabel ('Probability')
%legend (name1, name2,'Location', 'northeast') 


%Max Integral%use Integral for now
subplot (2,2,3)
hist1 = histogram(metrics1.max_integral);
hist1.FaceColor = 'auto';
hist1.EdgeColor = 'k';
hist1.Normalization = 'probability';
hold on;
hist2 = histogram(metrics2.max_integral);
hist2.Normalization ='probability';
hist2.FaceColor = 'auto';
hist2.EdgeColor='r';
title('Integral')
xlabel ('Activity (A.U.)')
ylabel ('Probability')
legend (name1, name2,'Location', 'northeast') 


%Offtimes
subplot (2,2,4)
hist1 = histogram(metrics1.off_times*12);
hist1.FaceColor = 'auto';
hist1.EdgeColor = 'k';
hist1.Normalization = 'probability';
hold on;
hist2 = histogram(metrics2.off_times*12);
hist2.Normalization ='probability';
hist2.FaceColor = 'auto';
hist2.EdgeColor='r';
title('Off Times')
xlabel ('Time (mins)')
ylabel ('Probability')
legend (name1, name2,'Location', 'northeast') 





%peak frequency
%frequency that contains most the signal power
figure ('Name', 'Fq Analysis')
subplot (2,2,1)
plot(fourier1.freq*3600, nanmean(fourier1.fft, 1))
hold on;
plot(fourier2.freq*3600, nanmean(fourier2.fft, 1))
title ('Fourier')
xlabel ('Frequency (1/hr)' )
ylabel ('Amplitude')
legend (name1, name2,'Location', 'northeast') 

subplot (2,2,2)

x = fourier1.freq*3600;
plot (x, nanmean(fourier1.power, 1))
hold on;
x = fourier2.freq*3600;
plot(x, nanmean(fourier2.power, 1))
title ('Power')
xlabel ('Frequency (1/hr) ')
ylabel ('Power')
legend (name1, name2,'Location', 'northeast') 

subplot (2,2,3)

x = linspace (0,1,20);
hist1 = histogram(metrics1.peakfreq,x);
hist1.FaceColor = 'auto';
hist1.EdgeColor = 'k';
hist1.Normalization = 'probability';
hold on;
hist2 = histogram(metrics2.peakfreq,x);
hist2.Normalization ='probability';
hist2.FaceColor = 'auto';
hist2.EdgeColor='r';
title ('Peak Frequency')
xlabel ('Frequency (1/hr) ')
ylabel ('Probability')
legend (name1, name2,'Location', 'northeast') 



%Fraction oscillating
subplot (2,2,4)

x = linspace(0,1, 20);
hist1 = histogram(nanmean(metrics1.oscfrac,2),x);
hist1.FaceColor = 'auto';
hist1.EdgeColor = 'k';
hist1.Normalization = 'probability';
hold on;
hist2 =  histogram(nanmean(metrics2.oscfrac,2),x);
hist2.Normalization ='probability';
hist2.FaceColor = 'auto';
hist2.EdgeColor='r';
title( 'Fraction Oscillating')
xlabel ('Oscillatory Content')
ylabel ('Probability')
legend (name1, name2,'Location', 'northeast') 



% figure ('Name', 'Kinetics')
% subplot (2,2,1)
% hist1 = histogram(metrics1.max_derivative);
% hist1.Normalization = 'probability';
% hist1.EdgeColor = 'k';
% hold on;
% hist2 = histogram(metrics2.max_derivative);
% hist2.Normalization ='probability';
% hist2.EdgeColor='r';
% title ('Max Derivatives')
% xlabel ('Rate of Change of Nuclear Translocation')
% ylabel ('Probability')
% legend (name1, name2,'Location', 'northeast')
% 
% %Min Derivatives
% subplot (2,2,2)
% hist1 = histogram(metrics1.min_derivative);
% hist1.FaceColor = 'auto';
% hist1.EdgeColor = 'k';
% hist1.Normalization = 'probability';
% hold on;
% hist2 = histogram(metrics2.min_derivative);
% hist2.Normalization ='probability';
% hist2.FaceColor = 'auto';
% hist2.EdgeColor='r';
% title ('Min Derivatives')
% xlabel ('Rate of Change of Nuclear Translocation')
% ylabel ('Probability')
% legend (name1, name2,'Location', 'northwest')
% 
% %Median Derivatives
% subplot (2,2,3)
% hist1 = histogram(nanmedian (metrics1.derivatives));
% hist1.FaceColor = 'auto';
% hist1.EdgeColor = 'k';
% hist1.Normalization = 'probability';
% hold on;
% hist2 = histogram(nanmedian (metrics2.derivatives));
% hist2.Normalization ='probability';
% hist2.FaceColor = 'auto';
% hist2.EdgeColor='r';
% title ('Median Derivatives')
% xlabel ('Median Rate of Change of Nuclear Translocation')
% ylabel ('Probability')
% legend (name1, name2,'Location', 'northeast')
% 
% %CV Derivatives
% subplot (2,2,4)
% 
% cv_dev_1 = nanstd(metrics1.derivatives)./nanmean (metrics1.derivatives);
% hist1 = histogram(cv_dev_1);
% hist1.FaceColor = 'auto';
% hist1.EdgeColor = 'k';
% hist1.Normalization = 'probability';
% hold on;
% cv_dev_2 = nanstd(metrics2.derivatives)./nanmean (metrics2.derivatives);
% hist2 = histogram(cv_dev_2);
% hist2.Normalization ='probability';
% hist2.FaceColor = 'auto';
% hist2.EdgeColor='r';
% title ('CV of Derivatives')
% xlabel ('CV of Rate of Change of Nuclear Translocation')
% ylabel ('Probability')
% legend (name1, name2,'Location', 'northeast')
% 
% 
% 
% 




