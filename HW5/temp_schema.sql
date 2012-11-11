drop type teamtype force;
drop type teamTableRefType force;
drop type playerScoreTableRefType force;
drop type playerScoreType force;
drop type playerTableRefType force;
drop type playerType force;

drop table PlayerTable;
drop table PlayerScoreTable;
drop table TeamTable;

create or replace type PlayerType as object (
  pid varchar2(10),
  pname varchar2(20),
  paddr varchar2(20)
);
/

create table PlayerTable of PlayerType;
/

create or replace type PlayerTableRefType as table of ref PlayerType;
/

create or replace  type TeamType as OBJECT
(
   name VARCHAR2(50),
   players PlayerTableRefType
);
/

create or replace  type PlayerScoreType as object
(
   player ref PlayerType,
   score NUMBER
);
/

create table PlayerScoreTable of PlayerScoreType;
/

create or replace type PlayerScoreTableRefType as table of ref PlayerScoreType;
/  

create or replace type StadiumType as OBJECT (
   sid VARCHAR2(10),
   sname VARCHAR2(50),
   steam REF TeamType
);
/

create table TeamTable of TeamType
   nested table players store as teamPlayersTableRef;
/

create or replace type TeamTableRefType as table of ref TeamType;
/

create or replace type LeagueType as Object
(
   lid VARCHAR2(10),
   lname VARCHAR2(50),
   lteams TeamTableRefType
);
/

create or replace Type GameType as Object
(
   gid VARCHAR2(50), 
   Stadium StadiumType,
   team1 REF TeamType,
   team2 REF TeamType,
   team1Score PlayerScoreTableRefType,
   team2Score PlayerScoreTableRefType,
   MEMBER FUNCTION getMaxScore RETURN NUMBER,
   -- returns highest score of players in the game

   MEMBER FUNCTION getWinner RETURN VARCHAR2,
   -- return team ID of the winning team of the  game.

   PRAGMA RESTRICT_REFERENCES(getMaxScore, WNDS),
   PRAGMA RESTRICT_REFERENCES(getWinner, WNDS)
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

create or replace type BODY GameType AS
   MEMBER FUNCTION getWinner RETURN VARCHAR2 IS
      sum1 NUMBER :=0;
      sum2 NUMBER :=0;
      score NUMBER;
      winner VARCHAR2(10) := NULL;
   BEGIN
      FOR I IN 1 .. SELF.team1Score.COUNT
      LOOP
         SELECT DEREF(SELF.team1Score(I)).score INTO score FROM DUAL;
         sum1 := sum1+score;
      END LOOP;
      
      FOR I IN 1 .. SELF.team2Score.COUNT
      LOOP
         SELECT DEREF(SELF.team2Score(I)).score INTO score FROM DUAL;
         sum2 := sum2+score;
      END LOOP;
      
      IF sum1 > sum2 THEN
         SELECT DEREF(SELF.team1).name INTO winner FROM DUAL;
      ELSIF sum2 > sum1 THEN
         SELECT DEREF(SELF.team2).name INTO winner FROM DUAL;
      END IF;

      RETURN winner;
   END getWinner;

   MEMBER FUNCTION getMaxScore RETURN NUMBER IS 
      maxScore NUMBER := 0;
      tempScore NUMBER := 0;
   BEGIN
      FOR I IN 1 .. SELF.team1Score.COUNT
      LOOP
         SELECT DEREF( SELF.team1Score(I) ).score INTO tempScore FROM DUAL;
         IF tempScore > maxScore THEN
            maxScore := tempScore;
         END IF;
      END LOOP;

      FOR I IN 1 .. SELF.team2Score.COUNT
      LOOP
         SELECT DEREF( SELF.team2Score(I) ).score INTO tempScore FROM DUAL;
         IF tempScore > maxScore THEN
            maxScore := tempScore;
         END IF;
      END LOOP;

      RETURN maxScore;
   END getMaxScore;
END;
/
