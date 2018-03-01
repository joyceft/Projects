data water;
	input Ip tem prod day ppl W prodlog;
	cards;
0 58.8	7107	21	129	3067 0.97180
0 65.2	6373	22	141	2828 1.04761
0 70.9	6796	22	153	2891 1.00463
0 77.4	9208	20	166	2994 0.71636
1 79.3	14792	25	193	3082 1.52940
1 81.0	14564	23	189	3898 1.48641
1 71.9	11964	20	175	3502 1.33549 
1 63.9	13526	23	186	3060 1.26328
1 54.5	12656	20	190	3211 1.16702
1 39.5	14119	20	187	3286 1.39677
1 44.5	16691	22	195	3542 1.82986
0 43.6	14571	19	206	3125 0.38776
1 56.0	13619	22	198	3022 1.28543
1 64.7	14575	22	192	2922 1.48852
1 73.0	14556	21	191	3950 1.48486
1 78.9	18573	21	200	4488 2.05874
1 79.4	15618	22	200	3295 1.67128
;
*the prodlog is the transformed variable with the prodlog axis changed according to Ip;
data sample;
    set water;
	if prodlog le 1
	    then p2=0;
	if prodlog gt 1
	    then p2=prodlog-1;
run;
proc reg data=sample;
    model W=prodlog p2;
	output out=sample2 p=What;
run;
symbol1 v=circle i=none c=black;
symbol2 v=none i=join c=black;
proc sort data=sample2;by prodlog;
proc gplot data=sample2;
    plot(W What)*prodlog/overlay;
run;


    
