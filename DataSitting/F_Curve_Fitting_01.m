% F_Curve_Fitting_01
function [F ] = F_Curve_Fitting_01(X, Y, F)

%% pay attention: this function is valid when only the real data points of Y is between Y(1)-1
%%		  and the (X(1), Y(1)) is used as starting values in the fitting!!!

X = X(:);
Y = Y(:);




if F.FunctionOption==1 
	F.FunctionType='(a*(x-d))/(b+x-d)+c'; 
        F.ReverseFunction='(b*(F.y_value-c))/(a-(F.y_value-c))+d';
        F.ParaList={'a', 'b', 'c', 'd'};
end
if F.FunctionOption==3 
	F.FunctionType='(a*(x-d))/(b+x-d)+1-a'; 
        F.ReverseFunction='(b*(F.y_value-1+a))/(a-(F.y_value-1+a))+d';
        F.ParaList={'a', 'b', 	 'd'};
end
if F.FunctionOption==2 
	F.FunctionType='a*(1-exp(-(x-d)/b))+c'; 
        F.ReverseFunction='d-b*log(1-(F.y_value-c)/a)';
        F.ParaList={'a', 'b', 'c', 'd'};
end
if F.FunctionOption==4 
	F.FunctionType='a*(1-exp(-(x-d)/b))+1-a'; 	% equal to '1-a*exp(-(x-d)/b)'
        F.ReverseFunction='d-b*log(1-(F.y_value-1+a)/a)';
        F.ParaList={'a', 'b', 	 'd'};
end


if F.FunctionOption==5 
	F.FunctionType='a*(x-d)+c'; 
        F.ReverseFunction='(F.y_value-c)/a+d';
        F.ParaList={'a', 	 'c', 'd'};
end
if F.FunctionOption==6 
	F.FunctionType='a*(log(x)-d)+c'; 
        F.ReverseFunction='exp( (F.y_value-c+a*d)/a )';
        F.ParaList={'a', 	 'c', 'd'};
end

if F.FunctionOption==7 
	F.FunctionType='a*10^(log(x)-d)+c-1'; 
        F.ReverseFunction='exp(    (log((F.y_value-c+1)/a)/log(10) ) +d    )';
        F.ParaList={'a', 	 'c', 'd'};
end

if F.FunctionOption==8 
	F.FunctionType='0.5+0.5*(1/(1+  exp(-(x-d)/b)  ))'; 
        F.ReverseFunction='d-b*log(1 / (2*(F.y_value-0.5)) -1)';
        F.ParaList={'b', 'd'};
end

if F.FunctionOption==9 
	F.FunctionType='LL+(UL-LL)*(1/(1+  exp(-(x-d)/b)  ))'; 
        F.ReverseFunction='d-b*log(1 / ((1/(UL-LL))*(F.y_value-LL)) -1)';
        F.ParaList={'b', 'd', 'LL', 'UL'};
end



if F.FunctionOption==101 
 	F.FunctionType='1/(1+  exp(-(x-d)/b)  )'; %1/(1+exp(-a*(x-c)))
%     F.FunctionType='1/(1+  exp(-b*(x-d))  )'; %
        F.ReverseFunction='d-b*log(1 / F.y_value -1)';
        F.ParaList={'b', 'd'};
end




ok_ = ~(isnan(X) | isnan(Y));

ft_ = fittype(F.FunctionType,...
     'dependent',{'y'},'independent',{'x'},...
     'coefficients', F.ParaList);

% Fit this model using new data
[F.cf_, F.goodness]= fit(X(ok_),Y(ok_),ft_,'Startpoint',F.st_);


F.goodness

if F.FunctionOption==1 | F.FunctionOption==2 
	a=F.cf_.a; 
	b=F.cf_.b; 
        c=F.cf_.c;
	d=F.cf_.d; 
end
if F.FunctionOption==3 | F.FunctionOption==4 
	a=F.cf_.a; 
	b=F.cf_.b; 

	d=F.cf_.d; 
end
if F.FunctionOption==5 | F.FunctionOption==6 | F.FunctionOption==7 
	a=F.cf_.a; 
 
        c=F.cf_.c;
	d=F.cf_.d; 
end

if F.FunctionOption==8 | F.FunctionOption==101

	b=F.cf_.b; 

	d=F.cf_.d; 
end

if F.FunctionOption==9 

	b=F.cf_.b; 

	d=F.cf_.d; 

	LL=F.cf_.LL; 

	UL=F.cf_.UL; 
end

F.yfit_part=[];
for i=1:length(X)
x=X(i);
eval(['tmp=' F.FunctionType ';']);
F.yfit_part=[F.yfit_part tmp];
end

F.X_full=linspace(min(X)-(X(2)-X(1))*0.1, max(X), 100);
F.yfit_full=[];
for i=1:length(F.X_full)
x=F.X_full(i);
eval(['tmp=' F.FunctionType ';']);
F.yfit_full=[F.yfit_full tmp];
end

if F.FunctionOption==1 | F.FunctionOption==2 | F.FunctionOption==3 | F.FunctionOption==4 | F.FunctionOption==8 | F.FunctionOption==9
	F.Saturation_x_value= b+d; 
        x=F.Saturation_x_value;
        eval(['F.Saturation_y_value=' F.FunctionType ';']);
end
if F.FunctionOption==5 | F.FunctionOption==6 | F.FunctionOption==7
	y_value_tmp=F.y_value;
        F.Saturation_y_value=1;
	F.y_value=F.Saturation_y_value;
        eval(['F.Saturation_x_value=' F.ReverseFunction ';']);
	F.y_value=y_value_tmp;
end
if  F.FunctionOption==101
	y_value_tmp=F.y_value;
        F.Saturation_y_value=0.25;
	F.y_value=F.Saturation_y_value;
        eval(['F.Saturation_x_value=' F.ReverseFunction ';']);
        X1=F.Saturation_x_value;
	F.y_value=y_value_tmp;

	y_value_tmp=F.y_value;
        F.Saturation_y_value=0.5;
	F.y_value=F.Saturation_y_value;
        eval(['F.Saturation_x_value=' F.ReverseFunction ';']);
	F.y_value=y_value_tmp;

	y_value_tmp=F.y_value;
        F.Saturation_y_value=0.75;
	F.y_value=F.Saturation_y_value;
        eval(['F.Saturation_x_value=' F.ReverseFunction ';']);
        X2=F.Saturation_x_value;
	F.y_value=y_value_tmp;

        F.alpha=d;
        F.beta=1/b;
        F.twoXs=[X1, X2];
        Heading_discriminability_01=abs(F.twoXs(1)-F.twoXs(2))/2; 
        F.discrim=Heading_discriminability_01;
end


eval(['F.x_value=' F.ReverseFunction ';']);


       if F.plotindividualPsycurve==1
           %figure; 
           plot(X, Y, 'o', F.X_full, F.yfit_full, 'g-'); hold on; 
           plot(X, F.yfit_part','r.'); hold off;
       end

