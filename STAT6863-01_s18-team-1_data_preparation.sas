*******************************************************************************;
**************** 80-character banner for column width reference ***************;
* (set window width to banner width to calibrate line length to 80 characters *;
*******************************************************************************;

*
[Dataset Name] players_stats_data

[Dataset Description] Stats for each NBA player in 2014-2015 that, along with
player stats, includes personal variables such as height, weight, college, and
others.

[Experimental Unit Description] Each player that played during the 2014-2015
NBA season.

[Number of Observations] 491

[Number of Features] 34

[Data Source]
https://github.com/stat6863/team-1_project_repo/blob/master/data/
players_stats.xls

[Data Dictionary] https://www.kaggle.com/drgilermo/nba-players-stats-20142015/
data

[Unique ID Schema] Name is a primary key for the unique id.
;
%let inputDataset1DSN = players_stats_data_raw;
%let inputDataset1URL =
https://github.com/stat6863/team-1_project_repo/blob/master/data/players_stats_data.csv?raw=true
;
%let inputDataset1Type = CSV;

*
[Dataset 2 Name] players_stats_data

[Dataset Description] Stats for each NBA player in the 2015-2016 season. 

[Experimental Unit Description] Each player that played during the 2015-2016
NBA season.

[Number of Observations] 501

[Number of Features] 21

[Data Source]
https://github.com/mcardoso3-stat6863/team-1_project_repo/blob/master/data/players_stats_1516_data.csv

[Data Dictionary]https://www.basketball-reference.com/leagues/NBA_2016_per_game.html

[Unique ID Schema] Player is a primary key for the unique id.
;
%let inputDataset2DSN = players_stats_data_raw_1516;
%let inputDataset2URL =
https://github.com/stat6863/team-1_project_repo/blob/master/data/players_stats_1516_data.csv?raw=true
;
%let inputDataset2Type = CSV;

*
[Dataset 3 Name] 2016-17_officialBoxScore

[Dataset Description] All NBA Team Statistics for Every Game, AY,2016-17

[Experimental Unit Description] Has the combined statistics for every team and
every game that was played in the regular season.

[Number of Observations] 2,461

[Number of Features] 124

[Data Source] https://www.kaggle.com/pablote/nba-enhanced-stats/data

[Data Dictionary] https://basketball.realgm.com/info/glossary

[Unique ID Schema] The column “gmDate” and “TeamAbrv” would combine to make
a unique ID.
;
%let inputDataset3DSN = teamBoxScore_16_17_raw;
%let inputDataset3URL =
https://github.com/stat6863/team-1_project_repo/blob/master/data/teamBoxScore_16_17.csv?raw=true
;
%let inputDataset3Type = CSV;


*
[Dataset 4 Name] PLAYER_ANTHRO

[Dataset Description] Anthropology of NBA draft players participating in the NBA
combine.

[Experimental Unit Description] NBA players

[Number of Observations] 479

[Number of Features] 11

[Data Source] https://stats.nba.com/draft/combine-anthro/ (copy/paste into Excel)

[Data Dictionary] https://stats.nba.com/draft/combine-anthro/

[Unique ID Schema] The columns "PLAYER” and “YEAR” can be combined to create
an unique identifier.
;
%let inputDataset4DSN = player_anthro;
%let inputDataset4URL =
https://github.com/stat6863/team-1_project_repo/blob/master/data/nba_combine_anthro.csv?raw=true
;
%let inputDataset4Type = CSV;

* set global system options;
options fullstimer;

* load raw datasets over the wire, if they doesn't already exist;
%macro loadDataIfNotAlreadyAvailable(dsn,url,filetype);
    %put &=dsn;
    %put &=url;
    %put &=filetype;
    %if
        %sysfunc(exist(&dsn.)) = 0
    %then
        %do;
            %put Loading dataset &dsn. over the wire now...;
            filename
                tempfile
                "%sysfunc(getoption(work))/tempfile.&filetype."
            ;
            proc http
                method="get"
                url="&url."
                out=tempfile
                ;
            run;
            proc import
                file=tempfile
                out=&dsn.
                dbms=&filetype.;
            run;
            filename tempfile clear;
        %end;
    %else
        %do;
            %put Dataset &dsn. already exists. Please delete and try again.;
        %end;
%mend;
%macro loadDatasets;
*change the 3 to 4 if we decide to add another dataset;
%do i = 1 %to 4;
        %loadDataIfNotAlreadyAvailable(
            &&inputDataset&i.DSN.,
            &&inputDataset&i.URL.,
            &&inputDataset&i.Type.
        )
    %end;
%mend;
%loadDatasets


* Begin Data Integrity Checks and Data Integrity Mitigation;

proc sql;
    create table player_anthro_nmiss as
	    select
		    PLAYER,POS
	    from
		    work.player_anthro
	    where
		    PLAYER is missing
	;
quit;

proc sql;
    create table players_stats_data_nmiss as
	    select
		    Name,Pos
	    from
		    work.players_stats_data_raw
	    where
		    Name is missing
	;
quit;

proc sql;
    create table teamboxscore_nmiss as
	    select
		    offFNm1
	    from
		    work.teamboxscore_16_17_raw
	    where
		    offFNm1 is missing
	;
quit;

proc sql;
	create table players_stats_data_1516_nmiss as
		select
			Player
		from
			work.players_stats_data_raw_1516
		where
			Player is missing
	;
quit;

* For all four of our datasets we can see that we have no missing ID values,
which in our case is Name, or a combination of name and position. No rows are
selected when we query missing values for names.
;

proc sql;
    create table player_anthro_dups as
	select
		 PLAYER
 		,POS
		,YEAR
		,count(*) as row_count
	from
		work.player_anthro
	group by
		 PLAYER
 		,POS
		,YEAR
	having
		row_count > 1
	;
quit;

* Using Player, Position and Year, we can succesfully have unduplicated counts
for our Anthro Data.
;

proc sql;
    create table players_stats_data_dups as
	    select
	     	 Name
		    ,Pos
		    ,count(*) as row_count
	    from
		    work.players_stats_data_raw
	    group by
		     Name
		    ,Pos
	    having
		    row_count > 1
	;
quit;


* Again with the the above query we can see that no player names are duplicated,
and therefore our ID value is also unduplicated.
;

proc sql;
    create table teamboxscore_dups as
	    select
		     teamAbbr
		    ,gmDate
		    ,count(*) as row_count
	    from
		    work.teamboxscore_16_17_raw
	    group by
		     teamAbbr
		    ,gmDate
	    having
		    row_count > 1
	;
quit;

* Every team only plays once a day and therefore using team and date variables
as a unique identifier, we can get unduplicated counts for our ID.
;

proc sql;
	create table players_stats_data_1516_dups as
		select
			Player
			,count(*) as row_count
		from
			work.players_stats_data_raw_1516
		group by
			Player
		having
		row_count > 1
	;
quit;

*We can see that no player names are duplicated in this case, and therefore we
have no duplicate ID values.
;

* Inspecting Team Assists in our team box score data;
	/*
	title "Assists in teamBoxscore_16_17";
	proc sql;
		select
			min(teamAST) as min
			,max(teamAST) as max
			,mean(teamAST) as average
			,median(teamAST) as median
		from
			work.TeamBoxscore_16_17_raw
		;
	quit;
	title;


* Inspecting Height in our player Anthro Data;


	title "Inspect Height in player_anthro";
	proc sql;
		select
			min(HEIGHT_SHOES) as min
			,max(HEIGHT_SHOES) as max
			,mean(HEIGHT_SHOES) as average
			,median(HEIGHT_SHOES) as median
		from
			work.player_anthro
		;
	quit;
	title;


* Inspecting # points made in our player statistics data;

	title "Inspect 3PM in players_stats_data_raw";
	proc sql;
		select
			min(_3PM) as min
			,max(_3PM) as max
			,mean(_3PM) as average
			,median(_3PM) as median
		from
			work.players_stats_data_raw
		;
	quit;
	title;


* Inspecting Field Goal Percentage in our player statistics 2015-16 data;

	title "Inspect FG_PCT in players_stats_data_raw_1516";
	proc sql;
		select
			min(FG_PCT) as min
			,max(FG_PCT) as max
			,mean(FG_PCT) as average
			,median(FG_PCT) as median
		from
			work.players_stats_data_raw_1516
		;
	quit;
	title;
	*/

proc sort data=work.players_stats_data_raw;
    by Name;
run;

proc sort data=work.player_anthro;
    by PLAYER;
run;

* combine players_stats_data and player_anthro horizontally using data-step
match-merge;
* Note:  After running the data step and proc sort below several times and
averaging the fullstimer step, they tend to take about .01 seconds of "real
time" to execute and a maximum of about 1250 KB of memory usage on the computer they
were tested on;
data table players_stats_data_and_anthro_v1;
    retain
        PLAYER
        PTS
        DREB
        STL
        BLK
        HEIGHT_SHOES
        WINGSPAN
    ;
    keep
        PLAYER
        PTS
        DREB
        STL
        BLK
        HEIGHT_SHOES
        WINGSPAN
    ;
    merge
        work.player_anthro
        work.players_stats_data_raw(
            rename=(
                Name=PLAYER
            )
        )
  ;
  by PLAYER;
run;

proc sort data=players_stats_data_and_anthro_v1;
    by PLAYER;
run;

* combine players_stats_data and player_anthro horizontally using proc sql;
* Note:  After running this proc sql step and averaging the fullstimer output in
the SAS log, they take about .02 seconds of "real time" to execute and a
maximum of about 5600 KB of memory on the computer they were tested on.  The
proc sql step appears to slightly take more time than the combined data step
and proc sort step while using nearly five times as much memory;
proc sql;
    create table players_stats_data_and_anthro_v2 as
        select
             coalesce(pa.PLAYER,ps.Name) as PLAYER
            ,ps.PTS
            ,ps.DREB
            ,ps.STL
            ,ps.BLK
            ,pa.HEIGHT_SHOES
            ,pa.WINGSPAN
        from
            work.player_anthro as pa
	      full join
		        work.players_stats_data_raw as ps
            on
                PLAYER = Name
        order by
            PLAYER;
quit;

* verify that players_stats_data_and_anthro_v1 and players_stats_data_and_anthro_v2 are
identical;
proc compare
        base=players_stats_data_and_anthro_v1
        compare=players_stats_data_and_anthro_v2
        novalues
    ;
run;


* combine players_stats_data and player_stats_data_1516 vertically using a
data-step interweave, combining composite key values into a single primary key
value;
data player_stats_all_v1;
  retain _ALL_;
  set work.players_stats_data_raw;

* combine players_stats_data and player_stats_data_1516 vertically using proc
sql;
proc sql;
    create table player_stats_all_v2 as
      ( select
             p1415.Name as Player
             ,p1415.FG_PCT
             ,p1415._3PM
             ,p1415._3PA
             ,p1415.MIN
             ,p1415.AST
             ,p1415.REB
        from
            work.players_stats_data_raw as p1415
      )
        outer union corr
      ( select
            p1516.Player
            ,p1516.FG_PCT
            ,p1516._3PM
            ,p1516._3PA
            ,p1516.MIN
            ,p1516.AST
            ,p1516.REB
        from
            work.players_stats_data_raw_1516 as p1516
      )
        order by
            Player;
quit;
