%% Plot variance partitioning

% Set where the data is and where we want the output.
data_path = '..\..\outputs\';
figure_path = '..\..\figures\';


% Draw bar plot
fig1=figure(9999);set(fig1,'PaperPosition',[0,0,8,10]) % Adjust printed size
plot_data=[unique_var.col,unique_var.sal, ...
    unique_var.ani, unique_var.nat,...
    unique_var.cat];
bplot=bar(plot_data);
bplot.FaceColor = 'flat';
for i=1:5
    bplot.CData(i,:)= rand(1,3);
end
hold on

% Draw stats
temp = [unique_var.col_pval,unique_var.sal_pval, ...
    unique_var.ani_pval, unique_var.nat_pval,...
    unique_var.cat_pval];
temp = temp<.05;

pos=1:5;
text(pos(temp),[.4,.4,.4],'*', 'FontSize', 20, 'Color', 'b')

% Format
xticklabels({'color';'saliency';'animacy';'natural';'category'})
xtickangle(45);axis([0 6 0 .55])
title('Unique variance explained by model')

%% Save fig
figure(fig1)
saveas(gcf,[figure_path, 'variance_partitioning.jpg'])


%     plotCount=1;d=1;
%     close all
%
%
%             temp=output.RDM_group{cROI}(1:48,1:48);
%
%
%
%             plot_data=output.RDM_group{cROI}(1:48,1:48);
%             mem_lab='episodic';
%
%         % Get sample averages
%         av_scn=squeeze(mean(scn,1));
%         av_obj=squeeze(mean(obj,1));
%         av_shared=squeeze(mean(shared,1));
%
%         % Comptue SE (SD/sqrt(N)) Boner and Epstein
%         se_scn=std(scn(:,cROI,cCond))/sqrt(size(scn,1));
%         se_obj=std(obj(:,cROI,cCond))/sqrt(size(obj,1));
%
%         % Draw Venn's diagram on correlation model
%         figure(9999)
%         subplot(1,4,plotCount),
%         [H,S]=venn([av_scn(cROI,cCond),av_obj(cROI,cCond),av_shared(cROI,cCond)], 'FaceColor', {[.9 0 .3 ];[.1 .7 1]});
%         axis('off')

% % Plot error bar
% er = errorbar([1,2],plot_data,[se_scn,se_obj],[se_scn,se_obj]);
% er.Color = [0 0 0];
% er.LineStyle = 'none';
% 
% 
% 
% % Stats
% [p,h,stats] = signrank(scn(:,cROI,cCond),obj(:,cROI,cCond),'tail','both');
% if p<.001;text(1.2,ymax*.9,'**', 'FontSize', 20);elseif p<.05;text(1.5,ymax*.9,'*', 'FontSize', 20);end

%         [p,h,stats] = signrank(scn(:,cROI,cCond),0,'tail','right');
%         if p<.001;text(.8,0-ymax*.1,'**', 'FontSize', 15, 'Color','r');elseif p<.05;text(.8,0-ymax*.1,'*', 'FontSize', 15,'Color','r');end
%
%         [p,h,stats] = signrank(obj(:,cROI,cCond),0,'tail','right');
%         if p<.001;text(1.8,0-ymax*.1,'**', 'FontSize', 15,'Color','r');elseif p<.05;text(1.8,0-ymax*.1,'*', 'FontSize', 15,'Color','r');end
