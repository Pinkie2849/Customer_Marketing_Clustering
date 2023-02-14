/* Generated Code (Market_Analysis) */
/* Source File: market.csv */
/* Source Path: /home/u63109530 */
/* Code generated on: 13/02/2023 08:41 */

%web_drop_table(WORK.Market_Analysis);


FILENAME REFFILE '/home/u63109530/market.csv';

PROC IMPORT DATAFILE=REFFILE
	DBMS=CSV
	OUT=WORK.Market_Analysis;
	GETNAMES=YES;
RUN;

PROC CONTENTS DATA=WORK.Market_Analysis; RUN;


%web_open_table(WORK.Market_Analysis);


PROC MEANS data=Market_Analysis;
RUN;

/* Analysis */
PROC SGPLOT data=Market_Analysis;
  VBAR Gender / response=Age GROUP=Gender STAT=MEAN;
RUN;

PROC SGPLOT data=Market_Analysis;
  VBAR Gender / response='Spending Score (1-100)'n GROUP=Gender STAT=MEAN;
RUN;

PROC SGPLOT data=Market_Analysis;
  VBAR Gender / response='Annual Income (k$) 'n GROUP=Gender STAT=MEAN;
RUN;

 ods graphics / reset width=10 in height=5 in imagemap;
PROC SGPLOT data=Market_Analysis;
  VBAR Age / response='Spending Score (1-100)'n GROUP=Age STAT=MEAN;
RUN;
ods graphics / reset;

 ods graphics / reset width=10 in height=5 in imagemap;
PROC SGPLOT data=Market_Analysis;
  VBAR Age / response='Annual Income (k$) 'n GROUP=Age STAT=MEAN;
RUN;
ods graphics / reset;

/*Use PCA to reduce the variables to 2*/
proc princomp data=Market_Analysis out=pca_results;
  var Age 'Annual Income (k$) 'n 'Spending Score (1-100)'n;
run;

 /*2D visualization */
 proc sgplot data=pca_results;
  scatter x=Age y='Annual Income (k$) 'n;

proc sgplot data=pca_results;
  scatter x='Annual Income (k$) 'n y='Spending Score (1-100)'n;
  
 proc sgplot data=pca_results;
  scatter x=Age y='Spending Score (1-100)'n; 
  
/*Finding the optimum number of clusters using KMeans and also on a plot using the elbow method */
ods graphics / reset;

proc means data=work.market_analysis N Nmiss mean median max min;
run;

ods graphics on;
proc cluster data = work.market_analysis method = centroid ccc print=15 outtree=Tree;
var 'Annual Income (k$)'n'Spending Score (1-100)'n;
run;
ods graphics off;

proc tree noprint ncl=4 out=out;
copy 'Annual Income (k$)'n'Spending Score (1-100)'n;
run;

proc candisc out = can;
class cluster;
var 'Annual Income (k$)'n 'Spending Score (1-100)'n;
run;
proc sgplot data = can;
title "Cluster Analysis for Marketing Segmentation";
scatter y = can2 x = can1 / group = cluster;
run;









   
   





