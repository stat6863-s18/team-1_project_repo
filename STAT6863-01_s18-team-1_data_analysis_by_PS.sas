* set relative file import path to current directory (using standard SAS trick);
X "cd ""%substr(%sysget(SAS_EXECFILEPATH),1,%eval(%length(%sysget(SAS_EXECFILEPATH))-%length(%sysget(SAS_EXECFILENAME))))""";


* load external file that will generate final analytic file;
%include '.\STAT6863-01_s18-team-1_project_data_preparation';


*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;
*
Question: Does offense win more games than defense?
Rationale: Defense has always been known to win chamionships but modern day NBA 
focuses more on offense than defense.
Note: This question will see how wins are won by comparing points, assists 
offensive rebounds as offense, defensive rebounds, steals, and blocks as 
defense. team_box_score and player_stats
;


*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;
*
Question: Which position is the most important for a championship caliber team?
Rationale: NBA teams have built their teams around centers, guards, or forwards.
But which position provided the most help in winning a championship.
Note: This question will look at shots made, total rebounds, and total
assists and how it has contributed to championship wins. team_box_score and
player_stats
;


*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;
*
Question: Is wingspan an effective measurement of an average double digit 
scorer?
Rationale: Sam Hinkie, previous GM of the Philadelphia 76ers, looked at 
physical and athletic traits in order to predict a "superstar" player. One of 
those traits was wingspan.
Note: This question will look at average double digit scorer in the NBA and 
compare their wingspan. player_stats and player_anthro
;
