function [BMcon]=BMtransUpr(BM)

if size(BM,2)~=2
    fprintf('no 2D coordinates!\n');
    return
end

marker=size(BM,1);
frame=size(BM,3);
types=size(BM,4);

BMfit=zeros(marker,types,3);
for i=1:types
    for j=1:marker
        x=squeeze(BM(j,1,:,i));
        y=squeeze(BM(j,2,:,i));
        abc = [x y ones(length(x),1)] \ -(x.^2 + y.^2);
        BMfit(j,i,1) = -abc(1)/2;
        BMfit(j,i,2) = -abc(2)/2;
        BMfit(j,i,3) = sqrt((BMfit(j,i,1)^2 + BMfit(j,i,2)^2) - abc(3));
    end
end
    
BMcon=zeros(marker,2,frame,types);
for i=1:types
    if marker==2 %two feet only
        for k=1:frame
            BMstep(k)=BM(1,1,k,i)-BM(1,1,1,i);
        end
        [Y,I1]=max(BMstep);
        [Y,I2]=min(BMstep);
        I=sort([1 I1 I2]);
        circle_theta=acos((BM(1,1,I,i)-BMfit(1,i,1))/BMfit(1,i,3));
        I(1)=[];
        circle_fit=[linspace(circle_theta(1),circle_theta(2),I(1)) linspace(circle_theta(2),circle_theta(3),I(2)-I(1)+1) linspace(circle_theta(3),circle_theta(1),frame-I(2)+1)];
        circle_fit(I(2))=[];
        circle_fit(I(1))=[];
        initframe=RandSample(1:frame);
        BMcon(1,1,:,i)=BMfit(1,i,3)*cos(circle_fit([initframe:frame 1:initframe-1]))+BMfit(1,i,1);
        BMcon(1,2,:,i)=BMfit(1,i,3)*sin(circle_fit([initframe:frame 1:initframe-1]))+BMfit(1,i,2);
        initframe=RandSample(1:frame);
        BMcon(2,1,:,i)=BMfit(1,i,3)*cos(circle_fit([initframe:frame 1:initframe-1]))+BMfit(1,i,1);
        BMcon(2,2,:,i)=BMfit(1,i,3)*sin(circle_fit([initframe:frame 1:initframe-1]))+BMfit(1,i,2);
    else
    for j=1:marker
        for k=1:frame
            BMstep(k)=BM(j,1,k,i)-BM(j,1,1,i);
        end
        [Y,I1]=max(BMstep);
        [Y,I2]=min(BMstep);
        I=sort([1 I1 I2]);
        circle_theta=acos((BM(j,1,I,i)-BMfit(j,i,1))/BMfit(j,i,3));
        I(1)=[];
        circle_fit=[linspace(circle_theta(1),circle_theta(2),I(1)) linspace(circle_theta(2),circle_theta(3),I(2)-I(1)+1) linspace(circle_theta(3),circle_theta(1),frame-I(2)+1)];
        circle_fit(I(2))=[];
        circle_fit(I(1))=[];
        initframe=RandSample(1:frame);
        BMcon(j,1,:,i)=BMfit(j,i,3)*cos(circle_fit([initframe:frame 1:initframe-1]))+BMfit(j,i,1);
        BMcon(j,2,:,i)=BMfit(j,i,3)*sin(circle_fit([initframe:frame 1:initframe-1]))+BMfit(j,i,2);
    end
    end
end
return