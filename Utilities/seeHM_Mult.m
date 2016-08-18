function seeHM_Mult (varargin)

if nargin >0
    id = varargin {1};
    [metrics, ~, graph] = nfkbmetrics (id);
    
   
    %graph.opt defaults to the first component graph
    colors = setcolors;    
    [~, info]= loadID (id);
    name = info.name;
    figs.d  = figure('name',name);
    set(figs.d,'Position',[500, 350, 876, 1000]);
    
    graph.smult.order = randperm(size(graph.var,1),min([60 size(graph.var,1)]));
    %tmp = randperm(size(graph.var,1),min([60 size(graph.var,1)]));
   % [~,graph.smult.order] = sort(metrics.oscfrac(tmp,4),'descend');
   % [~,graph.smult.order] = sort(metrics.oscfrac(tmp,4),'ascend');
    graph.smult.h = tight_subplot(15,4);
    xpos = max(graph.opt.Times)-0.48*(max(graph.opt.Times)-min(graph.opt.Times));
    ypos =  max(graph.opt.MeasurementBounds) - 0.26*diff(graph.opt.MeasurementBounds);
    for i =1:length(graph.smult.order)
         plot(graph.smult.h(i),graph.t,graph.var(graph.smult.order(i),:),'Color',colors.grays{3}, 'LineWidth',2)
         set(graph.smult.h(i),'XLim',[min(graph.opt.Times)-(range(graph.opt.Times)*0.02) max(graph.opt.Times)],...
        'YLim',graph.opt.MeasurementBounds,'XTickLabel',{},'YTickLabel',{})
        
        %met =metrics.pk2_time(graph.smult.order(i))- metrics.pk1_time(graph.smult.order(i));
        met = metrics.peakfreq(graph.smult.order(i));
        %met = metrics.max_integral(graph.smult.order(i));
         %met = metrics.off_times(graph.smult.order(i));
        %text(xpos,ypos,['XY ',num2str(graph.celldata(graph.smult.order(i),1)),...
        %', cell ',num2str(graph.celldata(graph.smult.order(i),2)), ',p:',num2str(met)],'Parent',graph.smult.h(i))
        %text(xpos,ypos,['interpk: ',num2str(met)],'Parent',graph.smult.h(i))
        
    end  
    for i = 2:nargin
        [nm, ~, ng] = nfkbmetrics(varargin{i});
        graph.var = cat (1,graph.var,ng.var);
        graph.celldata = cat (1, graph.celldata, ng.celldata);
        metrx = fieldnames (metrics);
        for j=1:numel (metrx)
                metrics.(metrx{j})= cat(1,  metrics.(metrx{j}),  nm.(metrx{j}));
        end
        
    end
    [~,graph.order] = sort(nansum(graph.var(:,1:min([size(graph.var,2),150])),2),'descend');
  
    %[~,graph.order] = sort(nanmean(metrics.envelope,2),'descend');
   % [~,graph.order] = sort(metrics.oscfrac(:,2),'descend');
    %[~,graph.order] = sort(metrics.peakfreq,'descend');
    %graph.opt defaults to the first component graph
   
    figs.a = figure('name','ColormapStack');
    set(figs.a,'Position', [500 700 1200 600])
    colormapStack(graph.var(graph.order,:),graph.celldata(graph.order,:), graph.opt); 
    set (gca, 'FontSize', 20)
    
    
end