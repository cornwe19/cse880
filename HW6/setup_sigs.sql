CREATE OR REPLACE Procedure PREPARE_IMG_SIGS
IS
   tmp_Image ORDSYS.ORDImage;
   Img_sig ORDSYS.ORDImageSignature;

   CURSOR c1 IS
   SELECT Image_name FROM cse880images;

BEGIN
   FOR current_record in c1
   LOOP
       DBMS_OUTPUT.PUT_LINE(current_record.image_name); 
    
       SELECT Image, Image_sig INTO tmp_Image, Img_sig FROM cse880images WHERE Image_name = current_record.image_name FOR UPDATE;
 
       --Properties
       tmp_Image.setProperties;
       
       --Signature
       Img_sig.generateSignature(tmp_Image);
       
       UPDATE cse880images SET Image = tmp_Image, Image_sig = Img_sig WHERE image_name = current_record.image_name;
       COMMIT;

   END LOOP;
   
   CLOSE c1;

EXCEPTION
WHEN OTHERS THEN
   raise_application_error(-20001,'An error was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);
END;
/

SET SERVEROUTPUT ON;
  
EXECUTE PREPARE_IMG_SIGS;

SELECT * FROM cse880images;

