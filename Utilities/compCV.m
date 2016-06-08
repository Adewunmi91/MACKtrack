function compCV (id1, id2, varargin)
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
[metrics2, fourier2,graph2, info2, ~] = nfkbmetrics (id2);


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



%CV
figure

cv1 = nanstd(metrics1.time_series, 1)./nanmean(metrics1.time_series, 1);
cv2 = nanstd(metrics2.time_series, 1)./nanmean(metrics2.time_series, 1);
plot (x, cv1)
hold on;
plot (x, cv2)
title ('CV')
xlabel (' Time (hours)')
ylabel ('A.U.')
legend (name1, name2,'Location', 'northeast') 








