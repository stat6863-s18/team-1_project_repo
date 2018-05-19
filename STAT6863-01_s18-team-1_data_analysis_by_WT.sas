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
Question: Is height telling of defensive success for a player?

Rationale: Centers are usually "rim protectors" but lately a lot of teams have
been implementing smaller line ups recently.

Note: This compares the column "Height w/ Shoes" from Player Anthro Data
to the columns "DREB", "STL", and "Blocks" from player_stats.

Limitations: For our nba_combine_anthro dataset and our players_stats we have a
name ID, but it is possible that some players share the same name. Therefore we
must use additional ID variables such as position, and be careful that a player
is not being incorrectly attributed certain statistics.
;

proc sql;
	select
	         HEIGHT_SHOES
                ,avg(DREB) as AvgDREB
                ,avg(STL) as AvgSTL
                ,avg(BLK) as AvgBLK
        from
                masterfile
        group by Round(HEIGHT_SHOES,1)
        order by Round(HEIGHT_SHOES,1)
        ;
quit;

*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;

*
Question: Which kind of guard scores more 3 pointers, SG or PG?

Rationale: A point guard holds the ball more as he is the "quarterback of the
team, but does that mean he also scores more?

Note: This compares the column "3PM" and "POS" from masterfile.

Limitations: Our player_stats dataset has the name of all players in a single
column. team_box_score has names in multiple columns, for example First name is
in a column and Last Name is in a seperate column. We must figure out whether
Middle names might affect our ID variable. It seems like player_stats only uses
first and last name, but team_box_score uses multiple.
;
proc sql;
	select
		POS
		,avg(_3PM)
  	from 
  		masterfile
  	group by 
  		POS;
quit;

*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;

*
Question: Did players attempt more 3 pointers in the 15-16 season than they did
in the 14-15 season?

Rationale: There has been a trend of coaches implementing "small" line ups which
include more 3 point shooters. The logical conclusion would then be that the
number of 3 point attempts has also gone up year to year.

Note: This would compare the columns "3PA" from Player Stats 14-15 and the
columns "3PA" from Player Stats 14-15.

Limitations: We only have 2 data points. In order to make a broader conclusion,
more years of data would have to be added in to make a conclusion with more
certainty.
;
proc sql;
  	(select 
  		year
  		,avg(_3PA)
  	from 
  		masterfile
  	where 
  		year="2014")
	union
  	(select
  		year
  		,avg(_3PA)
  	from 
  		masterfile
  	where 
  		year="2015")
  ;
quit;

*The results show that there are in fact more attempts in the 15-16 season
than there are in the 14-15 season, confirming our theory that 3 pointers
attempted are indeed increasing. 
