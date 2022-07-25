function [ var ] = core_analysis_folder_2( segLength, segNum, runCPA, runAC, runLIN)
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
%   runCPA : flag to include or exclude CPA calculation
%   runAC : flag to include or exclude AC calculation
%   runLIN : flag to include or exclude Linear Measurement calculation
%   OUTPUT
%   var : structure with the results
%   Wait for the GONNNNNNNG!

if nargin < 5
    runLIN = true;
end
if nargin < 4
    runAC = true;
end
if nargin < 3
    runCPA = true;
end

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
        if runCPA
            [~,~,angles,variances,plat,blanks]=... 
                scar_loop_f(plat,blanks,segLength,segNum,true,scars,name);
            
            var.CPA(i,:)={rad2deg(angles)};
            var.CPA_err(i,:)={rad2deg(variances)};
        end

        %Calculate AC
        if runAC
            [~, jagg, ~, ~,~,~,avg_p_dist,~] = ... 
                StraightLineApprox(plat, blanks, scars, path, name);

            var.AC(i,:)={jagg};
            var.AC_avg_p_dist(i,:)={avg_p_dist(:,1)};
        end

        %Calculate linear measurements
        if runLIN
            [c_width, surf_width, c_length, surf_length, c_thickness] = ... 
                FindBounds(plat, blanks, qins_name, path);
            var.core_width(i,:)={c_width};
            var.core_length(i,:)={c_length};
            var.core_thickness(i,:)={c_thickness};
            var.surf_width(i,:)={surf_width};
            var.surf_length(i,:)={surf_length};
        end

        if runCPA && runAC
            s_w=avg_p_dist(:,2);
            s_l=segLength*sum(~isnan(angles))';
            var.scar_width(i,:)={s_w};
            var.scar_length(i,:)={s_l};
        end
        
        var.path(i,:)={path};
        var.name(i,:)={name};
        var.plat(i,:)={plat};
        var.blanks(i,:)={blanks};
        
        waitbar(i/length(files),wb,[num2str(i),' of ',f_num,' files processed'])
    else
        waitbar(i/length(files),wb,[num2str(i),' of ',f_num,' files processed'])
    end
end
close(wb)
load gong
sound (y,Fs)
end
