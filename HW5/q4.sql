set serveroutput on;

BEGIN
   DBMS_OUTPUT.put_line( '4.A Names of teams with players from East Lansing' );
END;
/

SELECT DISTINCT T.name
FROM TeamTable T, TABLE( T.players ) TP
WHERE TP.COLUMN_VALUE.paddr = 'East Lansing';

BEGIN
   DBMS_OUTPUT.put_line( '4.B Name of game and highest scoring player' );
END;
/

SELECT G.gid, PS.COLUMN_VALUE.player.pname
FROM Games G, TABLE( G.team1Score MULTISET UNION ALL G.team2Score ) PS
WHERE PS.COLUMN_VALUE.score=G.getMaxScore();

BEGIN
   DBMS_OUTPUT.put_line( '4.C All teams in league A that have not won a game' );
END;
/

SELECT LT.COLUMN_VALUE.name Winless_Team
FROM Leagues L, TABLE( L.lteams ) LT
WHERE NOT EXISTS (
   SELECT *
   FROM Games G
   WHERE G.getWinner()=LT.COLUMN_VALUE.name )
AND L.lname='A';
