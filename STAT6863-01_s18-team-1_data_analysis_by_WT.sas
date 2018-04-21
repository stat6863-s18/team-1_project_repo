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


*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;

*
Question: Do team who make more 3 point shots win more games on average?

Rationale: This would help inform a team that shooting the ball from beyond the
arc would help the team win more games, which s the point of a competitive sport.

Note: This compares the column "3PM" and "Team" from player_stats to the column 
"TeamRslt" from team_box_score.

Limitations: Our player_stats dataset has the name of all players in a single
column. team_box_score has names in multiple columns, for example First name is 
in a column and Last Name is in a seperate column. We must figure out whether
Middle names might affect our ID variable. It seems like player_stats only uses
first and last name, but team_box_score uses multiple. 
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

Limitations: Our player_anthro_data dataset contains a measurement of multiple 
human characteristics. Our player_stats column also has a height column. We can 
make the assumption that our player_anthro data is correct most of the time if
the datasets do not have matching values for the same player.
;
