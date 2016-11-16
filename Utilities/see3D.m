function see3D (id, varargin)

[metrics, ~, graph] = nfkbmetrics (id);

if (nargin > 1)
    name = varargin{1};
else
  %  name = strsplit(info.name, '_');
   % name = name{2};
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

%get sum of peaks for each cell and rank 
pks = nansum (y(:,1:100),2);
%pks = nanmax (y(:, 1:72),[],2);
[~, i] = sort (pks);
cz = cz(i);


z = repmat (cz',1, len);
figure ('Name', '3D Line plot')
hold on
pl = plot3(x,z,y, 'Linewidth',0.1);

for i = 1:n    
    testln = pl(i);
    pa = patch (testln.XData,testln.YData, testln.ZData, testln.Color);
    pa.Vertices (1,3) = 0;
    pa.Vertices (end, 3) = 0;
    pa.Vertices =nanmax(pa.Vertices,0);
end

%%
%%for sample mean
% hold on
% z = ones (len)*(n+2);
% 
% pl1 = plot3(x,z,nanmedian (y,1),'Linewidth',2);
% 
% testln = pl1(end);
% pa = patch (testln.XData,testln.YData, testln.ZData, 'k');
% pa.Vertices (1,3) = 0;
% pa.Vertices (end, 3) = 0;
% pa.Vertices = nanmax(pa.Vertices,0);

% 
%%

%% population mean
%hold on
%z = ones (len)*(n);
%plot3(x,z,nanmedian (y,1),'Linewidth',1);
%plot3(x,z, nanmean(metrics.time_series,1),'Linewidth',1, 'Color', 'k');
%plot3(x,z, nanmean(metrics.time_series,1),'Linewidth',1, 'Color', 'k');
%plot3(x,z, nanmax(metrics.time_series),'Linewidth',1, 'Color', 'k');
% 
%
%%

box on
grid on
title (name)
xlabel (' Time (hours)')
zlabel ('N/C NFkB')
ylabel ('Cell')
zlim ([0, 10])
xlim ([0,inf])
view (8, 74)
set (gca, 'FontSize', 20)

%median