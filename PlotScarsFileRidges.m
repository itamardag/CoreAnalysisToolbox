function PlotScarsFileRidges(pr,color,weights)
    rnum=length(pr);
    for i=1:rnum
        ps=pr{i};
        hold on;
        plot3(ps(:,1),ps(:,2),ps(:,3),color,'Linewidth',max(1,weights(i)-1),'Tag',GetScarsTag);
    end 
end