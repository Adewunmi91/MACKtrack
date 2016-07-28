function compSeries (id1, id2, varargin)
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
subplot (2,1,1)

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
% subplot (2,2,2)
% 
% med1 = nanmedian(metrics1.time_series);
% med2 = nanmedian (metrics2.time_series);
% plot (x, med1,'Linewidth',2)
% hold on;
% plot (x, med2,'Linewidth',2)
% title ('Median')
% xlabel (' Time (hours)')
% ylabel ('A.U.')
% legend (name1, name2,'Location', 'northeast') 


%CV
subplot (2,1,2)

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
% subplot (2,2,4)
% 
% max1 = nanmax(metrics1.time_series);
% max2 = nanmax(metrics2.time_series);
% plot (x, max1,'Linewidth',2)
% hold on;
% plot (x,max2,'Linewidth',2)
% title('Max Response Per Time Point')
% xlabel ('Time (hours)')
% ylabel ('A.U.')
% legend (name1, name2,'Location', 'northeast')
