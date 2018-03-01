data project;
    input It Id Ip person temp day prod water;
	cards;
0 1 0 141 65.2 22	6373  2828
1 1 0 153 70.9 22	6796  2891
0 1 1 192 64.7 22   14575 2922
1 0 0 166 77.4 20	9208  2994
0 1 1 198 56   22	13619 3022
0 1 1 186 63.9 23	13526 3060
0 1 0 129 58.8 21	7107  3067
1 1 1 193 79.3 25	14792 3082
0 0 0 206 43.6 19	14571 3125
0 1 1 190 54.5 20	12656 3211
0 1 1 187 39.5 20	14119 3286
1 1 1 200 79.4 22	15618 3295
1 1 1 175 71.9 20	11964 3502
0 1 1 195 44.5 22	16691 3542
1 1 1 189 81   23	14564 3898
1 1 1 191 73   21	14556 3950
1 1 1 200 78.9 21	18573 4488
;
*Piecewise of temp;
data piecewise;
set project;
logwater=log(water);
prodip=prod*ip;
run;

proc reg data=piecewise;
model logwater = day temp prodip person/selection=cp b;
run;

proc gplot data=piecewise;
plot water*(temp2 temp3);
run;


proc sort data=piecewise;
by temp;
symbol1 v=circle i=sm70;
proc gplot data=piecewise;
plot water*temp;

*standardize prod to N(0,1);
proc standard data=project out=stdprod mean=0 std=1;
    var prod;
run;
title"standardize prod to std normal";
proc print data=stdprod;
run;
*trans stdprod to exp/log;
data transprod;
    set stdprod;
	prodexp=exp(prod)*Ip;
	prodlog=log(abs(prod)+1)*Ip;
run;
proc print data=transprod;
run;
*plot stdprod vs water;
title"plot transprod vs water";
axis1 label=(angle=90'water');
axis2 label=('prodexp');
axis3 label=('prodlog');
proc sort data=transprod; by prod;
proc gplot data=transprod;
    plot water*prodexp/vaxis=axis1 haxis=axis2;
	plot water*prodlog/vaxis=axis1 haxis=axis3;
run;
*regression of all transformed Xi;
data projectnew;
    set transprod;
	temp2=(temp-70)**2;
run;
proc print data=projectnew;
run;
title"Variable selection via Cp criterion";
proc reg data=projectnew;
    model water=day temp temp2 prodlog person/
    selection= cp b;
run;
title"Model selection via stepwise";
proc reg data=projectnew;
    model water=day temp temp2 prodlog person/
	selection=stepwise;
run;
*Check assumptions:residuals";
proc reg data=projectnew;
    model water=day temp prodlog;
	output out=acheck r=resid;
run;
symbol1 v=circle i=r1;
*Check residuals vs sequence";
title 'residuals vs Sequence plot'
symbol1 v=circle i=sm70;
proc gplot data=acheck;
plot resid*seq;
run;

*Check assumptions: residuals vs variables";
title"residuals vs X";
proc gplot data=acheck;
    plot resid*day/vref=0;
	plot resid*temp/vref=0;
	plot resid*prodlog/vref=0;
run;
*Check normality assumptions: residuals";
proc univariate data=acheck plot normal;
    var resid;
    histogram resid/normal kernel(L=2);
Run;
proc univariate data=acheck plot normal;
    var resid;
    qqplot resid/normal(L=1 mu=est sigma=est);
run;
*Check assumptions: outliers of residuals";
*Regression diagostic;
title"Check types of residuals";
proc reg data=acheck;
    model water=day temp prodlog/
    r influence;
run;
*check multicollinearity;
*VIF;
title"Measure of multicollinearity";
proc reg data=acheck;
    model water=day temp prodlog/tol vif;
run;
title"90% CI for the mean of response";
proc reg data=acheck;
    model water=day temp prodlog/clm alpha=0.1;
run;
title"90% CI for regression coefficients";
proc reg data=acheck;
    model water=day temp prodlog/clb alpha=0.1;
run;
title"90% PI of individual observations";
proc reg data=acheck;
    model water=day temp prodlog/cli alpha=0.1;
run;
* check residuals vs temp;
data checkt;
    set acheck;
    absr=abs(resid);
    sqrr=resid*resid;
run;
title"transresidual vs temp";
proc gplot data=checkt;
    plot(resid absr sqrr)*temp;
run;
proc reg data=checkt;
    model absr=temp;
	output out=ct p=shat;
run;
data findtemp;
    set ct;
	wt=1/(shat*shat);
run;
proc reg data=ct;
    model water=temp/clb p;
    weight wt;
    output out=weighted p=predict;
run;
