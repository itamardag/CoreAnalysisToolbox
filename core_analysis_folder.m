function [ var ] = core_analysis_folder( segLength, segNum )
%CORE_ANALYSIS_FOLDER calculates the angle between scars and the jaggedness and 
%shape regularity of the striking platform based on the measures
%segLength and segNum and the informatios saved in the _ScarsAngles.mat files
%in a folder (files should be created with the scar_loop or scars_IDs function)
%   
%   INPUT
%   segLength : lenght in mm of the strip between which the angle is
%   calculated
%   segNum : number of strips on the STRIKING PLATFORM the most regular
%   among which is useed for the angle measure.
%   OUTPUT
%   var : structure with the results
%   Wait for the GONNNNNNNG!
fold = [uigetdir([], 'select folder containing ScarAngles files') '\'];%browse
files=dir(fold);
f_num=num2str(length(files));
wb=waitbar(0,['0 of ',f_num,' files processed']);
var.ang={};
var.var={};
var.angs={};
var.vars={};
var.path={};
var.name={};
var.plat={};
var.blanks={};
var.straightLineRidges={};
var.jaggedness={};
var.edgelengthVar={};
var.ridge_angVar={};
for i=1:length(files)
    if ~endsWith(files(i).name, 'ScarAngles.mat') || ~endsWith(files(i).name, 'Scars_IDs.mat')
        waitbar(i/length(files),wb,[num2str(i),' of ',f_num,' files processed'])
    else
        f_name=[fold '\' files(i).name];
        load(f_name,'name','path','plat','blanks');
        scars=load([path,name]);
        [angle,variance,angles,variances,plat,blanks]=scar_loop_f(plat,blanks,segLength,segNum,true,scars);
        [lines, jagg, L_var, ang_var] = StraightLineApprox(plat, blanks, scars);
        len=length(var.straightLineRidges)+1;
        var.ang(len,:)={angle};
        var.var(len,:)={variance};
        var.angs(len,:)={angles};
        var.vars(len,:)={variances};
        var.straightLineRidges(len,:)={lines};
        var.jaggedness(len,:)={jagg};
        var.edgelengthVar(len,:)={L_var};
        var.ridge_angVar(len,:)={ang_var};
        var.path(len,:)={path};
        var.name(len,:)={name};
        var.plat(len,:)={plat};
        var.blanks(len,:)={blanks};
        waitbar(i/length(files),wb,[num2str(i),' of ',f_num,' files processed'])
    end
end
close(wb)
load gong
sound (y,Fs)
end
