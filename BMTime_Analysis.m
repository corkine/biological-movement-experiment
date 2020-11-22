function BMTime_Analysis(datafile)
load(datafile);
UprOrder=1:2; %1=the 1st is upr
UprType=1:2;% 1=the order of standard duration
DurationType=[0.4 0.6 0.8 1 1.2 1.4 1.6];
Duration=1:length(DurationType);

data=zeros(length(Duration),20);
results=results(results(:,4)>0,:);
% Upr is compare time, Upr-Inv=-0.6, -0.4,-0.2,0, 0.2,0.4 0.6:  1-2 and 2-1
% Upr is standard time, Upr-Inv=0.6 0.4 0.2 0 -0.2 -0.4 -0.6; 1-1 and 2-2

 results1=results(results(:,1)==1,:);
 results2=results(results(:,1)==2,:);
 results11=results1(results1(:,2)==1,:);
 results12=results1(results1(:,2)==2,:);
 results21=results2(results2(:,2)==1,:);
 results22=results2(results2(:,2)==2,:);
 

for i=1:size(results,1)/4
        data(results11(i,3),11)=data(results11(i,3),11)+1;%Num of  trial----Upr1 Stand1 6 4 2 0
        data(results12(i,3),2)=data(results12(i,3),2)+1;%Num of  trial----Upr1 Stand2 -6
        data(results21(i,3),3)=data(results21(i,3),3)+1;%Num of  trial----Upr2 Stand1 -6
        data(results22(i,3),14)=data(results22(i,3),14)+1;%Num of  trial----Upr2 Stand2 6      
end

%% 11
for i=1:size(results,1)/4 
   if  results11(i,4)==1 && results11(i,3)==1
       data(1,15)= data(1,15)+1;
   elseif results11(i,4)==1 && results11(i,3)==2
       data(2,15)= data(2,15)+1;
       elseif results11(i,4)==1 && results11(i,3)==3
       data(3,15)= data(3,15)+1;
          elseif results11(i,4)==1 && results11(i,3)==4
       data(4,15)= data(4,15)+1;
          elseif results11(i,4)==1 && results11(i,3)==5
       data(5,15)= data(5,15)+1;
          elseif results11(i,4)==1 && results11(i,3)==6
       data(6,15)= data(6,15)+1;
          elseif results11(i,4)==1 && results11(i,3)==7
       data(7,15)= data(7,15)+1;    
   end 
end
%% 12
for i=1:size(results,1)/4 
   if  results12(i,4)==1 && results12(i,3)==1
       data(1,6)= data(1,6)+1;
   elseif results12(i,4)==1 && results12(i,3)==2
       data(2,6)= data(2,6)+1;
       elseif results12(i,4)==1 && results12(i,3)==3
       data(3,6)= data(3,6)+1;
          elseif results12(i,4)==1 && results12(i,3)==4
       data(4,6)= data(4,6)+1;
          elseif results12(i,4)==1 && results12(i,3)==5
       data(5,6)= data(5,6)+1;
          elseif results12(i,4)==1 && results12(i,3)==6
       data(6,6)= data(6,6)+1;
          elseif results12(i,4)==1 && results12(i,3)==7
       data(7,6)= data(7,6)+1;    
   end 
end
%% 21
for i=1:size(results,1)/4 
   if  results21(i,4)==2 && results21(i,3)==1
       data(1,7)= data(1,7)+1;
   elseif results21(i,4)==2 && results21(i,3)==2
       data(2,7)= data(2,7)+1;
       elseif results21(i,4)==2 && results21(i,3)==3
       data(3,7)= data(3,7)+1;
          elseif results21(i,4)==2 && results21(i,3)==4
       data(4,7)= data(4,7)+1;
          elseif results21(i,4)==2 && results21(i,3)==5
       data(5,7)= data(5,7)+1;
          elseif results21(i,4)==2 && results21(i,3)==6
       data(6,7)= data(6,7)+1;
          elseif results21(i,4)==2 && results21(i,3)==7
       data(7,7)= data(7,7)+1;    
   end 
end
%% 22
for i=1:size(results,1)/4 
   if  results22(i,4)==2 && results22(i,3)==1
       data(1,18)= data(1,18)+1;
   elseif results22(i,4)==2 && results22(i,3)==2
       data(2,18)= data(2,18)+1;
       elseif results22(i,4)==2 && results22(i,3)==3
       data(3,18)= data(3,18)+1;
          elseif results22(i,4)==2 && results22(i,3)==4
       data(4,18)= data(4,18)+1;
          elseif results22(i,4)==2 && results22(i,3)==5
       data(5,18)= data(5,18)+1;
          elseif results22(i,4)==2 && results22(i,3)==6
       data(6,18)= data(6,18)+1;
          elseif results22(i,4)==2 && results22(i,3)==7
       data(7,18)= data(7,18)+1;    
   end 
end

    %% the sum of Upr is longer
    for n=1:length(DurationType)
        m=length(DurationType);
    data(n,1)=data(m-(n-1),11);
     data(n,4)=data(m-(n-1),14);
         data(n,5)=data(m-(n-1),15);
     data(n,8)=data(m-(n-1),18);
    end
    data(:,9)=data(:,1)+data(:,2)+data(:,3)+data(:,4);% all
    data(:,10)=data(:,5)+data(:,6)+data(:,7)+data(:,8);% longer

  outdata=data(:,10)./data(:,9);

fprintf('Frequency data\n');
 disp(outdata);
end
 
   