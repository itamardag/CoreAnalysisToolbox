function [ var ] = core_analysis_folder_2( segLength, segNum )
%CORE_ANALYSIS_FOLDER calculates the angle between scars (CPA) and 
%the average curvature of the edge of the striking platform of each blank, 
%and the reduction surface and core linear meaurements (Length, Width, Thickness)
%based on the measures segLength and segNum and the information saved in the 
%_ScarsAngles.mat or _Scars_IDs.mat files in a folder
%
%Files might be created with the scar_loop or scars_IDs function
%   
%   INPUT
%   segLength : lenght in mm of the strip between which the angle is
%   calculated
%   segNum : number of strips on the STRIKING PLATFORM the most regular
%   among which is useed for the angle measure.
%   OUTPUT
%   var : structure with the results
%   Wait for the GONNNNNNNG!
fold = [uigetdir([], 'select folder containing ScarAngles or scars_IDs files') '\'];%browse
files=dir(fold);
f_num=num2str(length(files));
wb=waitbar(0,['0 of ',f_num,' files processed']);
var.path={};
var.name={};
var.plat={};
var.blanks={};
var.CPA={};
var.CPA_err={};
var.AC={};
var.AC_avg_p_dist={};
var.scar_width={};
var.scar_length={};
var.core_width={};
var.core_length={};
var.core_thickness={};
var.surf_width={};
var.surf_length={};

for i=1:length(files)
    if endsWith(files(i).name, 'ScarAngles.mat') || endsWith(files(i).name, 'Scars_IDs.mat')
        f_name=[fold '\' files(i).name];
        load(f_name,'name','path','plat','blanks');
        scars=load([path,name]);
        qins_name=erase(name,'Scars');
        %Calculate CPA
        [~,~,angles,variances,plat,blanks]=... 
            scar_loop_f(plat,blanks,segLength,segNum,true,scars,name);
        %Calculate AC
        [~, jagg, ~, ~,~,~,avg_p_dist,~] = ... 
            StraightLineApprox(plat, blanks, scars, path, name);
        %Calculate linear measurements
        [c_width, surf_width, c_length, surf_length, c_thickness] = ... 
            FindBounds(blanks, qins_name, path);
        s_w=avg_p_dist(:,2);
        s_l=segLength*sum(~isnan(angles))';
        
        len=length(var.AC)+1;
        var.CPA(len,:)={rad2deg(angles)};
        var.CPA_err(len,:)={rad2deg(variances)};
        var.AC(len,:)={jagg};
        var.AC_avg_p_dist(len,:)={avg_p_dist(:,1)};
        var.path(len,:)={path};
        var.name(len,:)={name};
        var.plat(len,:)={plat};
        var.blanks(len,:)={blanks};
        var.scar_width(len,:)={s_w};
        var.scar_length(len,:)={s_l};
        var.core_width(len,:)={c_width};
        var.core_length(len,:)={c_length};
        var.core_thickness(len,:)={c_thickness};
        var.surf_width(len,:)={surf_width};
        var.surf_length(len,:)={surf_length};
        waitbar(i/length(files),wb,[num2str(i),' of ',f_num,' files processed'])
    else
        waitbar(i/length(files),wb,[num2str(i),' of ',f_num,' files processed'])
    end
end
close(wb)
load gong
sound (y,Fs)
end
