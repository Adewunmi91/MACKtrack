function compDuration (id1, id2, varargin)
%compare dynamics features from two experimental conditions


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
