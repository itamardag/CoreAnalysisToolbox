function [ var,err_log ] = scars_folder( segLength, segNum )
%SCARS_FOLDER calculates the ANGLE between scars and parameters of the 
% STRIKING PLATFORM outline based on the measures
%segLength and segNum and the informatios saved in the _ScarsAngles.mat files
%in a folder (files should be created with the scar_loop or scars_IDs function)
%   INPUT
%   segLength : lenght in mm of the strip between which the angle is
%   calculated
%   segNum : number of strips on the STRIKING PLATFORM the most regular
%   among which is useed for the angle measure.
%   OUTPUT
%   var : structure with the results
fold = [uigetdir([], 'select folder containing ScarAngles or Scars_IDs files') '\'];%browse
files=dir(fold);
f_num=num2str(length(files));
wb=waitbar(0,['0 of ',f_num,' files processed']);
var.seg_length=segLength;
var.ang={};
var.var={};
var.angs={};
var.vars={};
var.path={};
var.name={};
var.plat={};
var.blanks={};
var.p_curv={};
var.p_L_var=[];
var.p_ang_var=[];
var.p_ang_avg=[];
var.p_curv_avg=[];
var.p_ang_turn=[];
var.p_s_lines=cell(0,1);
var.scar_p_width=NaN(0,1);
var.scar_p_curv=NaN(0,1);
var.p_length=cell(0,1);
var.p_point_dist=cell(0,1);
err_log=cell(0,1);
for i=1:length(files)
    if ~endsWith(files(i).name, 'ScarAngles.mat') && ~endsWith(files(i).name, 'Scars_IDs.mat')
        waitbar(i/length(files),wb,[num2str(i),' of ',f_num,' files processed'])
    else
        f_name=[fold '\' files(i).name];
        load(f_name,'name','path','plat','blanks');
        scars=load([path,name]);
        [angle,variance,angles,variances,plat,blanks,err_c,err_id]=scar_loop_f(plat,blanks,...
            segLength,segNum,true,scars,files(i).name);
%         blanks=blanks(~err_id);
        if ~isempty(err_c)
            err_log=[err_log;err_c];
        end
        
        %err_id=unique([err_id;err_ID_plat]);
        if ~isempty(angle)
            %remove invalid blank IDs
            blanks=blanks(~err_id);
            len=length(var.angs)+1;
            var.ang(len,:)={angle};
            var.var(len,:)={variance};
            var.angs(len,:)={angles};
            var.vars(len,:)={variances};
            var.path(len,:)={path};
            var.name(len,:)={name};
            var.plat(len,:)={plat};
            var.blanks(len,:)={blanks};
        
        
        %extract data on platform outline
        [p_s_lines, p_curv, p_L_var, p_ang_var, p_ang_avg,p_ang_turn,p_pdists] = ...
            StraightLineApprox(plat, blanks, scars);
        
        if ~isempty(p_curv)
            %remove invalid values %Already removed before calculating data
            %on platform outline. Yuppee!
%             p_curv=p_curv(~err_id);
%             p_pdists=p_pdists(~err_id,:);
%             p_s_lines=p_s_lines(~err_id);
%         if ~isempty(err_c_plat)
%             err_log=[err_log;err_c_plat];
%         end
        
            var.p_curv_avg(len,:)=mean(p_curv,'omitnan');
            var.p_curv(len,:)={p_curv};
            var.p_L_var(len,:)=p_L_var;
            var.p_ang_var(len,:)=p_ang_var;
            var.p_ang_avg(len,:)=p_ang_avg;
            var.p_ang_turn(len,:)=p_ang_turn;
            var.scar_p_curv=[var.scar_p_curv;p_curv'];
            var.p_s_lines{len,:}=p_s_lines;
            var.p_length{len,:}=p_pdists(:,2);
            var.p_point_dist{len,:}=p_pdists(:,1);
            scar_p_width=NaN(length(p_s_lines),1);
            for j=1:length(p_s_lines)
                if ~isempty(p_s_lines{j})
                    scar_p_width(j)=pdist(p_s_lines{j});
                end
            end
            var.scar_p_width=[var.scar_p_width;scar_p_width];
        end
        end

    waitbar(i/length(files),wb,[num2str(i),' of ',f_num,' files processed'])
    end
end
close(wb)
load gong
sound (y,Fs)
end

