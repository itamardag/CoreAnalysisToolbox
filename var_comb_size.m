function [ var ] = var_comb_size( var1,size_lim_low,size_lim_high)%scar_len_min,scar_len_max )
%Combine angle measurements for all the BLANK-SCARS ina a core assemblage.
%   Detailed explanation goes here

%set limit default values (no limits) 
if nargin<2
    size_lim_high=inf;
    size_lim_low=0;
%     scar_len_min=0;
%     scar_len_max=inf;
end
var.seg_length=var1.seg_length;
%set standars length for variables (add NaNs at the end of shortes columns)
L_angs=NaN(numel(var1.dif_pace),1);
L_dif=NaN(numel(var1.dif_pace),1);

for i=1:numel(var1.dif_pace)
    L_dif(i,:)=size(var1.dif_pace{i},1);
    L_angs(i,:)=size(var1.angs{i},1);
end
mL_dif=max(L_dif);%max length of differences
mL_angs=max(L_angs);%max length of angles
for i=find(L_dif<mL_dif)'%columns shorter than maximum
    var1.dif_pace{i}(L_dif(i)+1:mL_dif,:)=NaN;
    var1.dev_pace{i}(L_dif(i)+1:mL_dif,:)=NaN;
end
for i=find(L_angs<mL_angs)'%columns shorter than maximum
    var1.angs{i}(L_angs(i)+1:mL_angs,:)=NaN;
end
%define platform related variables based on size criteria.
var.ang=cell(0,1);
var.var=cell(0,1);
var.angs=cell(0,1);
var.vars=cell(0,1);
var.path=cell(0,1);
var.name=cell(0,1);
var.plat=cell(0,1);
var.blanks=cell(0,1);
var.dif_pace=cell(1,0);
var.dev_pace=cell(1,0);
var.scar_number=NaN(1,0);
var.data=cell(0,1);
var.core_size=NaN(1,0);
var.p_curv=cell(0,1);
var.p_L_var=NaN(0,1);
var.p_ang_var=NaN(0,1);
var.p_curv_avg=NaN(0,1);
var.p_ang_avg=NaN(0,1);
var.p_ang_turn=NaN(0,1);
var.p_s_lines=cell(0,1);
var.p_length=cell(0,1);
var.p_point_dist=cell(0,1);
for i=find(var1.core_size<=size_lim_high & var1.core_size>=size_lim_low)'
    var.ang=[var.ang;var1.ang{i}];
    var.var=[var.var;var1.var{i}];
    var.angs=[var.angs;var1.angs{i}];
    var.vars=[var.vars;var1.vars{i}];
    var.path=[var.path;var1.path{i}];
    var.name=[var.name;var1.name{i}];
    var.plat=[var.plat;var1.plat{i}];
    var.blanks=[var.blanks;var1.blanks{i}];
    var.dif_pace=[var.dif_pace,var1.dif_pace{i}];
    var.dev_pace=[var.dev_pace,var1.dev_pace{i}];
    var.scar_number=[var.scar_number,var1.scar_number(i)];
    var.data=[var.data,var1.data{i}];
    var.core_size=[var.core_size;var1.core_size(i)];
    var.p_curv=[var.p_curv;var1.p_curv{i}];
    var.p_L_var=[var.p_L_var;var1.p_L_var(i)];
    var.p_ang_var=[var.p_ang_var;var1.p_ang_var(i)];
    var.p_ang_avg=[var.p_ang_avg;var1.p_ang_avg(i)];
    var.p_curv_avg=[var.p_curv_avg;var1.p_curv_avg(i)];
    var.p_ang_turn=[var.p_ang_turn;var1.p_ang_turn(i)];
    var.p_s_lines=[var.p_s_lines;var1.p_s_lines(i)];
    var.p_length=[var.p_length;var1.p_length(i)];
    var.p_point_dist=[var.p_point_dist;var1.p_point_dist(i)];
end

%Define Scar-related variables based on size criteria
var.scar_angle=[];
var.scar_dif=[];
var.scar_dev=[];
var.scar_name={};
var.scar_path={};
var.plat_ID=[];
var.blank_ID=[];
var.scar_p_curv=[];
var.scar_core_size=[];
var.scar_p_width=[];
var.scar_p_ridge=[];
var.scar_p_point_dist=[];
% var.scar_jagg=[];
% var.avg_jagg=[];
% var.scar_w=[];
% var.scar_jagg_w=[];
% for i=1:numel(var.dif_pace)
for i=find(var1.core_size<=size_lim_high & var1.core_size>=size_lim_low)'
%     l_scar_ind=find(sum(~isnan(var.angs{i}))>=scar_len_min & sum(~isnan(var.angs{i}))<=scar_len_max); 
        %these are the indexes of scars within the length span
    var.scar_p_curv=[var.scar_p_curv;(var1.p_curv{i})'];
    var.scar_angle=[var.scar_angle,var1.angs{i}];%(:,l_scar_ind)];
    var.scar_dif=[var.scar_dif,var1.dif_pace{i}];%(:,l_scar_ind)];
    var.scar_dev=[var.scar_dev,var1.dev_pace{i}];%(:,l_scar_ind)];
    var.scar_name=[var.scar_name,repmat(var1.name(i),1,var1.scar_number(i))];
    var.scar_path=[var.scar_path,repmat(var1.path(i),1,var1.scar_number(i))];
    var.plat_ID=[var.plat_ID,repmat(var1.plat{i},1,var1.scar_number(i))];
    var.blank_ID=[var.blank_ID,var1.blanks{i}];
    var.scar_core_size=[var.scar_core_size;repmat(var1.core_size(i),var1.scar_number(i),1)];
   for j=1:length(var1.p_s_lines{i})
       var.scar_p_width=[var.scar_p_width;pdist(var1.p_s_lines{i}{j})];
       var.scar_p_ridge=[var.scar_p_ridge;var1.p_length{i}(j)];
       var.scar_p_point_dist=[var.scar_p_point_dist;var1.p_point_dist{i}(j)];
   end
%     var.scar_jagg=[var.scar_jagg,var.jaggedness{i}(:,l_scar_ind)];%];    
%     for ii=1:var.scar_number(i)
%         var.scar_w=[var.scar_w,pdist(var.straightLineRidges{i}{ii})];
%         var.scar_jagg_w=[var.scar_jagg_w,var.jaggedness{i}(ii)/var.scar_w(end)];
%     end
%     var.scar_w=[var.scar_w,widths];
    
%     var.avg_jagg=[var.avg_jagg,mean(var.jaggedness{i},2)]; 
    %it includes all the blank-scars, independently by their length
    
%     len=length(var1.scar_name);
% %     len_2=numel(l_scar_ind);
%     len_2=var1.scar_number(i);
%     %var.scar_name(len+1:len+len_2)={var1.name{i}};
%     %var.scar_path(len+1:len+len_2)={var1.path{i}};
%     var.plat_ID(len+1:len+len_2)=var1.plat{i};
%     var.blank_ID(len+1:len+len_2)=var1.blanks{i};%(l_scar_ind);
end
var.scar_p_ridge_width_ratio=var.scar_p_ridge./var.scar_p_width;
var.scar_length=sum(~isnan(var.scar_angle)).*var1.seg_length;
var.dif_ol=isoutlier(var.scar_dif,2);
var.ang_ol=isoutlier(var.scar_angle,2);
var.scar_angle_ol=var.scar_angle;
var.scar_dif_ol=var.scar_dif;
var.scar_dev_ol=var.scar_dev;
var.scar_dif_ol(var.dif_ol)=NaN;
var.scar_dev_ol(var.dif_ol)=NaN;
var.scar_angle_ol(var.ang_ol)=NaN;
ang_avg=(var.scar_angle(1:mL_dif,:)+var.scar_angle(2:mL_dif+1,:))./2;
% var.avg_jagg_ol=var.avg_jagg;
% var.avg_jagg_ol(isoutlier(var.avg_jagg_ol))=NaN;
ang_avg_ol=ang_avg;
ang_avg_ol(var.dif_ol)=NaN;
%scar_mean=nanmean(var.scar_angle);
var.ang_mean=nanmean(var.scar_angle_ol,2);
var.dif_mean=nanmean(var.scar_dif_ol,2);
var.ang_sd=sqrt(nanvar(var.scar_angle_ol,0,2)./sum(~isnan(var.scar_angle_ol),2));
%nansum(var.scar_dev_ol,2)) 
var.dif_sd=sqrt(nanvar(ang_avg_ol,0,2) ./ sum(~isnan(var.scar_dev_ol),2));
var.dif_sd(find(sum(~isnan(var.scar_dev_ol),2)<=length(L_angs)/10),:)=NaN;
var.dif_mean(find(sum(~isnan(var.scar_dev_ol),2)<=length(L_angs)/10),:)=NaN;
var.ang_mean(find(sum(~isnan(var.scar_angle_ol),2)<=length(L_angs)/10),:)=NaN;
var.ang_sd(find(sum(~isnan(var.scar_angle_ol),2)<=length(L_angs)/10),:)=NaN;
var.scar_angle_ol(find(sum(~isnan(var.scar_angle_ol),2)<=length(L_angs)/10),:)=NaN;
var.scar_dif_ol(find(sum(~isnan(var.scar_dev_ol),2)<=length(L_angs)/10),:)=NaN;
var.scar_dev_ol(find(sum(~isnan(var.scar_dev_ol),2)<=length(L_angs)/10),:)=NaN;
end
