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
