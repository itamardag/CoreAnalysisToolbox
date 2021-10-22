function [ ang,var,angs,vars,plat,blanks,err_c,err_id] = scar_loop_f( plat, blanks,...
    segmentLength,segmentNumber,useSPStable,scars,file )
%Perform the mesurement of the angle between the scar denoted by plat and
%each of the scars denoted by blanks.

if nargin < 6
    [name, path] = uigetfile('ScarsQins-*.mat');
    file = [path '\' name];
    scars = load(file);
end
ang=NaN(0,1);
var=NaN(0,1);
c_angs=cell(1,0);
c_vars=cell(1,0);
sz=NaN(1,0);
err_c=cell(0,1);
err_id=zeros(length(blanks),1);
for i=1:length(blanks)
    [ang_i,var_i,angs_i,vars_i,err]=AngleBetweenScars(plat,blanks(i),...
        segmentLength,segmentNumber,useSPStable,scars,file);
    if ~isempty(err)
        err_c{size(err_c,1)+1,:}=err;
        err_id(i,1)=1;
    else
        ang(size(ang,1)+1,:)=ang_i;
        var(size(var,1)+1,:)=var_i;
        c_angs{:,size(c_angs,2)+1}=angs_i;
        c_vars{:,size(c_vars,2)+1}=vars_i;
        sz(:,size(sz,2)+1)=length(angs_i);
    end
        
%     sz(i)=length(c_angs{i});
end
angs=NaN(max(sz),size(ang,1));
vars=NaN(max(sz),size(ang,1));
% lgnd=cell(1,length(blanks));
% gr=figure;
for i=1:size(ang,1)
    angs(1:sz(i),i)=c_angs{i};
    vars(1:sz(i),i)=c_vars{i};
%     errorbar(1:segmentLength:(max(sz))*segmentLength,rad2deg(angs(:,i)),rad2deg(vars(:,i)));    
%     hold on
%     lgnd{i}=strcat('Scars ',num2str(plat),'-',num2str(blanks(i)));   
end
%   figure(gr)
%   xlabel('Distance (mm)')
%   ylabel('Angle (deg.)')
%   legend(lgnd,'Location','best')
%   grid on
if nargin < 6
    name_1=erase(name,'ScarsQins-');
    name_1=erase(name_1,'.mat');
    [name_1,path_1]=uiputfile('*.mat','Select file to save',[path,name_1,'_ScarAngles.mat']);
    save([path_1,name_1],'ang','var','angs','vars','plat','blanks','path','name');
%     name_1=erase(name_1,'.mat');
%      savefig(gr,[path_1,name_1,'_figure.fig'])


end

end

