function [plat,blanks,path,name] = scars_IDs( plat,blanks )
%UNTITLED Creates a _Scars_IDs.mat file with the technological interpretation of scar
%segmentation (i.e., IDs of striking platform and blank scars)
%
%The resulting file might be used by the core_analysis_folder or
%core_analysis_folder_2 function

[name, path] = uigetfile('ScarsQins-*.mat');
name_1=erase(name,'ScarsQins-');
name_1=erase(name_1,'.mat');
[name_1,path_1]=uiputfile('*.mat','Select file to save',[path,name_1,'_Scars_IDs.mat']);
save([path_1,name_1],'plat','blanks','path','name');
end

