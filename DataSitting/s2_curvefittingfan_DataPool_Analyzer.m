clc;clear;
%%%%   c_Location_DataPool_Analyzer
type=2; % 1=int, 2=scr
Ad.CurveFittingOption=2; % 1: CFT; 2: glmfit (should use this);
if type==1
load('allsub_sit_disable_Int.mat');
 ExpAllmean=sprintf('allsub_sit_disable_PSE_Int');
else
load('allsub_sit_disable_Scr.mat');
 ExpAllmean=sprintf('allsub_sit_disable_PSE_Scr');
end
%  ydata=[ydata(1:5,:);ydata(8:12,:)]; % 6 and 7 were deleted
 ydata=ydata;
 
 I=size(ydata,1);
a=[20 20 20 20 20 20 20];
  ndata=repmat(a,I,1);
 
dp.alpha=[]; dp.beta=[]; dp.discrim=[]; dp.DEV=[]; dp.STATS=[]; 
dp.PSE=[]; dp.Slope_beta=[]; dp.Slope_discrim=[];  % alpha, beta， discrim, DEV是函数的参数

 for J=1:I
    
 DEV=[0]; STATS=[0];% The "DEV" output from glmfit is the deviance, and it can be used to compare models or test whether a larger model fits significantly better than a smaller one. 
     x=x'; %-600,-400,-200,0,200,400,600
     y=ydata(J,:)';
    n=ndata(J,:)';
   if Ad.CurveFittingOption==1 %   CFT
       X=x;
       Y=y;
   F.plotindividualPsycurve=1;
   F.FunctionOption=101; %% F.FunctionType='1/(1+  exp(-(x-d)/b)  )'; %1/(1+exp(-a*(x-c)))
   F.y_value=0.95;
   c_Curve_fitting_01;% 单独的.m文件
   alpha=F.alpha; beta=F.beta; discrim=F.discrim;
   end

   if Ad.CurveFittingOption==2  % glmfit should use this one
   Ad.plotindividualPsycurve=2; % 1=draw figure
   Ad.Link_Function_Name='logit';
   [alpha, beta, discrim, DEV, STATS]=F_sigmond_curve_fitting(x,y,n, Ad);
   beta;
   end
 %{  
   y is frequency of observed event (event 0 or event 1, binominal distributed variable), 
n is total observation numbers (sample sizes，上述对应y值条件下的trial总数，频率为y/n). In our cases, proportion and probability of 1 are the same. 
The Y-axis is P, which indicates the proportion / probability of 1s at any given value of height.   
b adjusts how quickly the probability changes with changing X a single unit. 
   %}
   PSE=alpha;
   Slope_beta=beta*(1/4);
   Slope_discrim=discrim;

 
  dp.alpha(J,:)=alpha; dp.beta(J,:)=beta; dp.discrim(J,:)=discrim; dp.DEV(J,:)=DEV; 
   
    dp.PSE(J,:)=PSE; dp.Slope_beta(J,:)=Slope_beta; dp.Slope_discrim(J,:)=Slope_discrim; dp.STATS{J}=STATS; 
 end

PSEmean=mean(dp.PSE);
Cond=4*ones(size(subnum,2),1);
PSEresults=[subnum',Cond,dp.PSE,dp.DEV,dp.discrim];

save(ExpAllmean,'PSEresults','subnum','dp','PSEmean');
 
% dp.TD=dp.PSE-max(ST.Frames_Time)*1000;  % Time Distortion;% not ST.ProbeStimTime(4) but max(ST.Frames_Time) indeed!!!!!
% dp.TD_N1=dp.PSE-repmat(min(dp.PSE), M, 1);  % Time Distortion_New1;
% %dp.TD_N1=dp.PSE-repmat(dp.PSE(1,:), M, 1);  
% a1=mean(dp.EC/F.seed, 3);
% color_1=['b-'; 'r-'; 'k-'; 'g-'];
% [M1, N1]=size(a1);
% 
% figure;
% for a2=1:M1
%   plot(x, a1(a2,:), color_1(a2,:) ); hold on;
% end;
% legend('1 Location','2 Locations','3 Locations', '4 Locations')
% %set(gca,'box','off')
%  title(['Psychological Physical Curve',], 'FontSize',14);xlabel('Probe Time(ms)'); ylabel(' The Ratio of Standarded Stimuli Longer');
% 
% 
% 
% 
% 
% useaxislimit=1;
% axis3=[0 5 0 600];
% myYTick=[0:50:600];
% 
% M_size=6;L_width=1;L_width2=2;myTitleFontSize=14;
% 
% M_TD=mean(dp.TD,2)'; M_TD_errors= F_CI_Calculator(dp.TD'); if I==1 M_TD_errors=M_TD-M_TD; end;
% M_TD_N1=mean(dp.TD_N1,2)'; M_TD_N1_errors= F_CI_Calculator(dp.TD_N1'); if I==1 M_TD_N1_errors=M_TD_N1-M_TD_N1; end;
% 
% X1=[1:4]; x_label01='Location Number'; myXTick=[0:1:5]; 
% 
% 
% 
% %cla;clf;
%     H=0;
% 
%     figure;
%     H(1) = errorbar(X1, M_TD, M_TD_errors);hold on;
%     
%      cbxplot_format_line(H(1),L_width,'-','k','s',M_size);
%      
%      
%      H(2) = errorbar(X1, M_TD_N1, M_TD_N1_errors);hold on;
%      cbxplot_format_line(H(2),L_width,'-','r','s',M_size);
% 
%     legend('boxoff');
%     set(gcf, 'color', 'white');
%     if useaxislimit
%     axis(axis3);
%     set(gca, 'YTick', myYTick);    set(gca, 'XTick', myXTick);
%     end;
%     set(gca,'box','off')
%     title(['Time Distortion (ms)',], 'FontSize',myTitleFontSize);xlabel(x_label01); ylabel(' diff of PSEs (ms)');
% 
% 
% 
% 
%         FirstLine=[]; SecondLine=[];
%         for i=1:length(X1)
%           add='LocNum'; 
%           FirstLine=[FirstLine add num2str(X1(i)) ' ']; 
%           SecondLine=[SecondLine '%6.5f '];
%         end;
%         FirstLine=[FirstLine '\n']; SecondLine=[SecondLine '\n'];
% 
%         fid = fopen(['z_' ep.ResultFileName_head  'TD'  '.txt'],'wt'); 
%         fprintf(fid,FirstLine);
%         fprintf(fid,SecondLine, dp.TD);
%         fclose(fid);
%         fid = fopen(['z_' ep.ResultFileName_head  'TD_N1'  '.txt'],'wt'); 
%         fprintf(fid,FirstLine);
%         fprintf(fid,SecondLine, dp.TD_N1);
%         fclose(fid);
% 
% 
% 
% 
% 
% 
