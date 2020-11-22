%% c_Curve_fitting_01




F.SaturationPoint_choice_for_FFinal = 2; 	% 1: (x-d)/b=1;  2: F.FunctionType=F.y_value, such as =0.9;

% 1: A saturation curve, '(a*(x-d))/(b+x-d)+c'; 2: A soft saturation curve, 'a*(1-exp(-(x-d)/b))+c';
if F.FunctionOption==1 | F.FunctionOption==2     F.st_ = [1 1000  Y(1) X(1)]; end	% for 1, 2
if F.FunctionOption==3 | F.FunctionOption==4     F.st_ = [1 1000   X(1)]; end	% for 3, 4
if F.FunctionOption==5			     F.st_ = [1/1000  Y(1) X(1)]; end	% for 5
if F.FunctionOption==6			     F.st_ = [(1-Y(1))/(log(1000)-log(X(1))) Y(1) log(X(1))]; end % for 6
if F.FunctionOption==7			     F.st_ = [(2-Y(1))/10^((log(1000)-log(X(1)))) Y(1) log(X(1))]; end % for 7
if F.FunctionOption==8                       F.st_ = [100  1050]; end 	% for 8
if F.FunctionOption==9                       F.st_ = [100  1050 min(Y) max(Y)]; end	% for 9

%% Y(m) should < 1 & m should < n ( most safely, m should be 1, e.g. when if X(m)>X(n) then Y(m)>.5 )
if F.FunctionOption==101 n=round(length(X)/2); m=1; d1=X(n);  s1=1;
    if Y(m)==1 s1=-1; end
    F.st_ = [ (d1-X(m))/log(1/(Y(m)+s1*0.001)-1) d1 ];
end	% for 101


[F ] = F_Curve_Fitting_01(X, Y, F); %F_Curve_Fitting_01为独立的.m文件，存储了多个函数F

if F.FunctionOption==5
    F.Final_x_value=F.Saturation_x_value; F.Final_y_value=F.Saturation_y_value;
end

if (F.FunctionOption==4 | F.FunctionOption==8 | F.FunctionOption==9)...
        & F.SaturationPoint_choice_for_FFinal==1
    F.Final_x_value=F.Saturation_x_value; F.Final_y_value=F.Saturation_y_value;
end
if (F.FunctionOption==4 | F.FunctionOption==8 | F.FunctionOption==9)...
        & F.SaturationPoint_choice_for_FFinal==2
    F.Final_x_value=F.x_value; F.Final_y_value=F.y_value;
end