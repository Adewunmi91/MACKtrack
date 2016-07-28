function compFq (id1, id2, varargin) %#ok<*FNDEF>
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

[metrics1, fourier1, ~, info1, ~] = nfkbmetrics (id1);
[metrics2, fourier2, ~, info2, ~] = nfkbmetrics (id2);


if (nargin > 3)
    name1 = varargin{1};
    name2 = varargin{2};
else
    name1 = strsplit(info1.name, '_');
    name1 = name1{2};
    name2 = strsplit (info2.name,'_');
    name2 = name2 {2};
end





%peak frequency
%frequency that contains most the signal power
figure ('Name', 'Fq Analysis')
% subplot (2,2,1)
% plot(fourier1.freq*3600, nanmean(fourier1.fft, 1))
% hold on;
% plot(fourier2.freq*3600, nanmean(fourier2.fft, 1))
% title ('Fourier')
% xlabel ('Frequency (1/hr)' )
% ylabel ('Amplitude')
% legend (name1, name2,'Location', 'northeast') 

subplot (2,2,1)

x = fourier1.freq*3600;
plot (x, nanmean(fourier1.power, 1))
%plot (x, fourier1.power)
hold on;
x = fourier2.freq*3600;
%plot (x, fourier2.power)
plot(x, nanmean(fourier2.power, 1))
title ('Power')
xlabel ('Frequency (1/hr) ')
ylabel ('Power')
legend (name1, name2,'Location', 'northeast') 

subplot (2,2,2)

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
subplot (2,2,3)

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









