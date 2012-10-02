'''
Question 1
'''
CREATE OR REPLACE TRIGGER DONT_UPDATE_JOHN_DOE 
BEFORE UPDATE ON SCORES_IN
FOR EACH ROW
DECLARE
  J_DOE_ID NUMBER;
BEGIN
  SELECT eid INTO J_DOE_ID
  FROM Employees
  WHERE name='John Doe';

  IF ( :NEW.pid = J_DOE_ID )
  THEN
    raise_application_error( -20001, 'Cannot update scores for John Doe' );
  END IF;
END;


'''
Question 2

Answer notes:
 - It would be much more efficient to implement this as a row level trigger,
   but Oracle throws an error when selecting from a mutating table (which is how
   we would calculate the average of affected players when rows are upadted in the
   scores_in table).
 - Ideally, this derived attribute would be calculated at query time to avoid data
   redundancy/maintenance performance issues.
'''
ALTER TABLE Players ADD avg_score NUMBER;

CREATE OR REPLACE TRIGGER AVG_SCORE
AFTER UPDATE OR INSERT OR DELETE ON Scores_In
DECLARE
  /* Update new averages*/
  CURSOR Averages IS
  SELECT Players.eid AS pid, AVG(score) AS p_avg
  FROM Scores_In, Players
  WHERE Players.eid=Scores_In.pid
  GROUP BY Players.eid;
  
  /* Update any players who have no scores yet */
  CURSOR Scoreless IS
  SELECT eid AS pid
  FROM Players
  WHERE NOT EXISTS (
    SELECT null
    FROM Scores_In
    WHERE Scores_In.pid=Players.eid );
BEGIN
  FOR Average IN Averages LOOP
    UPDATE Players SET Players.avg_score = Average.p_avg WHERE Players.eid=Average.pid;
  END LOOP;
  
  FOR OmittedPlayer IN Scoreless LOOP
    UPDATE Players SET Players.avg_score=0 WHERE Players.eid=OmittedPlayer.pid;
  END LOOP;
END;

'''
Question 3
 - Note: Assumes that Stadiums represent the location earning money from a sale.
'''
DROP TABLE Sales CASCADE CONSTRAINTS;
CREATE TABLE Sales(
  sale_id NUMBER PRIMARY KEY,
  gid NUMBER NOT NULL,
  amount NUMBER,
  FOREIGN KEY(gid) REFERENCES Games(gid)
);

/* LOCATION 1 */
DROP TABLE Sales_Loc_1 CASCADE CONSTRAINTS;
CREATE TABLE Sales_Loc_1(
  gid NUMBER,
  average_sale NUMBER,
  total_sale NUMBER,
  num_transactions NUMBER
);

CREATE OR REPLACE TRIGGER UPDATE_SALES_LOC_1 
AFTER INSERT OR DELETE OR UPDATE ON SALES 
DECLARE
  CURSOR Sales_Loc_1_Cursor IS
  SELECT S.gid AS gid, 
         AVG( S.amount ) AS average_sale, 
         SUM( S.amount ) AS total_sale, 
         COUNT(*) AS num_transactions
  FROM Sales S, Games
  WHERE S.gid=Games.gid AND
        Games.sid=1
  GROUP BY S.gid;
BEGIN
  FOR Sales_Stat IN Sales_Loc_1_Cursor LOOP
    UPDATE Sales_Loc_1 
    SET average_sale=Sales_Stat.average_sale, 
        total_sale=Sales_Stat.total_sale, 
        num_transactions=Sales_Stat.num_transactions
    WHERE gid=Sales_Stat.gid;
    IF ( sql%rowcount = 0 ) THEN
      INSERT INTO Sales_Loc_1 
      VALUES ( Sales_Stat.gid, Sales_Stat.average_sale, Sales_Stat.total_sale, Sales_Stat.num_transactions );
    END IF;
  END LOOP;
END;

/* LOCATION 2 */
DROP TABLE Sales_Loc_2 CASCADE CONSTRAINTS;
CREATE TABLE Sales_Loc_2(
  gid NUMBER,
  average_sale NUMBER,
  total_sale NUMBER,
  num_transactions NUMBER
);

CREATE OR REPLACE TRIGGER UPDATE_SALES_LOC_2 
AFTER INSERT OR DELETE OR UPDATE ON SALES 
DECLARE
  CURSOR Sales_Loc_2_Cursor IS
  SELECT S.gid AS gid, 
         AVG( S.amount ) AS average_sale, 
         SUM( S.amount ) AS total_sale, 
         COUNT(*) AS num_transactions
  FROM Sales S, Games
  WHERE S.gid=Games.gid AND
        Games.sid=2
  GROUP BY S.gid;
BEGIN
  FOR Sales_Stat IN Sales_Loc_2_Cursor LOOP
    UPDATE Sales_Loc_2 
    SET average_sale=Sales_Stat.average_sale, 
        total_sale=Sales_Stat.total_sale, 
        num_transactions=Sales_Stat.num_transactions
    WHERE gid=Sales_Stat.gid;
    IF ( sql%rowcount = 0 ) THEN
      INSERT INTO Sales_Loc_2 
      VALUES ( Sales_Stat.gid, Sales_Stat.average_sale, Sales_Stat.total_sale, Sales_Stat.num_transactions );
    END IF;
  END LOOP;
END;

/* LOCATION 3 */
DROP TABLE Sales_Loc_3 CASCADE CONSTRAINTS;
CREATE TABLE Sales_Loc_3(
  gid NUMBER,
  average_sale NUMBER,
  total_sale NUMBER,
  num_transactions NUMBER
);

CREATE OR REPLACE TRIGGER UPDATE_SALES_LOC_3 
AFTER INSERT OR DELETE OR UPDATE ON SALES 
DECLARE
  CURSOR Sales_Loc_3_Cursor IS
  SELECT S.gid AS gid, 
         AVG( S.amount ) AS average_sale, 
         SUM( S.amount ) AS total_sale, 
         COUNT(*) AS num_transactions
  FROM Sales S, Games
  WHERE S.gid=Games.gid AND
        Games.sid=3
  GROUP BY S.gid;
BEGIN
  FOR Sales_Stat IN Sales_Loc_3_Cursor LOOP
    UPDATE Sales_Loc_3 
    SET average_sale=Sales_Stat.average_sale, 
        total_sale=Sales_Stat.total_sale, 
        num_transactions=Sales_Stat.num_transactions
    WHERE gid=Sales_Stat.gid;
    IF ( sql%rowcount = 0 ) THEN
      INSERT INTO Sales_Loc_3 
      VALUES ( Sales_Stat.gid, Sales_Stat.average_sale, Sales_Stat.total_sale, Sales_Stat.num_transactions );
    END IF;
  END LOOP;
END;

/* LOCATION 4 */
DROP TABLE Sales_Loc_4 CASCADE CONSTRAINTS;
CREATE TABLE Sales_Loc_4(
  gid NUMBER,
  average_sale NUMBER,
  total_sale NUMBER,
  num_transactions NUMBER
);

CREATE OR REPLACE TRIGGER UPDATE_SALES_LOC_4 
AFTER INSERT OR DELETE OR UPDATE ON SALES 
DECLARE
  CURSOR Sales_Loc_4_Cursor IS
  SELECT S.gid AS gid, 
         AVG( S.amount ) AS average_sale, 
         SUM( S.amount ) AS total_sale, 
         COUNT(*) AS num_transactions
  FROM Sales S, Games
  WHERE S.gid=Games.gid AND
        Games.sid=4
  GROUP BY S.gid;
BEGIN
  FOR Sales_Stat IN Sales_Loc_4_Cursor LOOP
    UPDATE Sales_Loc_4 
    SET average_sale=Sales_Stat.average_sale, 
        total_sale=Sales_Stat.total_sale, 
        num_transactions=Sales_Stat.num_transactions
    WHERE gid=Sales_Stat.gid;
    IF ( sql%rowcount = 0 ) THEN
      INSERT INTO Sales_Loc_4 
      VALUES ( Sales_Stat.gid, Sales_Stat.average_sale, Sales_Stat.total_sale, Sales_Stat.num_transactions );
    END IF;
  END LOOP;
END;