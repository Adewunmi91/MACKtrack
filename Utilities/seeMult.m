function  seeMult(varargin)

%might be a problem if different time scales
%truncate as necessary
%[metrics,aux, graph, info, measure] = nfkbmetrics(id,varargin)
if nargin >0
    [metrics, ~, graph, info, ~] = nfkbmetrics (varargin {1});
    
   
    %cum_graph.opt defaults to the first component graph
    colors = setcolors;    

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
        
    

end
    
    


