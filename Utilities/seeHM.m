function  seeHM(varargin)

%might be a problem if different time scales
%truncate as necessary
%[metrics,aux, graph, info, measure] = nfkbmetrics(id,varargin)
if nargin >0
    [cum_metrics, ~, cum_graph, ~, ~] = nfkbmetrics (varargin {1});
    for i = 2:nargin
        [metrics, ~, graph, ~,~] = nfkbmetrics(varargin{i});
        cum_graph.var = cat (1,cum_graph.var,graph.var);
        cum_graph.celldata = cat (1, cum_graph.celldata, graph.celldata);
        metrx = fieldnames (cum_metrics);
        for j=1:numel (metrx)
                cum_metrics.(metrx{j})= cat(1,  cum_metrics.(metrx{j}),  metrics.(metrx{j}));
        end
        
    end
    [~,cum_graph.order] = sort(nansum(cum_graph.var(:,1:min([size(cum_graph.var,2),150])),2),'descend');
  
    %[~,cum_graph.order] = sort(nanmean(cum_metrics.envelope,2),'descend');
   % [~,cum_graph.order] = sort(cum_metrics.oscfrac(:,2),'descend');
    %[~,cum_graph.order] = sort(cum_metrics.peakfreq,'descend');
    %cum_graph.opt defaults to the first component graph
   
    figs.a = figure('name','ColormapStack');
    set(figs.a,'Position', [500 700 1200 600])
    colormapStack(cum_graph.var(cum_graph.order,:),cum_graph.celldata(cum_graph.order,:), cum_graph.opt); 
    set (gca, 'FontSize', 20)
end
    
    


