function compPks (id1, id2, varargin)
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

[metrics1, fourier1, graph1] = nfkbmetrics (id1);
[metrics2, fourier2,graph2] = nfkbmetrics (id2);


if (nargin > 3)
    name1 = varargin{1};
    name2 = varargin{2};
else
    [~,info1]=loadID(id1);
    [~, info2]=loadID(id2);
    name1 = strsplit(info1.name, '_');
    name1 = name1{2};
    name2 = strsplit (info2.name,'_');
    name2 = name2 {2};
end
%mean
len = max (length (graph1.t), length (graph2.t));
endpt = ceil (len/12);
x = linspace(0,endpt,len);

%Peak  Metrics
figure ('Name', 'Peak Statistics')
%Interpeak Time
subplot (2,2,1)
pk2_time1 =metrics1.pk2_time;
pk1_time1 = metrics1.pk1_time;
ipt1 =pk2_time1 - pk1_time1;
hist1 = histogram(ipt1, 'Normalization', 'probability');
hist1.FaceColor = 'auto';
hist1.EdgeColor = 'k';
hist1.Normalization = 'probability';
hold on;

%set 2
pk2_time2 = metrics2.pk2_time;
pk1_time2 = metrics2.pk1_time;
ipt2 =pk2_time2 - pk1_time2;
hist2 = histogram(ipt2, 'Normalization', 'probability');
hist2.Normalization ='probability';
hist2.FaceColor = 'auto';
hist2.EdgeColor='r';
title( 'Interpeak time')
xlabel ('Time (h)')
ylabel ('Probability')
legend (name1, name2,'Location', 'northeast') 


%Pk ratio
subplot (2,2,2)
pk2_amp1 =metrics1.pk2_amp;
pk1_amp1 = metrics1.pk1_amp;
hist1 = histogram(pk2_amp1./pk1_amp1);
hist1.FaceColor = 'auto';
hist1.EdgeColor = 'k';
hist1.Normalization = 'probability';
hist1.BinWidth = 0.1;
hist1.BinLimits = [0 4];
hold on;

pk2_amp2 = metrics2.pk2_amp;
pk1_amp2 = metrics2.pk1_amp;
hist2 = histogram(pk2_amp2./pk1_amp2);
hist2.Normalization =hist1.Normalization;
hist2.FaceColor = hist1.FaceColor;
hist2.EdgeColor='r';
hist2.BinWidth = hist1.BinWidth;
hist2.BinLimits = hist1.BinLimits;

title( 'Pk 2/1 Ratio')
xlabel ('Ratio ')
ylabel ('Probability')
legend (name1, name2,'Location', 'northeast') 


%half-max width


%Find peak amplitude
%Find half peak point
%Find closest point to half to the left
%Find closest point to half to the right

subplot (2,2,3)
%First set
wdw1 = ceil((ipt1/2)*12);%convert to frames


pk1_width1 = half_max_width (graph1.var, pk1_time1 *12, wdw1);

%Second set
wdw2 = ceil ((ipt2/2)*12);%convert to frames

pk1_width2= half_max_width (graph2.var, pk1_time2*12, wdw2);
%Find index of the pk1


hist1 = histogram(pk1_width1);
hist1.FaceColor = 'auto';
hist1.EdgeColor = 'k';
hist1.Normalization = 'probability';
hist1.BinWidth = 0.1;
hist1.BinLimits = [0 3];
hold on;


hist2 = histogram(pk1_width2);
hist2.Normalization =hist1.Normalization;
hist2.FaceColor = hist1.FaceColor;
hist2.EdgeColor='r';
hist2.BinWidth = hist1.BinWidth;
hist2.BinLimits = hist1.BinLimits;

title( 'Pk 1 half-max width')
xlabel ('Time (h)')
ylabel ('Probability')
legend (name1, name2,'Location', 'northeast') 


subplot (2,2,4)%pk2

%First set
pk2_width1 = half_max_width (graph1.var, pk2_time1*12, wdw1);

%Second set
pk2_width2= half_max_width (graph2.var, pk2_time2*12, wdw2);


hist1 = histogram(pk2_width1);
hist1.FaceColor = 'auto';
hist1.EdgeColor = 'k';
hist1.Normalization = 'probability';
hist1.BinWidth = 0.1;
hist1.BinLimits = [0 3];
hold on;


hist2 = histogram(pk2_width2);
hist2.Normalization =hist1.Normalization;
hist2.FaceColor = hist1.FaceColor;
hist2.EdgeColor='r';
hist2.BinWidth = hist1.BinWidth;
hist2.BinLimits = hist1.BinLimits;


title( 'Pk 2 half-max width')
xlabel ('Time (h)')
ylabel ('Probability')
legend (name1, name2,'Location', 'northeast')


