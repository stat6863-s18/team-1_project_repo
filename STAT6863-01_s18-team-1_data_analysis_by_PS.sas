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
*
Question: Does offense rebounds more important to teams than defense rebounds 
in 2015?

Rationale: Defense has always been known to win chamionships but modern day NBA 
focuses more on offense than defense.

Note: This question will see how wins are won by comparing points, assists 
offensive rebounds as offense, defensive rebounds, steals, and blocks as 
defense. team_box_score and player_stats

Limitations: Dataset 1 (player_stats) is on player level data for 2014-2015
season, whereas dataset 2 (team_box_score) is on a team level data for 
2016-2017 season. I will need to focus on the team level in order to answer 
my research question. There is no way to join between the two tables. 
If there was a way, both datasets are in two different seasons which would 
need to be stated in order to answer my research question.
;

proc sql outobs=10;
    select
	     player
		,year
		,AVG(DREB) as avg_player_DREB
		,AVG(REB) as avg_player_REB
	from 
	    masterfile
	group by
         1
		,2
	having MIN >= 2000
	order by 
        MIN desc
	;
quit;

proc rank
        groups=4
		data=masterfile
		out=masterfile_rank1
    ;
    var REB DREB;
	ranks REB_rank DREB_rank;
run;
proc freq data=masterfile_rank1;
	table
		REB_rank
		DREB_rank
	;
	where
		year = '2015'
	;
run;
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
*
Question: Which position is the most important for higher points made in 2014?

Rationale: NBA teams have built their teams around centers, guards, or forwards.
But which position provided the most help in winning a championship.

Note: This question will look at shots made, total rebounds, and total
assists and how it has contributed to championship wins. team_box_score and
player_stats

Limitations: Since dataset 1 and dataset 2 cannot be joined without additional
information (i.e. team each player was on during the 2014-2015 season). Another
limitation to note is the different seasons each dataset refers to, 2014-2015 
and 2015-2016, respectively.
;


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

proc rank
        groups=4
		data=masterfile
		out=masterfile_rank2
    ;
    var FG_PCT;
	ranks FG_PCT_rank;
run;
proc freq data=masterfile_rank2;
	table
		FG_PCT_rank
	;
	where
		year = '2014'
	;
run;
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
*
Question: Is wingspan an effective measurement of a higher points made in 2015? 

Rationale: Sam Hinkie, previous GM of the Philadelphia 76ers, looked at 
physical and athletic traits in order to predict a "superstar" player. One of 
those traits was wingspan.

Note: This question will look at average double digit scorer in the NBA and 
compare their wingspan. player_stats and player_anthro

Limitations: Dataset 3 (player_anthro) only contains data on rookie NBA players
who participated in the NBA combine. Using dataset 3, I will be able to see
only rookie players who participated in the combine for 2014-2015.
;

proc sql outobs=10;
    select
		 year
		,player
        ,AVG(FG_PCT) as avg_player_pts      /* Average player points */ 
	    ,AVG(wingspan) as avg_player_ws  /* Average wingspan */
    from
        masterfile
    ;
quit;


proc rank
        groups=4
		data=masterfile
		out=masterfile_rank3
    ;
    var FG_PCT wingspan;
	ranks FG_PCT_rank ws_rank;
run;
proc freq data=masterfile_rank3;
	table
		FG_PCT_rank
		ws_rank
	;
	where
		year = '2015'
	;
run;
proc means min q1 median q3 max data=masterfile_rank3;
	class FG_PCT_rank ws_rank;
	var FG_PCT wingspan;
	where year = '2015';
run;
