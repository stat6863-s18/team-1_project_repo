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
[Dataset 3 Name] PLAYER_ANTHRO

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
%let inputDataset3DSN = player_anthro;
%let inputDataset3URL =
https://github.com/stat6863/team-1_project_repo/blob/master/data/nba_combine_anthro.csv?raw=true
;
%let inputDataset3Type = CSV;

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
%do i = 1 %to 3;
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
	create table players_stats_data_1516_nmiss as
		select
			Player
		from
			work.players_stats_data_raw_1516
		where
			Player is missing
	;
quit;

* For all three of our datasets we can see that we have no missing ID values,
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


* Again with the the above query we can see that no player names are
duplicated, and therefore our ID value is also unduplicated.
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

*remove duplicates from masterfile_raw with respect to Player and year;
*after inspecting the rows of the masterfile_raw dataset, we see that there are
duplicates in the player and name columns between the joined datasets, but the
variable 'year' distinguishes a difference between the duplicates.  We will
thus use proc sort to indiscriminately remove duplicates;
proc sql;
	create table masterfile_raw as
		select
			*
		from
		  (( select
				"2014" as year
				,p1415.Name as Player
				,p1415.FG_PCT
				,Round(p1415.FGA/p1415.Games_Played,.1) as FGA
				,Round(p1415._3PM/p1415.Games_Played,.1) as _3PM
				,Round(p1415._3PA/p1415.Games_Played,.1) as _3PA
				,Round(p1415.MIN/p1415.Games_Played,.1) as MIN
				,Round(p1415.AST/p1415.Games_Played,.1) as AST
				,Round(p1415.REB/p1415.Games_Played,.1) as REB
				,Round(p1415.DREB/p1415.Games_Played,.1) as DREB
				,Round(p1415.STL/p1415.Games_Played,.1) as STL
				,Round(p1415.BLK/p1415.Games_Played,.1) as BLK
			 from
				work.players_stats_data_raw as p1415
			)
			outer union corr
			( select
				"2015" as year
				,p1516.Player
				,p1516.FG_PCT*100 as FG_PCT
				,p1516.FGA
				,p1516._3PM
				,p1516._3PA
				,p1516.MIN
				,p1516.AST
				,p1516.REB
				,p1516.DREB
				,p1516.STL
				,p1516.BLK
			from
				work.players_stats_data_raw_1516 as p1516
			)) as ps
			left join
				work.player_anthro as pa
			on
				pa.PLAYER = ps.Player
		order by
			PLAYER;
quit;

*remove duplicates from masterfile_raw with respect to Player and year;
*after inspecting the rows of the masterfile_raw dataset, we see that there are
duplicates in the player and name columns between the joined datasets, but the
variable 'year' distinguishes a difference between the duplicates.  We will
thus use proc sort to indiscriminately remove duplicates;
proc sort
        nodupkey
        data=masterfile_raw
        out=masterfile
    ;
    by Player year    
    ;
run;
