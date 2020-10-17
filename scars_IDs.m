function [plat,blanks,path,name] = scars_IDs( plat,blanks )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

[name, path] = uigetfile('ScarsQins-*.mat');
name_1=erase(name,'ScarsQins-');
name_1=erase(name_1,'.mat');
[name_1,path_1]=uiputfile('*.mat','Select file to save',[path,name_1,'_Scars_IDs.mat']);
save([path_1,name_1],'plat','blanks','path','name');
end

