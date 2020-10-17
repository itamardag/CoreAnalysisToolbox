function baseAngles = Base_loop( segmentLength,segmentNumber )
%BASE LOOP calculates the base angle based on the measures
%segLength and segNum and the information saved in the _ScarsAngles.mat files
%in a folder (files should be created with the scar_loop function)
%   INPUT
%   segLength : lenght in mm of the strip between which the angle is
%   calculated
%   segNum : number of strips on the STRIKING PLATFORM the most regular
%   among which is useed for the angle measure.
path = [uigetdir([], 'select folder containing ScarAngles files') '\'];%browse
files=dir(path);
f_num=num2str(length(files));
wb=waitbar(0,['0 of ',f_num,' files processed']);
baseAngles=[];
for i=1:length(files)
    if ~endsWith(files(i).name, 'ScarAngles.mat')
        waitbar(i/length(files),wb,[num2str(i),' of ',f_num,' files processed'])
    else
        f_name=[path '\' files(i).name];
        var=load(f_name,'name','path','plat','blanks');
        baseAngles=[baseAngles;BaseAngle(var.plat,var.blanks,segmentLength,segmentNumber,[var.path,var.name])];
        waitbar(i/length(files),wb,[num2str(i),' of ',f_num,' files processed'])
    end
end     
close(wb)
load gong
sound (y,Fs)
end

