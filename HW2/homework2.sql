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