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
 
*
Note:  We would be looking at data for the 2014-15 NBA season in the
players_stats_data dataset using the "Name", "FG_PCT", and "FGA" columns along
with the players_stats_1516_data dataset using the columns "Player",  "FG_PCT",
and "FGA".

Limitations:  Since we are comparing data over a two year period, we can not
exactly conclude much as far as whether there is a trend from the small
timeline.

Methodology:  We will use proc sort to order the data by FG_PCT in descending
order, provided that the players selected shot more than 10 field goals per
game.  We then use proc report to display a table of the top ten leaders in the
field goal percentage category while indicating which columns we wish output.
Finally, we use proc sgplot to display these ten leaders and how their
respective field goal percentage for the indicated season compares with the
other leaders.

Followup Steps:  We could follow up this experiment by expanding our data to
include the player's position to see if there is a corrlation between a
player's field goal percentage compared to their natural position.
;

title3 justify=left
'Table displaying the top ten NBA players with the highest shooting performance during the 2014-15 and 2015-16 NBA season'
;

footnote1 justify=left
"We can see from the table that five of the six highest shooting players from the two seasons are from the 2014-15 season, followed by four shooting performances from the 2015-16 season.  It shows that the top performers in this category declined between the two seasons."
;

footnote3 justify=left
"A possible reason for the decline in shooting percentage among leaders is that games are being played faster, which leads to more shotdss, and therefore a higher chance of rushed shots being missed."
;

footnote3 justify=left
"It is interesting to note that nine of the ten leaders, with the exception being Lebron James, have a natural position of power forward or center." 
;

proc sort
		data=masterfile
		out=FG_PCT_COMPARE
	;
	by
		descending FG_PCT
	;
	where
		FGA > 10
	;
run;

proc print data=FG_PCT_COMPARE(obs=10);
run;

proc report data=FG_PCT_COMPARE(obs=10);
	columns
		Player
		Year
		POS
		FGA
		FG_PCT
	;
run;

*clear titles/footnotes;
title;
footnote;


title1 justify=left
'Plot illustrating the NBA players with the beast Field Goal Percentage during the 2014-15 and 2015-16 season'
;

footnote1 justify=left
"The plot shows that Dwight Howard, and to a lesser extent Marcin Gortat, by far has the best shooting percentage from the two seasons based on players who averaged more than 10 shots per game.  The following 8 players in the top ten list are closely bunched together."
;

proc sgplot data=FG_PCT_COMPARE(obs=10);
	vbar Player / response=FG_PCT;
	yaxis ranges=(50-60);
run;

*clear titles/footnotes;
title;
footnote;

*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;

title1 justify=left
'Question: Who are the NBA players that averaged the most assists during the 2014-15 and 2015-2015 season?'
;

title2 justify=left
'Rationale:  Ball movement has become more recognized and utilized in recent years, so it would be important to know which players produce the most assists over the duration of a season and if they can be consistent in doing it the following season.'
;

*
Note:  We will be using the players_stats_data dataset with the columns "Name"
and "AST", and the players_stats_data_raw_1516 dataset for this analysis while
using the columns "Player" and "AST".  Due to the data in each dataset being a
year apart, some players may not be on the same team in both datasets

Limitations:  Given how the data for the players_stats_data dataset displays
total stats for the season and the players_stats_data_raw_1516 displays stats
per game, we do not have an exact comparison.  We would need to multiply or
divide one of the datasets by 83, the number of games in an NBA season, in
order to have an exact comparison

Methoology:  We use proc sql to create a table while computing the average
number of assists per game over the two seasons for each player.  The table is
sorted in descending order by this category as we display the top ten leaders
for average assists.

Followup steps:  We can include more columns to further advance any analysis
that we wish to experiment on that can relate to player's assists, such as
Team, Position, and Points.
;

title3 justify=left
'Table showing the top leaders in average assists over the 2014-15 and 2015-16 NBA seasons.'
;

footnote1 justify=left
"We can see that Chris Paul, John Wall, and Rajon Rondo averaged the most assists during the two specified NBA seasons."
;

footnote2 justify=left
"We can see that the three mentioned individuals have significantly higher assist averages than the rest of the league.  We can also see that all three averaged approximately 10 assists per game, which is considered a remarkable feat."
;

footnote3 justify=left
"It's important to note that eight of the players in the top ten in assists, with Lebron James and James Harden being the exceptions, are point guards, which is the position that traditionally creates the offense."
;

proc sql outobs=10;
	select
		 Player
		,avg(AST)as AvgAST (label="Average Assits")
	from
		masterfile
	group by
		Player
	order by
		AvgAST desc
	;
run;

*clear titles/footnotes;
title;
footnote;

*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;

title1 justify=left
'Question: What is a larger factor for NBA players grabbing the most rebounds:  Height or Weight?'
;

title2 justify=left
'Rationale: It will be interesting to analyze whether height or weight is a larger factor towards producing more rebounds.  General managers of teams could use this analysis when determining which future NBA players to draft to the team.'
;

*
Note:  We will be using the columns "Name" and "REB" from the
players_stats_data dataset along with the columns "HEIGHT_SHOES" and "WEIGHT" in
the nba_combine_anthro dataset

Limitations:  Since the player list for the player_anthro data is only showing
heights and weights for players from the NBA combine, the comparision may not
have complete accuracy given the typical height and weight of an NBA player is
much different than one about to enter the league

Methodology:  Use proc corr to give us the overall average in HEIGHT_SHOES and
WEIGHT for all NBA players in our dataset, with no missing data included.
Then, use proc sort to order the dataset by Rebounds in descending order while
indicating HEIGHT_SHOES and WEIGHT are greater than zero.  We then use proc
report to create a table while indicating the columns we want to be displayed.
Finally, we use proc means to compute the two averages in HEIGHT_SHOES and
WEIGHT among the top twenty rebounders according to the table.

Followup Steps:  Cleaning out any unecessary information under the proc corr
table in order to make the analysis easier to comprehend and conclude.
;

title3 justify=left
'Table which includes overall mean for NBA player HEIGHT_SHOES and WEIGHT'
;

footnote1 justify=left
"We can see that the average height in shoes of the selected NBA players is 152 centimeters while the average weight is 214 pounds."
;

footnote2 justify=left
"We can see in the correlation table that the p-values for both Height in Shoes and Weight are each about .617, meaning there is litle difference between the two categories in terms of rebounding."
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

*clear titles/footnotes;
title;
footnote;

title1 justify=left
'Table of the regresiion model and several plots corresponding to it'
;

footnote1 justify=left
"Looking at the model, we can see that the p-value for the model is very small, indicating that there is a corrleation."
;

footnote2 justify=left
"Looking at the plots, we can see a strong linear relationship and that the variables HEIGHT_SHOES and WEIGHT, specifically in the residual plots, are similarly related to the Rebounds variable."
;

proc reg data=masterfile;
	model REB = HEIGHT_SHOES WEIGHT;
run;

*clear titles/footnotes;
title;
footnote;

