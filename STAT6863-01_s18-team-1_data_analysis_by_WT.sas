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
;


*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;

*
Question: Do team who make more 3 point shots win more games on average?

Rationale: This would help inform a team that shooting the ball from beyond the
arc would help the team win more games, which s the point of a competitive sport.

Note: This compares the column "3PM" and "Team" from player_stats to the column 
"TeamRslt" from team_box_score.
;


*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;

*
Question: Do taller players have more accurate shots due to them being closer to 
the rim on average?

Rationale: Centers usually stay close to the rim to get rebounds and better shots 
due to their height but does that actually translate into a higher Field Goal 
Percentage?.

Note: This would compare the columns "Height w/ Shoes" from Player Anthro Data
and "FG%" from player_stats.
;
