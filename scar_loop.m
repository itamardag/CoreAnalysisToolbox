function [ ang,var,angs,vars,plat,blanks,gr,path,name ] = scar_loop( plat, blanks,...
    segmentLength,segmentNumber,useSPStable,scars,file )
%Performs the mesurement of the angle between the scar denoted by plat and
%each of the scars denoted by blanks and save them in a _ScarAngles.mat
%file.
%The resulting file might be used by the core_analysis_folder or
%core_analysis_folder_2 function.
%
%Returns also a graphic (gr) with the variability of the angle relative to the
%distance from the edge in each scar
if nargin < 6
    [name, path] = uigetfile('ScarsQins-*.mat');
    fileName = [path '\' name];
    scars = load(fileName);
end
ang=NaN(length(blanks),1);
var=NaN(length(blanks),1);
c_angs=cell(1,length(blanks));
c_vars=cell(1,length(blanks));
sz=NaN(1,length(blanks));
for i=1:length(blanks)
    [ang(i),var(i),c_angs{i},c_vars{i}]=AngleBetweenScars(plat,blanks(i),...
        segmentLength,segmentNumber,useSPStable,scars,file);
    sz(i)=length(c_angs{i});
end
angs=NaN(max(sz),length(blanks));
vars=NaN(max(sz),length(blanks));
lgnd=cell(1,length(blanks));
gr=figure;
for i=1:length(blanks)
    angs(1:sz(i),i)=c_angs{i};
    vars(1:sz(i),i)=c_vars{i};
    errorbar(1:segmentLength:(max(sz))*segmentLength,rad2deg(angs(:,i)),rad2deg(vars(:,i)));    
    hold on
    lgnd{i}=strcat('Scars ',num2str(plat),'-',num2str(blanks(i)));   
end
  figure(gr)
  xlabel('Distance (mm)')
  ylabel('Angle (deg.)')
  legend(lgnd,'Location','best')
  grid on
if nargin < 6
    name_1=erase(name,'ScarsQins-');
    name_1=erase(name_1,'.mat');
    [name_1,path_1]=uiputfile('*.mat','Select file to save',[path,name_1,'_ScarAngles.mat']);
    save([path_1,name_1],'ang','var','angs','vars','plat','blanks','path','name');
    name_1=erase(name_1,'.mat');
    savefig(gr,[path_1,name_1,'_figure.fig'])


end

