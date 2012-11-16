drop table CSE880Images;
create table CSE880Images (
   image_name varchar2(255) primary key,
   image ORDSYS.ORDImage,
   image_sig ORDSYS.ORDImageSignature
);

/*
NOTE, Need to run the following as the SYSDBA prior to running this script:

create or replace directory IMAGE_DIR as 'C:\Path\To\Image\Dir';
grant read on directory IMAGE_DIR to SYSTEM;

*/

set serverout on

declare
   buffer varchar2(255);
   num_of_images number;
   fh utl_file.file_type;
   tmp_Image ORDSYS.ORDImage;
   ctx RAW(4000) := NULL;
begin
   -- remove old images
   delete from CSE880Images;
   -- open the list file

   DBMS_OUTPUT.put_line( 'Finished deleting' );

   --  - An example for creating a directory path:
   fh := utl_file.fopen( 'IMAGE_DIR', 'list.dat', 'r' );
   -- read number of images to be inserted
   utl_file.get_line(fh, buffer);
   num_of_images := to_number(buffer);
   -- insert images one by one
   for i in 1..num_of_images loop
      
      -- read image name
      utl_file.get_line(fh, buffer);
      -- insert image and its content
      DBMS_OUTPUT.put_line( buffer );
      
      INSERT INTO CSE880Images VALUES ( 
         buffer,
         ORDSYS.ORDImage.init(),
         ORDSYS.ORDImageSignature.init()
      );

      SELECT image into tmp_Image
      FROM CSE880Images
      WHERE image_name = buffer
      
      for UPDATE;
      
      tmp_Image.setSource( 'file', 'IMAGE_DIR', buffer );
      tmp_Image.import(ctx);
      
      UPDATE CSE880Images SET image = tmp_Image WHERE image_name = buffer;
      
      -- info
      dbms_output.put_line(i);
   end loop;
   commit;
   
   -- close the list file
   utl_file.fclose(fh);
end;
/

