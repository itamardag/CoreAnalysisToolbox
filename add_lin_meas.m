function [ var1 ] = add_lin_meas( var )
%ADD_LIN_MEAS adds the linear measurment, based on the technological
%orientation, of cores 
%   
if nargin<1
    var=struct;
end
fold = [uigetdir([], 'select folder containing ScarAngles or scars_IDs files') '\'];%browse
files=dir(fold);
f_num=num2str(length(files));
wb=waitbar(0,['0 of ',f_num,' files processed']);
var1=var;
var1.core_width={};
var1.core_length={};
var1.core_thickness={};
var1.surf_width={};
var1.surf_length={};
%var.surf_thickness={};
for i=1:length(files)
    if ~endsWith(files(i).name, 'ScarAngles.mat') && ~endsWith(files(i).name, 'Scars_IDs.mat')
        waitbar(i/length(files),wb,[num2str(i),' of ',f_num,' files processed'])
    else
        f_name=[fold '\' files(i).name];
        load(f_name,'name','path','plat','blanks');
        scars=load([path,name]);
        qins_name=erase(name,'Scars');
        [~, ~, ~, ~, ~, ~, ~, blanks] = StraightLineApprox(plat, blanks, scars, path, name);
        [c_width, surf_width, c_length, surf_length, c_thickness] = ... %, surf_thickness
            FindBounds(blanks, qins_name, path);
        len=length(var1.core_width)+1;
        var1.core_width(len,:)={c_width};
        var1.core_length(len,:)={c_length};
        var1.core_thickness(len,:)={c_thickness};
        var1.surf_width(len,:)={surf_width};
        var1.surf_length(len,:)={surf_length};
        %var1.surf_thickness(len,:)={surf_thickness};
        waitbar(i/length(files),wb,[num2str(i),' of ',f_num,' files processed'])
    end
end
close(wb)
load gong
sound (y,Fs)
end

