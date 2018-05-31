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
'Question: How do the NBA players overall shooting percentage for the 2014-15 season compare with the players with the overall shooting percentages for the 2015-16 season?'
;

title2 justify=left
'Rationale:  This will help tell us if the NBA players on average shot better than in the previous season.'
;

footnote1 justify=left
"We can see from the table that 5 of the six highest shooting players from the two seasons are from the 2014-15 season, followed by 4 shooting performances from the 2015-16 season.  It shows that the top performers in this category declined between the two seasons."
;

footnote2 justify=left
"The plot shows that Dwight Howard, and to a lesser extent Marcin Gortat, by far has the best shooting percentage from the two seasons based on players who averaged more than 10 shots per game.  The following 8 players in the top ten list are closely bunched together."
;
 
*
Note:  We would be looking at data for the 2014-15 NBA season in the
players_stats_data dataset using the "Name", "FG_PCT", and "FGA" columns along
with the players_stats_1516_data dataset using the columns "Player",  "FG_PCT",
and "FGA".

Limitations:  Since we are comparing data over a two year period, we can not
exactly conclude much as far as whether there is a trend from the small
timeline
;

proc sql outobs=10;
	select
		 Player
		,Year
		,FGA
		,FG_PCT
	from
		masterfile
	where
		FGA > 10
	order by
		FG_PCT desc
	;
run;

proc sgplot data=FG_PCT_COMPARE;
	scatter
		x=Player
		y=FG_PCT
	;
run;

*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;

title1 justify=left
'Question: Who are the NBA players that averaged the most assists during the 2014-15 and 2015-2015 season?'
;

title2 justify=left
'Rationale:  Ball movement has become more recognized and utilized in recent years, so it would be important to know which players produce the most assists over the duration of a season and if they can be consistent in doing it the following season.'
;

footnote1 justify=left
"We can see that Chris Paul, John Wall, and Rajon Rondo averaged the most assists during the two specified NBA seasons."
;

footnote2 justify=left
"It's important to note that 8 of the players in the top ten in assists, with Lebron James and James Harden being the exceptions, are point guards, which is the position that traditionally creates the offense."
;

*
Note:  We will be using the players_stats_data dataset with the columns "Name"
and "AST", and the players_stats_data_raw_1516 dataset for this analysis while
using the columns "Player" and "AST".  Due to the data in each dataset being a year
apart, some players may not be on the same team in both datasets

Limitations:  Given how the data for the players_stats_data dataset displays
total stats for the season and the players_stats_data_raw_1516 displays stats
per game, we do not have an exact comparison.  We would need to multiply or
divide one of the datasets by 83, the number of games in an NBA season, in
order to have an exact comparison
;

proc sql outobs=10;
	select
		 Player
		,avg(AST) as AvgAST
	from
		masterfile
	group by
		Player
	order by
		AvgAST desc
	;
run;

*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;

title1 justify=left
'Question: How do the players that average the most rebounds compare with their height and weight?'
;

title2 justify=left
'Rationale: It will be interesting to analyze whether height or weight is a larger factor towards producing more rebounds.  General managers of teams could use this analysis when determining which future NBA players to draft to the team.'
;

footnote1 justify=left
"We can see that the average height in shoes of the selected NBA players is 152 centimeters while the average weight is 214 pounds."
;

footnote2 justify=left
"Looking at the top rebounders over the 2014-15 and 2015-2016 season, we notice that the leaders, Andre Drummond, has a height in shoes at 213 and a weight of 278.6."
;

footnote3 justify=left
"Computing the means of the rebounding leaders, we see that the height in shoes and weight column averages, 185.1 and 247.1 respecitively, are each higher than the overall average by about the same difference.  Thus, height in shoes and weight each appear to carry the same magnitude of importance in rebounding."
;

*
Note:  We will be using the columns "Name" and "REB" from the
players_stats_data dataset along with the columns "HEIGHT_SHOES" and "WEIGHT" in
the nba_combine_anthro dataset

Limitations:  Since the player list for the player_anthro data is only showing
heights and weights for players from the NBA combine, the comparision may not
have complete accuracy given the typical height and weight of an NBA player is
much different than one about to enter the league
;

proc corr data=masterfile;
	var
		HEIGHT_SHOES
		WEIGHT
	;
	where
		not(missing(HEIGHT_SHOES))
		and
		not(missing(WEIGHT))
	;
run;

proc sql outobs=20;
	select
		Player
		,Year
		,REB
		,HEIGHT_SHOES
		,WEIGHT
	from
		masterfile
	where
		HEIGHT_SHOES > 0
		and
		WEIGHT > 0
	order by
		REB desc
	;
quit;

proc means data=REBOUNDS_SIZE;
	var
		HEIGHT_SHOES
		WEIGHT
	;
run;
