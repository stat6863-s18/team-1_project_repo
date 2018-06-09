*******************************************************************************;
**************** 80-character banner for column width reference ***************;
* (set window width to banner width to calibrate line length to 80 characters *;
*******************************************************************************;

* set relative file import path to current directory (using standard SAS trick);

X "cd ""%substr(%sysget(SAS_EXECFILEPATH),1,%eval(%length(%sysget(SAS_EXECFILEPATH))-%length(%sysget(SAS_EXECFILENAME))))""";

* load external file that will generate final analytic file;

%include '.\STAT6863-01_s18-team-1_data_preparation.sas';


*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;

title1 justify=left
'Question: Is height telling of defensive success for a player?';

title2 justify=left
'Rationale: Taller players are usually "rim protectors" but lately a lot of teams have been implementing smaller line ups.';

*
Note: This compares the column "Height w/ Shoes" from Player Anthro Data
to the columns "DREB", "STL", and "Blocks" from player_stats.

Limitations: For our nba_combine_anthro dataset and our players_stats we have a
name ID, but it is possible that some players share the same name. Therefore we
must use additional ID variables such as position, and be careful that a player
is not being incorrectly attributed certain statistics.
;

*
Methodology: Using Proc SQL we can query data we need from a masterfile we have
created on NBA stats. After we have the necessary data, we use proc correlation
to see if we can find a meaningful relationship between two of our "defensive" 
stats Blocks(BLK) and Defesnive Rebounds(DREB);

*
Followup Steps: Due to the increasing change in smaller line ups, players that 
often get the most rebounds are also the ones who score the most points as well
as play the most minutes. This means that height might not be directly linear 
to how many rebounds a player gets per game, especially for teams who often
play with "shooting" lineups.
;
 
proc sql;
	select distinct
	         ROUND(HEIGHT_SHOES,10) as Height_With_Shoes_On
                ,avg(DREB) as Average_Defensive_Rebounds
                ,avg(STL) as Average_Steals
                ,avg(BLK) as Average_Blocks
        from
                masterfile
        where HEIGHT_SHOES >72
        group by Height_With_Shoes_On
        order by Height_With_Shoes_On
        ;
quit;

* clear titles/footnotes;
title;
footnote;

footnote1 justify=left
"As we can see from the correlation matrix the height of a player, in inches, is correlated with the number of rebounds and blocks he can get."
;
footnote2 justify=left
"Steals on the other hand can range for all different heights."
;

footnote3 justify=left
"Because taller players can get more rebounds and blocks, we can check if there is a correlation between those 2 variables. With an R of .69 we can say that there is a strong correlation between Blocks and Defensive Rebounds."
;

proc corr data=work.masterfile;
    var
        BLK
        DREB
        HEIGHT_SHOES
    ;
    where
        not(missing(BLK))
        and
        not(missing(DREB))
        and
        HEIGHT_SHOES > 72
    ;
run;

* clear titles/footnotes;
title;
footnote;

*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;
title1 justify=left
"Question: Which kind of guard scores more 3 pointers, SG or PG?";

title2 justify=left
"Rationale: A point guard holds the ball more as he is the quarterback of the team, but does that mean he also scores more?";

*
Note: This compares the column "3PM" and "POS" from masterfile.

Limitations: Our player_stats dataset has the name of all players in a single
column. team_box_score has names in multiple columns, for example First name is
in a column and Last Name is in a seperate column. We must figure out whether
Middle names might affect our ID variable. It seems like player_stats only uses
first and last name, but team_box_score uses multiple.
;

*
Methodology: Using Proc Sort we can create a new file from our NBA stats
masterfile where we only include our Position (PG and SG) and 3 points made 
variable. From there, using Proc Report we can take the average number of 3
points made by position and compare our values. We can then see which
player positions are scoring most by looking at the data visually with bar
charts, where the x axis is position and the y-axis is average 3 points made.
;

*
Followup Steps: Because great players can often play multiple positions, they
blurry the lines and are often given multiple labels such as PG-SG or listed 
twice under each label. In order to get a true sense of what position is making
the most 3 point shots, then we would clearly have to define each players
position.
;
proc sort
        data=masterfile
        out=masterfile_sorted
    ;
    by
        descending POS
        _3PM
    ;
    where
        POS = "SG"
        or
        POS = "PG"
    ;
run;


proc report data=masterfile_sorted (keep=POS _3PM);
    columns POS _3PM;
    DEFINE POS/group 'Position';
    DEFINE _3PM/mean format=5.2 'Average 3 Points Made' width=8;
    ;
run;

title;
footnote;

footnote1 justify=left
"Between pure Point Guard (PG) and Shooting Guard (SG) positions, Point Guards score more 3 pointers on average."
;

footnote2 justify=left
"When you get hybrid players that play multiple positions, this conclusion changes. There are players who can play multiple positions and score plenty of 3 pointers."
;
proc sgplot data=work.masterfile;
  vbar POS/ response=_3PM stat=mean;
run;

* clear titles/footnotes;
title;
footnote;

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

*
Methodology: Using Proc SQL we can query data from our NBA masterfile to create 
a report and see what the difference in attempts and field goal percantage is 
between 2014 and 2015. 
;

*
Followup Steps: In order to make this a more accurate and complete conclusion,
we would have to collect more data points for this upcoming year. This would
tell us if indeed the trend is going up or if what we are witnessing is just
simple deviation.

;

proc sql;
  	(select 
  		year
  		,avg(_3PA) as _3_Points_Attempted
  		,avg(FG_PCT) as Field_Goal_Percentage
  	from 
  		masterfile
  	where 
  		year="2014")
	union
  	(select
  		year
  		,avg(_3PA) as _3_Points_Attempted
  		,avg(FG_PCT) as Field_Goal_Percentage
  	from 
  		masterfile
  	where 
  		year="2015")
  ;
quit;


*The results show that there are in fact more attempts in the 15-16 season
than there are in the 14-15 season, confirming our theory that 3 pointers
attempted are indeed increasing. 

* clear titles/footnotes;
title;
footnote;
