drop type teamtype force;
drop type teamTableRefType force;
drop type playerScoreTableRefType force;
drop type playerScoreType force;
drop type  playerTableRefType force;
drop type playerType force;


create or replace type PlayerType as object (
  pid varchar2(10),
  pname varchar2(20),
  paddr varchar2(20)
);
/

create or replace type PlayerTableRefType as table of ref PlayerType;
/

create or replace  type TeamType as object
(
   name VARCHAR2(50),
   players PlayerTableRefType
);
/

create or replace  type PlayerScoreType as object
(
   player PlayerType,
   score NUMBER
);
/

create or replace  type PlayerScoreTableRefType as table of ref PlayerScoreType;
/  

create or replace type StadiumType as OBJECT (
   sid VARCHAR(10),
   sname VARCHA(50),
   steam REF TeamType
);
/

create or replace type LeagueType as Object
(
   lid VARCHAR(10),
   lname VARCHAR(50),
   lteams TeamTableRefType
);
/

create or replace Type GameType as Object
(
   gid VARCHAR, 
   Stadium StadiumType,
   team1 REF TeamType,
   team2 REF TeamType,
   team1Score PlayerScoreTableRefType,
   team2Score PlayerScoreTableRefType,
   MEMBER FUNCTION getMaxScore RETURN NUMBER,
   -- returns highest score of players in the game

   MEMBER FUNCTION getWinnerRETURN VARCHAR2
   -- return team ID of the winning team of the  game.

   PRAGMA RESTRICT_REFERENCES(getMaxScore, WNDS),
   PRAGMA RESTRICT_REFERENCES(getWinner, WNDS),
);
/
/******
We can define the type GameType which has attributes team1Score and team2Score 
which are of table types.  When we define a table of GameType we need to 
indicate nested as follows:
******/


drop table Games;
create table Games of GameType
   nested table team1Score store as team1ScoreTableRef
   nested table team2Score store as team2ScoreTableRef;
create or replace type LeagueType as Object
(
   lid VARCHAR(10),
   lname VARCHAR(50),
   lteams TeamTableRefType
);
/

create or replace Type GameType as Object
(
   gid VARCHAR, 
   Stadium StadiumType,
   team1 REF TeamType,
   team2 REF TeamType,
   team1Score PlayerScoreTableRefType,
   team2Score PlayerScoreTableRefType,
   MEMBER FUNCTION getMaxScore RETURN NUMBER,
   -- returns highest score of players in the game

   MEMBER FUNCTION getWinnerRETURN VARCHAR2
   -- return team ID of the winning team of the  game.

   PRAGMA RESTRICT_REFERENCES(getMaxScore, WNDS),
   PRAGMA RESTRICT_REFERENCES(getWinner, WNDS),
);
/
/******
We can define the type GameType which has attributes team1Score and team2Score 
which are of table types.  When we define a table of GameType we need to 
indicate nested as follows:
******/


drop table Games;
create table Games of GameType
   nested table team1Score store as team1ScoreTableRef
   nested table team2Score store as team2ScoreTableRef;


/**********
or we could define the table directly as follows:
**********


drop table Games;
create table Games (
  gid varchar(10),
  team1 REF TeamType,
  team2 REF TeamType,
  team1Score PlayerScoreTableRefType,
  team2Score PlayerScoreTableRefType
)
nested table team1Score store as team1ScoreTable
nested table team2Score store as team2ScoreTable;


***********/

/*
Get max score of players in a game
*/

create or replace type BODY GameType AS
MEMBER FUNCTION getMaxScore RETURN NUMBER IS 

/***********
ADD  HERE PL/SQL
***********/

END;

MEMBER FUNCTION getWinner RETURN VARCHAR2 IS
  sum1 NUMBER :=0;
  sum2 NUMBER :=0;
  score NUMBER;
  winner VARCHAR2(10) ;= NULL;
BEGIN
  FOR I IN 1 .. SELF.team1Score.COUNT
  LOOP
    SELECT DREF(SELF.team1Score(I)).score INTO score FROM DUAL;
    sum1:=sum1+score;   {sum of all palayer scores for team1}
  END LOOP;
  FOR I IN 1 .. SELF.team2Score.COUNT
  LOOP
    SELECT DREF(SELF.team2Score(I)).score INTO score FROM DUAL;
    sum2:=sum2+score;    {sum of all player scores for team2}
  END LOOP;
  IF sum1>sum2 THEN
    SELECT DREF(SELF.team1).tid INTO winner FROM DUAL;
  ELSEIF sum2 >sum1 THEN 
    SELECT DREF(SELF.team2).tid INTO winner FROM DUAL;
  END IF;
  RETURN winner;
  END;
END;
/

create or replace type AgentType AS OBJECT
(
  agid VARCHAR2(10),
  agname VARCHAR2(50)
);
/
create or replace TYPE AgentTableRefType AS TABLE OF REF AgentType;
/
create or replace type CompanyType AS OBJECT
(
 cid VARCHAR2(10),
 coname VARCHAR2(50),
 coagents AgentTableRefType,
 coplayers PlayerTableRefType
);
/  

-- Create all tables now.  

drop table Players;
create table Players of PlayerType;

drop table Teams;
drop table TplayersTable;
create table Teams of TeamType
  nested table tplayers store as tplayersTable;

-- Example for a need for casting

 insert into Teams values('T001', 'Red', 'East Lansing',
  cast(multiset(select ref(pp) from Players pp) as PlayerTableRefType));
commit;
select * from Teams;

drop table Games;
create table Games (
  gid varchar(10),
  team1 REF TeamType,
  team2 REF TeamType,
  team1Score PlayerScoreTableRefType,
  team2Score PlayerScoreTableRefType
) 
nested table team1Score store as team1ScoreTable
nested table team2Score store as team2ScoreTable;

insert into Games (gid, team1, team2) values ('G001',  
  cast(multiset(select ref(t1) from teams t1) as TeamTableRefType),
  cast(multiset(select ref(t2) from teams t2) as TeamTableRefType));
  
commit;
create Stadiums of StadiumType;

create table Leagues of LeagueType
Nested table lteams STORE AS LeagueTeamsTable;

Create table Cities of CityType
nested table cteams STORE AS CityTeamsTable;

create table PlayersScore of PlayerScoreType;

create table Agents of AgentType;

create Table Companies of CompanyType
nested table coagents STORE AS CoAgentScoreTable
nested Table coplayers STORE AS CoPlayersTable;

