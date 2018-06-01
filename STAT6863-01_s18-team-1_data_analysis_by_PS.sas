*******************************************************************************;
**************** 80-character banner for column width reference ***************;
* (set window width to banner width to calibrate line length to 80 characters *;
*******************************************************************************;

* set relative file import path to current directory (using standard SAS trick);
X "cd ""%substr(%sysget(SAS_EXECFILEPATH),1,%eval(%length(%sysget(SAS_EXECFILEPATH))-%length(%sysget(SAS_EXECFILENAME))))""";


* load external file that will generate final analytic file;
%include '.\STAT6863-01_s18-team-1_project_data_preparation';


*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;

* clear titles/footnotes;
title;
footnote;

title1 justify=left
"Research Question: Are offense rebounds more important to teams than defense rebounds in 2015?"
;

title2 justify=left
"Rationale: Defense has always been known to win chamionships but modern day NBA focuses more on offense than defense."
;

footnote1 justify=left
"On average, in 2015, offensive rebounds are greater than defensive rebounds. The average offensive rebounds per game range from 0 to 14.8 in 2015 and the average defensive rebounds per game range from 0 to 10.3 in 2015."
;

footnote2 justify=left
"We can see the greatest variability in the top 2nd quartile of offensive rebounds."
;

footnote3 justify=left
"Based on the rank chart, we can see that players in the highest offensive rebound quartile have higher number of defensive rebounds. Thus, ranking offensive rebound more important than defensive rebounds."
;

*
Note: This question will see how wins are won by comparing points, assists 
offensive rebounds as offense, defensive rebounds, steals, and blocks as 
defense. team_box_score and player_stats

Limitations: Dataset 1 (player_stats) is on player level data for 2014-2015
season, whereas dataset 2 (team_box_score) is on a team level data for 
2016-2017 season. I will need to focus on the team level in order to answer 
my research question. There is no way to join between the two tables. 
If there was a way, both datasets are in two different seasons which would 
need to be stated in order to answer my research question.

Methodology: Use proc report to show the first ten observations of the 
data. Then create quartiles using proc rank and see the frequency using
proc freq. Finally use proc means to see the averages in offensive and
defensive rebounds.

Followup Steps: Clean missing data values for find additional data to 
fill missing values. Possibly add more years to the data.
;

* output first ten rows of data to examine research question;
proc report data=masterfile (obs=10);
	columns
		player
		year
		DREB
		REB
	;
run;

* create quartiles for offensive and defensive rebounds in 2015;
proc rank
        groups=4
		data=masterfile
		out=masterfile_rank1
    ;
    var REB DREB;
	ranks REB_rank DREB_rank;
run;

* examine rebound quartiles;
proc freq data=masterfile_rank1;
	table
		REB_rank
		DREB_rank
	;
	where
		year = '2015'
	;
run;

* examine rebound descriptive statistics;
proc means min q1 median q3 max data=masterfile_rank1;
	class REB_rank DREB_rank;
	var REB DREB;
	where 
		year = '2015'
	;
run;

*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;

* clear titles/footnotes;
title;
footnote;

title1 justify=left
"Research Question: Which position is the most important for higher points made in 2014?"
;

title2 justify=left
"Rationale: NBA teams have built their teams around centers, guards, or forwards. But which position provided the most help in winning a championship."
;

footnote1 justify=left
"On average in 2014, positions center (C), power forward (PF), and it's different combinations, have the highest average points per game percentage."
;

footnote2 justify=left
"In addition, we can see the point guard (PG) and shooting guard (SG) having the 3rd and 4th highest average points per game percentage."
;

footnote3 justify=left
"Based on comparing the means of different positions, we can see that the C and PF positions are more important compare to the PG and SG positions."
;

*
Note: This question will look at shots made, total rebounds, and total
assists and how it has contributed to championship wins. team_box_score and
player_stats

Limitations: Since dataset 1 and dataset 2 cannot be joined without additional
information (i.e. team each player was on during the 2014-2015 season). Another
limitation to note is the different seasons each dataset refers to, 2014-2015 
and 2015-2016, respectively.

Methodology: Use proc sql to check the first ten observations in the data.
Create quartiles using proc rank and proc freq to see the frequency of FG 
percentage. Then use proc means to use as a benchmark when comparing the FG
percentage by position.

Followup Steps: Clean the position data to show only one position instead of
combinations.
;

* output first ten rows addressing research question;
proc sql outobs=10;
    select
	     player
		,year
		,pos
		,AVG(FG_PCT) as avg_player_FG
	from 
	    masterfile
	group by
         1
		,2
		,3
	;
quit;

* create quartiles for FG percentage;
proc rank
        groups=4
		data=masterfile
		out=masterfile_rank2
    ;
    var FG_PCT;
	ranks FG_PCT_rank;
run;

* examine frequency for FG percentage quartiles in 2014;
proc freq data=masterfile_rank2;
	table
		FG_PCT_rank
	;
	where
		year = '2014'
	;
run;

* examine FG percentage descriptive statistics;
proc means min q1 median q3 max data=masterfile_rank2;
	class pos FG_PCT_rank;
	var FG_PCT;
	where 
		year = '2014'
	and
		pos is not null
	;
run;

*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;

* clear titles/footnotes;
title;
footnote;

title1 justify=left
"Research Question: Is wingspan an effective measurement of higher points made between 2014 and 2015?"
;

title2 justify=left
"Rationale: Sam Hinkie, previous GM of the Philadelphia 76ers, looked at physical and athletic traits in order to predict a superstar player. One of those traits was wingspan."
;

*
Note: This question will look at average double digit scorer in the NBA and 
compare their wingspan. player_stats and player_anthro

Limitations: Dataset 3 (player_anthro) only contains data on rookie NBA players
who participated in the NBA combine. Using dataset 3, I will be able to see
only rookie players who participated in the combine for 2014-2015.

Methodology: Use proc corr to examine the correlation between FG percentage
and wingspan. Then create a scatterplot to get a visual relationship between
the two variables.

Followup Steps: Carefully clean missing values in order to ensure valid 
results. Possibly add more years to the data to get a stronger result.
;

title3 justify=left
"Correlation analysis for FG_PCT and WINGSPAN"
;

footnote1 justify=left
"The correlation table shows a negative correlation between FG_PCT and WINGSPAN."
;

footnote2 justify=left
"Even though the negative correlation is low, it is still statistically significant with a p-value of 0.0026, and a relationship strength of -16.887%, on a scale of -100% to +100%."
;

footnote3 justify=left
"We can see that WINGSPAN is not an effective measurement of FG_PCT. Reasons explaining the negative relationship could be that players with larger WINGSPAN play certain positions like SF instead of C or PF."
;

* examine the correlation between FG percentage and wingspan;
proc corr data=masterfile;
    var
        FG_PCT
        wingspan
    ;
    where
        not(missing(FG_PCT))
        and
        not(missing(wingspan))
    ;
run;

* clear titles/footnotes;
title;
footnote;

title1
"Plot illustrating the negative correlation between FG_PCT and WINGSPAN"
;

footnote1
"The scatterplot shows a slight decrease in FG_PCT as WINGSPAN increases."
;

* create scatterplot with FG percentage vs wingspan;
proc sgplot data=masterfile;
    scatter
        x=FG_PCT
        y=wingspan
    ;
run;

* clear titles/footnotes;
title;
footnote;
