function BMSearch_Analysis(indata)
% BMSearch_Analysis(indata)

load(indata);
data=zeros(max(cuecond),length(setsize),3);
for i=1:size(results,1)
    if results(i,4)>0
    for j=1:length(setsize)
    if results(i,2)==setsize(j)
    data(results(i,1),j,1)=data(results(i,1),j,1)+results(i,3);%Acc
    if results(i,3)==1
    data(results(i,1),j,2)=data(results(i,1),j,2)+results(i,4);%RT
    end
    data(results(i,1),j,3)=data(results(i,1),j,3)+1;
    end
    end
    end
end
outdata{1}=squeeze(data(:,:,1)./data(:,:,3));
fprintf('ACC data\ncue condition x set size\n');
disp(outdata{1});
outdata{2}=squeeze(data(:,:,2)./data(:,:,1));
fprintf('RT data\ncue condition x set size\n');
disp(outdata{2});

data=zeros(max(cuecond),length(setsize),3);
halfsize=round(max(setsize)/2)-1;
for i=1:size(results,1)
    if results(i,4)>0
    for j=1:length(setsize)
    if results(i,2)==setsize(j) && (results(i,1)==1 || results(i,1)==3)
        if (tarpos(i,1)>1) && (tarpos(i,1)<=1+halfsize)
    data(results(i,1),j,1)=data(results(i,1),j,1)+results(i,3);%Acc
    if results(i,3)==1
    data(results(i,1),j,2)=data(results(i,1),j,2)+results(i,4);%RT
    end
    data(results(i,1),j,3)=data(results(i,1),j,3)+1;
        elseif tarpos(i,1)>=1+(max(setsize)-halfsize)
    data(results(i,1)+1,j,1)=data(results(i,1)+1,j,1)+results(i,3);%Acc
    if results(i,3)==1
    data(results(i,1)+1,j,2)=data(results(i,1)+1,j,2)+results(i,4);%RT
    end
    data(results(i,1)+1,j,3)=data(results(i,1)+1,j,3)+1;
        end
    end
    end
    end
end
outdata{1}=squeeze(data(:,:,1)./data(:,:,3));
fprintf('ACC data [Visual Field]\ncue condition x set size\n');
disp(outdata{1});
outdata{2}=squeeze(data(:,:,2)./data(:,:,1));
fprintf('RT data [Visual Field]\ncue condition x set size\n');
disp(outdata{2});
return