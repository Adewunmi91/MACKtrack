function seeDiff (id, varargin)

[metrics, fourier, graph, info, ~] = nfkbmetrics (id);

if (nargin > 1)
    name = varargin{1};
else
    name = strsplit(info.name, '_');
    name = name{2};
%     name2 = strsplit (info2.name,'_');
%     name2 = name2 {2};
%mean
end
len = length (graph.t);
endpt = ceil (len/12);
x = linspace(0,endpt,len);
y = metrics.time_series;

%pick cells at random
numCells = size (metrics.time_series,1);
n = 30;%sample size
indices = randperm (numCells, n);
y = y(indices, :);
cz = linspace (1, size (y,1), size (y,1));
z = repmat (cz',1, len);


figure ('Name', 'Difference from population mean')




pl = plot3(x,z,y, 'Linewidth',2);

for i = 1:n    
    testln = pl(i);
    diff_z = abs (nanmean(metrics.time_series,1)- testln.ZData);
    pa = patch (testln.XData,testln.YData, diff_z, testln.Color);
    pa.Vertices (1,3) = 0;
    pa.Vertices (end, 3) = 0;
    pa.Vertices =nanmax(pa.Vertices,0);
    testln.Color = 'none';
end


box on
grid on
title (name)
xlabel (' Time (hours)')
zlabel ('A.U.')
ylabel ('Cell')
zlim ([0, 10])
xlim ([0,18])
view (0, 86)

%median