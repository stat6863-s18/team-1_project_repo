*******************************************************************************;
**************** 80-character banner for column width reference ***************;
* (set window width to banner width to calibrate line length to 80 characters *;
*******************************************************************************;

* 
[Dataset Name] player_stats

[Dataset Description] Stats for each NBA player in 2014-2015 that, along with player stats, includes personal variables such as height, weight, college, and others.

[Experimental Unit Description] Each player that played during the 2014-2015 NBA season.

[Number of Observations] 491                 

[Number of Features] 34

[Data Source] https://github.com/stat6863/team-1_project_repo/blob/master/data/players_stats.xls

[Data Dictionary] https://www.kaggle.com/drgilermo/nba-players-stats-20142015/data

[Unique ID Schema] Name is a primary key for the unique id.
;
%let inputDataset1DSN = player_stats;
%let inputDataset1URL =
https://github.com/stat6863/team-1_project_repo/blob/master/data/players_stats.xlsx
;
%let inputDataset1Type = XLSX;


*
[Dataset 3 Name] 2016-17_officialBoxScore

[Dataset Description] All NBA Team Statistics for Every Game, AY,2016-17

[Experimental Unit Description] Has the combined statistics for every team and every game that was played in the regular season. 

[Number of Observations] 2,461
                   
[Number of Features] 124

[Data Source] https://www.kaggle.com/pablote/nba-enhanced-stats/data

[Data Dictionary] https://basketball.realgm.com/info/glossary

[Unique ID Schema] The column “gmDate” and “TeamAbrv” would combine to make a unique ID. 
;
%let inputDataset2DSN = teamBoxScore;
%let inputDataset2URL =
https://github.com/stat6863/team-1_project_repo/blob/master/data/teamBoxScore_16-17.xls
;
%let inputDataset2Type = XLSX;


*
[Dataset 3 Name] PLAYER_ANTHRO

[Dataset Description] Anthropology of NBA draft players participating in the NBA combine.

[Experimental Unit Description] NBA players

[Number of Observations] 479
                   
[Number of Features] 11

[Data Source] https://stats.nba.com/draft/combine-anthro/ (copy/paste into Excel)

[Data Dictionary] https://stats.nba.com/draft/combine-anthro/

[Unique ID Schema] The columns "PLAYER” and “YEAR” can be combined to create an unique identifier.
;
%let inputDataset3DSN = ;
%let inputDataset3URL = ;
%let inputDataset3Type = XLSX;



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
