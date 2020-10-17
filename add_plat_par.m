function [ var,err_log ] = add_plat_par(var1)
%ADD_PALT_PAR adds the parameters of the 
% STRIKING PLATFORM outline based on informatios var1


wb=waitbar(0,['0 of ',length(var1.name),' files processed']);
% var.path={};
% var.name={};
% var.plat={};
% var.blanks={};
var=var1;
var.p_curv={};
var.p_L_var=[];
var.p_ang_var=[];
var.p_ang_avg=[];
var.p_curv_avg=[];
var.p_ang_turn=[];
var.scar_p_curv=NaN(0,1);
var.p_s_lines=cell(0,1);
%var.scar_p_s_lines=NaN(0,1);
var.scar_p_width=NaN(0,1);
err_log=cell(0,1);
for i=1:length(var1.name)
    scars=load([var1.path{i},var1.name{i}]);
    [p_s_lines, p_curv, p_L_var, p_ang_var, p_ang_avg,p_ang_turn,err_c,err_id] = ...
            StraightLineApprox(var1.plat{i}, var1.blanks{i}, scars,var1.name{i});
    var.blanks{i}=var1.blanks{i}(~err_id);
    if ~isempty(err_c)
        err_log=[err_log;err_c];
    end
    if ~isempty(p_curv)
        len=length(var.p_curv)+1;
        var.p_curv(len,:)={p_curv};
        var.p_L_var(len,:)=p_L_var;
        var.p_ang_var(len,:)=p_ang_var;
        var.p_ang_avg(len,:)=p_ang_avg;
        var.p_curv_avg(len,:)=mean(p_curv,'omitnan');
        var.p_ang_turn(len,:)=p_ang_turn;
        var.p_s_lines{len,:}=p_s_lines;
        var.scar_p_curv=[var.scar_p_curv;p_curv'];
        scar_p_width=NaN(length(p_s_lines),1);
        for j=1:length(p_s_lines)
            scar_p_width(j)=pdist(p_s_lines{j});
        end
        var.scar_p_width=[var.scar_p_width;scar_p_width];
%         var.path(len,:)={path};
%         var.name(len,:)={name};
%         var.plat(len,:)={plat};
%         var.blanks(len,:)={blanks};
    end


    waitbar(i/length(var1.name),wb,[num2str(i),' of ',num2str(length(var1.name)),' files processed'])

end


close(wb)
load gong
sound (y,Fs)
end

