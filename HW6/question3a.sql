-- 3.a
-- categories:
--  1. image11.jpg - color orange
--  2. image2.jpg - stripes
--  3. image17.jpg - similar faces
--  4. image9.jpg - similar environment
   
set serveroutput on;

begin
   DBMS_OUTPUT.put_line( 'Category 1: 5 closest neighbors to image11.jpg based on color orange' );
end;
/

SELECT * 
FROM ( 
   SELECT I2.image_name, ORDImageSignature.evaluateScore( I1.image_sig, I2.image_sig, 'color=1.0' ) Feature_Distance
   FROM cse880images I1, cse880images I2
   WHERE I1.image_name='image11.jpg' AND
         I1.image_name <> I2.image_name
   ORDER BY Feature_Distance
)
WHERE rownum <= 5;

begin
   DBMS_OUTPUT.put_line( 'Category 2: 5 closest neighbors to image2.jpg based on stripes texture' );
end;
/

SELECT * 
FROM ( 
   SELECT I2.image_name, ORDImageSignature.evaluateScore( I1.image_sig, I2.image_sig, 'shape=1.0, texture=1.0, location=0.1' ) Feature_Distance
   FROM cse880images I1, cse880images I2
   WHERE I1.image_name='image2.jpg' AND
         I1.image_name <> I2.image_name
   ORDER BY Feature_Distance
)
WHERE rownum <= 5;

begin
   DBMS_OUTPUT.put_line( 'Category 3: 5 closest neighbors to image17.jpg based on face shape' );
end;
/

SELECT * 
FROM ( 
   SELECT I2.image_name, ORDImageSignature.evaluateScore( I1.image_sig, I2.image_sig, 'shape=1.0, texture=0.3, location=0.1' ) Feature_Distance
   FROM cse880images I1, cse880images I2
   WHERE I1.image_name='image17.jpg' AND
         I1.image_name <> I2.image_name
   ORDER BY Feature_Distance
)
WHERE rownum <= 5;

begin
   DBMS_OUTPUT.put_line( 'Category 4: 5 closest neighbors to image9.jpg based on surrounding environment' );
end;
/

SELECT * 
FROM ( 
   SELECT I2.image_name, ORDImageSignature.evaluateScore( I1.image_sig, I2.image_sig, 'shape=0.5, texture=0.6, location=1.0, color=0.9' ) Feature_Distance
   FROM cse880images I1, cse880images I2
   WHERE I1.image_name='image9.jpg' AND
         I1.image_name <> I2.image_name
   ORDER BY Feature_Distance
)
WHERE rownum <= 5;
