function [ var ] = ridge_dim_folder( boxSizes )
%RIDGE_DIM_FOLDER calculates the fractal dimensionality of the platform ridge
% based on boxSizes and the informatios saved in the _ScarsAngles.mat files
% in a folder (files should be created with the scar_loop function)

% CONSIDER MERGING WITH scars_folder FOR A COMPLETE PROCESSING...

%   OUTPUT
%   var : structure with the results
fold = [uigetdir([], 'select folder containing ScarAngles files') '\'];%browse
files=dir(fold);
f_num=num2str(length(files));
wb=waitbar(0,['0 of ',f_num,' files processed']);
var.counts={};
var.boxSizes={};
var.ridge_dim={};
var.path={};
var.name={};
var.plat={};
var.blanks={};
for i=1:length(files)
    if ~endsWith(files(i).name, 'ScarAngles.mat')
        waitbar(i/length(files),wb,[num2str(i),' of ',f_num,' files processed'])
    else
        f_name=[fold '\' files(i).name];
        load(f_name,'name','path','plat','blanks');
        scars=load([path,name]);
        [counts, boxSizes, D] = RidgeDimension(plat, blanks, boxSizes, scars);
        len=length(var.counts)+1;
        var.counts(len,:)={counts};
        var.boxSizes(len,:)={boxSizes};
        var.ridge_dim(len,:)={D};
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

