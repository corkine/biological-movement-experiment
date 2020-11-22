clc;clear;
load('allsub_E1_Int2.mat');
Xdata=x;
D=D(1:end,:);
ft = fittype('1/(1+exp(-a*(x-c)))');
ft1 = fittype('c-log((1-x)/x)/a');    %  反函数
criterion=[0.25 0.75];
PSE0=0.5;
m=50;
for i=1:length(D(:,1))  
     Ydata=D(i,1:7)
     fitmodelA0=zeros(1,m);
     fitmodelC0=zeros(1,m);
     goodnessall_Rsquare0=zeros(1,m);
      for  j=1:m
 [fitmodel0{j},goodnessfit]= fit(Xdata',Ydata',ft);
fitmodelA0(j)=fitmodel0{j}.a;
fitmodelC0(j)=fitmodel0{j}.c;
goodnessall_Rsquare0(j)=goodnessfit.rsquare
      end
  goodnessall_Rsquare(i)=max(goodnessall_Rsquare0);%取拟合度最优的
  [x y]=find(goodnessall_Rsquare0==goodnessall_Rsquare(i)); %定位拟合度最优的参数位置，从而选取对应的函数参数
  fitmodelA=fitmodelA0(y(1));
  fitmodelC=fitmodelC0(y(1));
  fitmodel=fitmodel0{y(1)};
 inversef =cfit(ft1,fitmodelA,fitmodelC);
PSE(i)= inversef(PSE0);
DL(i) = inversef(criterion(2))-inversef(criterion(1));


figure;
H = plot(fitmodel,Xdata',Ydata');
set(H,'LineWidth',1.5);
 axis([-700 700 0 1]);
%  annotation('arrow',[55.5228,55.5228],[0.2,0]) 
%  annotation('doublearrow',[-250.0913,139.039],[0.2,0.2])  

 line([-700,700],[0.5,0.5],'linestyle','-','Color','k');  
 line([PSE(i),PSE(i)],[0,0.5],'linestyle','-','Color','b');  
 line([0,0],[0,0.5],'linestyle','-','Color','k');  

% line([-700,-250.0913],[0.25,0.25],'linestyle','--','Color','b');
% line([-250.0913,-250.0913],[0,0.25],'linestyle','--','Color','b');  
% 
% line([-700,139.039],[0.75,0.75],'linestyle','--','Color','b');  
% line([139.039,139.039],[0,0.75],'linestyle','--','Color','b');  



% text(-98.5228,-0.02,'PSE','FontSize',10,'FontWeight','bold','Fontname', 'Times New Roman');

gcay=ylabel('Proportion of longer responses to upright signals');
set(gcay,'FontSize',12,'FontWeight','bold','Fontname', 'Times New Roman');


  gcax=xlabel('Duration deviation (upr vs. inv, ms)');
set(gcax,'FontSize',12,'FontWeight','bold','Fontname', 'Times New Roman');

 
 lh = legend(H,'','Location','northeast','Orientation','vertical');%2表示图例位置
set(lh,'FontSize',9,'FontWeight','normal','Fontname', 'Times New Roman');
set(lh, 'Box', 'off')
 lh = legend(H,'','Location','northeast','Orientation','vertical');%2表示图例位置
set(lh,'FontSize',9,'FontWeight','normal','Fontname', 'Times New Roman');
set(lh, 'Box', 'off')

 box off;
 
 filepath=pwd;           %保存当前工作目录
cd('F:\BM_time_weight\BM_Time_version2_E1sit_repeat20180608\E1_DataInt2\E1_int_figure')          %把当前工作目录切换到指定文件夹
 n1=num2str(i); n2='int';
 n=strcat(n1,n2) ;
saveas(lh, n, 'jpg'); 
 cd(filepath)            %切回原工作目录
end
PSE=PSE';
DL=DL';
goodnessall_Rsquare=goodnessall_Rsquare';
  ExpAllmean=sprintf('allsub_E1_Int2_PSE_CFT');
save(ExpAllmean,'goodnessall_Rsquare','DL','PSE','ft','D','x','fitmodelA','fitmodelC');
% 'fitmodelall','goodnessall'