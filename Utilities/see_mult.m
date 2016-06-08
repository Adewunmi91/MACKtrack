
 function see_mult (id)
colors = setcolors;    
[graph,info,~] = see_nfkb_native(id);
name = info.name;
figs.d  = figure('name',name);
set(figs.d,'Position',[500, 350, 876, 1000]);
graph.smult.order = randperm(size(graph.var,1),min([60 size(graph.var,1)]));
graph.smult.h = tight_subplot(15,4);
xpos = max(graph.opt.Times)-0.48*(max(graph.opt.Times)-min(graph.opt.Times));
ypos =  max(graph.opt.MeasurementBounds) - 0.26*diff(graph.opt.MeasurementBounds);
for i =1:length(graph.smult.order)
    plot(graph.smult.h(i),graph.t,graph.var(graph.smult.order(i),:),'Color',colors.grays{3}, 'LineWidth',2)
    set(graph.smult.h(i),'XLim',[min(graph.opt.Times)-(range(graph.opt.Times)*0.02) max(graph.opt.Times)],...
        'YLim',graph.opt.MeasurementBounds,'XTickLabel',{},'YTickLabel',{})
    text(xpos,ypos,['XY ',num2str(graph.celldata(graph.smult.order(i),1)),...
        ', cell ',num2str(graph.celldata(graph.smult.order(i),2))],'Parent',graph.smult.h(i))

end