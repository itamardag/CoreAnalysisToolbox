function [var] = ang_var_structure(var1)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
var=var1;
var.dif_pace={};
var.dev_pace={};
var.scar_number=[];
len=NaN(length(var.ang),1);
    for i=1:size(var.ang,1)
        len(i)=max(nansum(~isnan(var.angs{i}),1));
    end
    for i=1:size(var.ang,1)
        len_i=min(max(len),len(i)); 
        if len_i==1
            var.dif_pace{end+1}=[];
            var.dev_pace{end+1}=[];
        else
        v_p=var.angs{i}(2:len_i,:)-var.angs{i}(1:len_i-1,:);
        dev_p=var.vars{i}(2:len_i,:)+var.vars{i}(1:len_i-1,:);
        var.dif_pace{end+1}=v_p;
        var.dev_pace{end+1}=dev_p;
        end
        var.scar_number(length(var.scar_number)+1)=size(var.angs{i},2);
    end
end




