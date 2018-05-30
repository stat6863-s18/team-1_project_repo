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

title1 justify=left
'Question: Is height telling of defensive success for a player?';

title2 justify=left
'Rationale: Centers are usually "rim protectors" but lately a lot of teams have been implementing smaller line ups.';

footnote1 justify=left
"As we can see the taller a player is in inches, the more rebounds and blocks he can get."
;
footnote2 justify=left
"Steals on the other hand can range for all different heights."
;

footnote3 justify=left
"Because taller players can get more rebounds and blocks, we can check if there is a correlation between those 2 variables. With an R of .69 we can say that there is a strong correlation between Blocks and Defensive Rebounds."
;

*
Note: This compares the column "Height w/ Shoes" from Player Anthro Data
to the columns "DREB", "STL", and "Blocks" from player_stats.

Limitations: For our nba_combine_anthro dataset and our players_stats we have a
name ID, but it is possible that some players share the same name. Therefore we
must use additional ID variables such as position, and be careful that a player
is not being incorrectly attributed certain statistics.
;

proc sql;
	select distinct
	         HEIGHT_SHOES
                ,avg(DREB) as AvgDREB
                ,avg(STL) as AvgSTL
                ,avg(BLK) as AvgBLK
        from
                masterfile
        group by Round(HEIGHT_SHOES,10)
        order by Round(HEIGHT_SHOES,10)
        ;
quit;

proc corr data=work.masterfile;
    var
        BLK
        DREB
    ;
    where
        not(missing(BLK))
        and
        not(missing(DREB))
    ;
run;

*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;


title1 justify=left
'Question: Which kind of guard scores more 3 pointers, SG or PG?';

title2 justify=left
'Rationale: A point guard holds the ball more as he is the "quarterback of the team, but does that mean he also scores more?';

footnote1 justify=left
"Between pure Point Guard (PG) and Shooting Guard (SG) positions, Point Guards score more 3 pointers on average."
;

footnote2 justify=left
"When you get hybrid players that play multiple positions, this conclusion changes. There are players who can play multiple positions and score plenty of 3 pointers."
;

*
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
		,avg(_3PM) as _3PM
  	from 
  		masterfile
  	where 
  		POS='SG' OR POS='PG'
  	group by 
  		POS
  	order by
  		_3PM;
quit;

proc sgplot data=work.masterfile;
  vbar POS/ response=_3PM stat=mean;
run;

*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;
title1 justify=left
'Question: Did players attempt more 3 pointers in the 15-16 season than they did in the 14-15 season?';

title2 justify=left
'Rationale: There has been a trend of coaches implementing "small" line ups which include more 3 point shooters. The logical conclusion would then be that the number of 3 point attempts has also gone up year to year.';

footnote1 justify=left
"Not only do we see the number of 3 points attempted (3PA) go up, but we also see Field Goal (FG_PCT) percentage go up."
;

footnote2 justify=left
"This means that players are not only making more 3 pointers, they are also getting better at making them with more accuracy."
;

footnote3 justify=left
"Exactly how, or why this is happening, we can't really say. It can be that a 3 pointer is harder to defend or maybe players are simply practicing 3 pointers now more than ever."
;
*
Note: This would compare the columns "3PA" from Player Stats 14-15 and the
columns "3PA" from Player Stats 14-15.

Limitations: We only have 2 data points. In order to make a broader conclusion,
more years of data would have to be added in to make a conclusion with more
certainty.
;
proc sql;
  	(select 
  		year
  		,avg(_3PA) as _3PA
  		,avg(FG_PCT) as FG_PCT
  	from 
  		masterfile
  	where 
  		year="2014")
	union
  	(select
  		year
  		,avg(_3PA) as _3PA
  		,avg(FG_PCT) as FG_PCT
  	from 
  		masterfile
  	where 
  		year="2015")
  ;
quit;


*The results show that there are in fact more attempts in the 15-16 season
than there are in the 14-15 season, confirming our theory that 3 pointers
attempted are indeed increasing. 
