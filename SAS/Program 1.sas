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

/* Create a table that contains the cluster labels */
proc sql;
  create table can_clusters as
  select cluster, case(cluster)
    when 1 then "Cluster 1"
    when 2 then "Cluster 2"
    when 3 then "Cluster 3"
    when 4 then "Cluster 4"
    end as cluster_label
  from can;
quit;

/* Join the cluster labels to the original data set and use the new variable in the SCATTER statement */
proc sql;
  create table can_labeled as
  select can.*, clusters.cluster_label
  from can left join can_clusters as clusters
  on can.cluster = clusters.cluster;
quit;

proc sgplot data=can_labeled;
  title "Cluster Analysis for Marketing Segmentation";
  scatter y='Annual Income (k$)'n x=Age / group=cluster_label;
run;


 /*2D visualization */
 proc sgplot data = can;
  title "Cluster Analysis for Marketing Segmentation";
scatter y = 'Spending Score (1-100)'n x = 'Annual Income (k$)'n / group = cluster;
run;

 proc sgplot data = can;
  title "Cluster Analysis for Marketing Segmentation";
scatter y = 'Spending Score (1-100)'n x = Age  / group = cluster;
run;

 proc sgplot data = can;
  title "Cluster Analysis for Marketing Segmentation";
scatter y = 'Annual Income (k$)'n x = Age / group = cluster;
run; 
  
/*Finding the optimum number of clusters using KMeans and also on a plot using the elbow method */
ods graphics / reset;

proc means data=work.market_analysis N Nmiss mean median max min;
run;

ods graphics on;
proc cluster data = work.market_analysis method = centroid ccc print=15 outtree=Tree;
var Age 'Annual Income (k$)'n'Spending Score (1-100)'n;
run;
ods graphics off;

proc tree noprint ncl=4 out=out;
copy Age 'Annual Income (k$)'n'Spending Score (1-100)'n;
run;

proc candisc out = can;
class cluster;
var Age 'Annual Income (k$)'n 'Spending Score (1-100)'n;
run;











   
   





