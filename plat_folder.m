function [ var,err_log ] = plat_folder(fold)
%PLAT_FOLDER calculates the parameters of the 
% STRIKING PLATFORM outline based on informatios saved in the _ScarsAngles.mat files
%in a folder (files should be created with the scar_loop or scars_IDs function)

%   OUTPUT
%   var : structure with the results
if nargin<1
    fold = [uigetdir([], 'select folder containing ScarAngles or Scars_IDs files') '\'];%browse
end
files=dir(fold);
f_num=num2str(length(files));
wb=waitbar(0,['0 of ',f_num,' files processed']);
var.path={};
var.name={};
var.plat={};
var.blanks={};
var.p_curv={};
var.p_L_var=[];
var.p_ang_var=[];
var.p_ang_avg=[];
var.p_ang_turn=[];
var.p_curv_avg=[];
var.scar_p_curv=NaN(0,1);
err_log=cell(0,1);
for i=1:length(files)
    if ~endsWith(files(i).name, 'ScarAngles.mat') && ~endsWith(files(i).name, 'Scars_IDs.mat')
        waitbar(i/length(files),wb,[num2str(i),' of ',f_num,' files processed'])
    else
        f_name=[fold '\' files(i).name];
        load(f_name,'name','path','plat','blanks');
        scars=load([path,name]);
        [~, p_curv, p_L_var, p_ang_var, p_ang_avg, p_ang_turn,err_c,err_id] = ...
                StraightLineApprox(plat, blanks, scars,files(i).name);
        blanks=blanks(~err_id);
        if ~isempty(err_c)
            err_log=[err_log;err_c];
        end
        if ~isempty(p_curv)
            len=length(var.p_curv)+1;
            var.p_curv(len,:)={p_curv};
            var.p_L_var(len,:)=p_L_var;
            var.p_ang_var(len,:)=p_ang_var;
            var.p_ang_avg(len,:)=p_ang_avg;
            var.p_ang_turn(len,:)=p_ang_turn;
            var.p_curv_avg(len,:)=mean(p_curv,'omitnan');
            var.scar_p_curv=[var.scar_p_curv;p_curv'];
            var.path(len,:)={path};
            var.name(len,:)={name};
            var.plat(len,:)={plat};
            var.blanks(len,:)={blanks};
        end
        

        waitbar(i/length(files),wb,[num2str(i),' of ',f_num,' files processed'])
    end
end
close(wb)
load gong
sound (y,Fs)
end

