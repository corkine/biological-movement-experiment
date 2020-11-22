% F_sigmond_curve_fitting
function [alpha, beta, discrim, DEV, STATS] = F_sigmond_curve_fitting(x,y,n, Ad)


%{
       x = [2100 2300 2500 2700 2900 3100 3300 3500 3700 3900 4100 4300]';
       n = [48 42 31 34 31 21 23 23 21 16 17 21]';
       y = [1 2 0 3 8 8 14 17 19 15 17 21]';

y is frequency of observed event (event 0 or event 1, binominal distributed variable), 
n is total observation numbers (sample sizes). In our cases, proportion and probability of 1 are the same. 
The Y-axis is P, which indicates the proportion / probability of 1s at any given value of height.   
b adjusts how quickly the probability changes with changing X a single unit. 

glmfit in Matlab uses a MLE (Maximum Likelihood Estimation, also some iterative(µü´ú) fitting procedure is used)
method to perform the logistic regression. 
So there is no concept of R-square / sum-of-squared values in glmfit as in CFT (which uses least-squares based approach).

The "DEV" output from glmfit is the deviance, and it can be used to compare models or test whether a larger model fits
significantly better than a smaller one. 

Deviance. With logistic regression, instead of R2 as the statistic for overall fit of the model, 
we have deviance instead. 
Remember, when we studied chi-square analyses, 
chi-square was said to be a measure of "goodness of fit" ofthe observed and the expected values. 
We use chi-square as a measure of model fit here in a similar way. 
It is the fit of the observed values (Y) to the expected values (Y). 
The bigger the difference (or "deviance") of the observed values from the expected values, 
the poorer the fit of the model. So, we want a small deviance if possible. 
As we add more variables to the equation the deviance should get smaller, indicating an improvement in fit. Y

CFT (Curve Fitting Toolbox) in Matlab uses (linear or nonlinear) least-squares method to do the curve fitting.
'NonlinearLeastSquares' (with the option of 'Startpoint') or 'LinearLeastSquares',

Linear regression treats all of the proportions equally, even if they are based on much different sample sizes  
[seems we don't have this issue in our constant stimuli method].
If 6 out of 10 Komodo dragon eggs raised at 30 C were female, and 15 out of 30 eggs raised at 32 C were female, 
the 60% female at 30 C and 50% at 32 C would get equal weight in a linear regression, which is inappropriate. 
Logistic regression analyzes each observation (in this example, the sex of each Komodo dragon) separately, 
so the 30 dragons at 32 C would have 3 times the weight of the 10 dragons at 30 C.

You can't make sensible statistical inferences from a least-squares fit. 
A proper statistical approach (i.e., using maximum likelihood as in logistic regression) 
would enable you to to answer questions like how many parameters are necessary for an adequate description of the data. 

Trueutwein and Strasberger (1999) suggest that maximum likelihood is better for fitting psychometric function data. 
Has anyone found results from a maximum likelihood fit better than a least squares fit? 

Chapter and verse on how to fit PFs with maximum likelihoods can be found in Treutwin & Strasburger, 
"Fitting the psychometric function",Perception and Psychophysics, 1999 (61(1) 87-106.

One other difference between Ordinary Least Squares (OLS) and logistic regression is that 
there is no R2 to gauge the variance accounted for in the overall model (at least not one that has been agreed upon by statisticians). 
Instead, a chi-square test is used to indicate how well the logistic regression model fits the data. 

Maximum Likelihood. Instead of finding the best fitting line by minimizing the squared residuals, as we did with OLS regression, 
we use a different approach with logistic¡ª Maximum Likelihood (ML). 
ML is a way of finding the smallest possible deviance between the observed and predicted values (kind of like finding the best fitting line) 
using calculus (derivatives specifically). With ML, the computer uses different "iterations" in which it tries different solutions until 
it gets the smallest possible deviance or best fit. Once it has found the best solution, it provides a final value for the deviance, 
which is usually referred to as "negative two log likelihood" (shown as "-2 Log Likelihood" in SPSS). 
The deviance statistic is called ¨C2LL by Cohen et al. (2003) and Pedazur and D by some other authors (e.g., Hosmer and Lemeshow, 1989), 
and it can be thought of as a chi-square value. 

The slope (b) and intercept (a) of the best-fitting equation in a logistic regression are found using the maximum-likelihood method, 
rather than the least-squares method used for linear regression. 
Maximum likelihood is a computer-intensive technique; the basic idea is that it finds the values of the parameters under 
which you would be most likely to get the observed results.
There are several different ways of estimating the P-value. The Wald chi-square is fairly popular, 
but it may yield inaccurate results with small sample sizes. The likelihood ratio method may be better. 
It uses the difference between the probability of obtaining the observed results under the logistic model 
and the probability of obtaining the observed results in a model with no relationship between the independent and dependent variables. 
I recommend you use the likelihood-ratio method; be sure to specify which method you've used when you report your results.

There is a lot of output from PROC LOGISTIC that you don't need. The program gives you three different P-values; 
the likelihood ratio P-value is the most commonly used.



Loss (ËðºÄ;ËðÊ§) Function
A loss function is a measure of fit between a mathematical model of data and the actual data. 
We choose the parameters of our model to minimize the badness-of-fit or to maximize the goodness-of-fit of the model to the data. 
With least squares (the only loss function we have used thus far), we minimize SSres, the sum of squares residual. 
This also happens to maximize SSreg, the sum of squares due to regression. With linear or curvilinear models, 
there is a mathematical solution to the problem that will minimize the sum of squares.

With some models, like the logistic curve, there is no mathematical solution that will produce least squares estimates of the parameters. 
For many of these models, the loss function chosen is called maximum likelihood. 

Conditional probability (conditional probability of the data given parameter estimates):
A likelihood is a conditional probability (e.g., P(Y|X), the probability of Y given X). 
We can pick the parameters of the model (a and b of the logistic curve) at random or by trial-and-error and then compute the likelihood of 
the data given those parameters (actually, we do better than trail-and-error, but not perfectly). 
We will choose as our parameters, those that result in the greatest likelihood computed. 
The estimates are called maximum likelihood because the parameters are chosen to maximize the likelihood 
(conditional probability of the data given parameter estimates) of the sample data. 
The techniques actually employed to find the maximum likelihood estimates fall under the general label numerical analysis. 
There are several methods of numerical analysis, but they all follow a similar series of steps. 
First, the computer picks some initial estimates of the parameters. 
Then it will compute the likelihood of the data given these parameter estimates. 
Then it will improve the parameter estimates slightly and recalculate the likelihood of the data. 
It will do this forever until we tell it to stop, which we usually do when the parameter estimates do not change much 
(usually a change .01 or .001 is small enough to tell the computer to stop). 
[Sometimes we tell the computer to stop after a certain number of tries or iterations, e.g., 20 or 250. 
This usually indicates a problem in estimation.]

In logistic regression, the dependent variable is a logit [ ln(p/(1-p)) ], which is the natural log of the odds [ p/(1-p),   
Let's say that the probability of being male at a given height is .90, the oddsof being male would be .90/.10 or 9 to one], 
So a logit is a log of odds and odds are a function of p, the probability of a 1. 

logit(p) = a + bX,
Which is assumed to be linear, that is, the log odds (logit) is assumed to be linearly related to X, our IV. 
So there's an ordinary regression hidden in there. We could in theory do ordinary regression with logits as our DV, but of course, 
we don't have logits in there, we have 1s and 0s. Then, too, people have a hard time understanding logits. We could talk about odds instead. 
Of course, people like to talk about probabilities more than odds.
If log odds are linearly related to X, then the relation between X and p is nonlinear, and has the form of the S-shaped curve .
 -2LogL & likelihood ratio test
The computer calculates the likelihood of the data. Because there are equal numbers of people in the two groups, 
the probability of group membership initially (without considering anger treatment) is .50 for each person. 
Because the people are independent, the probability of the entire set of people is .5020, a very small number. 
Because the number is so small, it is customary to first take the natural log of the probability and then multiply the result by -2. 
The latter step makes the result positive. The statistic -2LogL (minus 2 times the log of the likelihood) is a badness-of-fit indicator, 
that is, large numbers mean poor fit of the model to the data. SAS prints the result as -2 LOG L. 
For the initial model (intercept only), our result is the value 27.726. This is a baseline number indicating model fit. 
This number has no direct analog in linear regression. It is roughly analogous to generating some random numbers and finding R2 for these numbers 
as a baseline measure of fit in ordinary linear regression. By including a term for treatment, the loss function reduces to 25.878, 
a difference of 1.848, shown in the chi-square column. The difference between the two values of -2LogL is known as the likelihood ratio test. 
When taken from large samples, the difference between two values of -2LogL is distributed as chi-square. 
This says that the (-2Log L) for a restricted (smaller) model - (-2LogL) for a full (larger) model is the same as the log of the ratio of 
two likelihoods, which is distributed as chi-square. The chi-square is used to statistically test whether including a variable reduces 
badness-of-fit measure. This is analogous to producing an increment in R-square in hierarchical regression. 
If chi-square is significant, the variable is considered to be a significant predictor in the equation, 
analogous to the significance of the b weight in simultaneous regression. 
The value of b given for Anger Treatment is 1.2528. the chi-square associated with this b is not significant, just as the chi-square for 
covariates was not significant. Therefore we cannot reject the hypothesis that b is zero in the population. 


Simple logistic regression [when you have one nominal variable with two values (male/female, dead/alive, etc.) and one measurement variable] 
is analogous to linear regression, except that the dependent variable is nominal, not a measurement. 
One goal is to see whether the probability of getting a particular value of the nominal variable is associated with the measurement variable; 
the other goal is to predict the probability of getting a particular value of the nominal variable, given the measurement variable.

What makes logistic regression different from linear regression is that the Y variable is not directly measured; 
it is instead the probability of obtaining a particular value of a nominal variable. 
If you were studying people who had heart attacks, the values of the nominal variable would be 
"did have a heart attack" vs. "didn't have a heart attack." 
The Y variable used in logistic regression would then be the probability of having a heart attack. 


%}




       discrim=NaN;

       [b, DEV, STATS]= glmfit(x, [y n], 'binomial', Ad.Link_Function_Name);
       yfit = glmval(b, x, Ad.Link_Function_Name); 
       alpha = interp1(yfit,x,0.5,'spline')
       alpha1=alpha;

       yfit_full=[];
       x_full=linspace(min(x), max(x),100);
       if strcmp(Ad.Link_Function_Name, 'logit')
         Input=b(1) +x * (b(2));
         Output = 1 ./ (1 + exp(-Input));

         Input_full=b(1) +x_full * (b(2));
         yfit_full= 1 ./ (1 + exp(-Input_full)); 

         beta=b(2);
         alpha=-b(1)/b(2)
         twoXs=alpha-(1/beta)*log(1./[0.25 0.75]-1);
         Heading_discriminability_01=abs(twoXs(1)-twoXs(2))/2; discrim=Heading_discriminability_01;
       end

       if strcmp(Ad.Link_Function_Name, 'probit')
         beta=NaN;
       end

       if Ad.plotindividualPsycurve==1
           figure; 
           plot(x, y./n, 'o', x_full, yfit_full, 'g-'); hold on; %plot(alpha1,0.5, 'ro'); plot(alpha,0.5, 'ko')
           if strcmp(Ad.Link_Function_Name, 'logit')
           	plot(x, Output,'r.'); 
        hold on;
           end
       end