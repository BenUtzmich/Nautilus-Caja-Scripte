#!/bin/sh
##
## Nautilus
## SCRIPT: 00_multi-jpg-png-gif-files_RENAMEto_actualXXXxYYY_identify-mv.sh
##
## PURPOSE: Renames a set of selected image files ('.jpg' or '.png' or
##          '.gif') to contain the x-y pixel-size of the file.
## 
##          Example: joe.jpg  to  joe_640x480.jpg
##
## METHOD: Uses the ImageMagick 'identify' command to get the actual
##         x-y pixel-size of an image file and uses 'mv' to rename it.
##
## HOW TO USE: In Nautilus, select one or more '.jpg', '.png', or '.gif'
##             files.
##             Then right-click and choose this script to run (name above).
##
#########################################################################
## Created: 2010feb
## Changed: 2011jul07 Changed to handle filenames with embedded spaces.
##                    (Removed use of FILENAMES var and use a 'for' loop
##                     WITHOUT the 'in' phrase.  Ref: man bash )
## Changed: 2012jan23 Add a check to do each rename only if the new
##                    name is not already in use for an existing file.
## Changed: 2012may12 Changed script name in comments above and touched up
##                    the comments. Changed some indenting below.
###########################################################################

## FOR TESTING: (show statements as they execute)
#  set -x


#####################################
## START THE LOOP on the filenames.
#####################################

for FILENAME
do

   ################################################################
   ## Get and check that file extension is 'jpg' or 'png' or 'gif'. 
   ##     Assumes one '.' in filename, at the extension.
   ################################################################

   FILEEXT=`echo "$FILENAME" | cut -d\. -f2`

   if test "$FILEEXT" != "jpg" -a "$FILEEXT" != "png" -a "$FILEEXT" != "gif"
   then 
      continue
      # exit
   fi

   ########################################
   ## Get image size (XXXxYYY) of $FILENAME.
   ########################################

   IMGSIZE=`identify "$FILENAME" | head -1 | awk '{print $3}'`

   #####################################
   ## Get file prefix (strip extension).
   #####################################

   if test "$FILEEXT" = "jpg"
   then
      FILEPREF=`echo "$FILENAME" | sed 's|\.jpg$||'`
   fi

   if test "$FILEEXT" = "png"
   then
      FILEPREF=`echo "$FILENAME" | sed 's|\.png$||'`
   fi

   if test "$FILEEXT" = "gif"
   then
      FILEPREF=`echo "$FILENAME" | sed 's|\.gif$||'`
   fi

   #################################################
   ## Strip off suffix like _123...x123..._yadayada
   ##                    OR _XXXxYYY_yadayada
   ##                    OR _XXXx123..._yadayada
   #################################################

   FILEPREF=`echo "$FILEPREF" | sed 's|_[0-9X][0-9X]*x[0-9Y][0-9Y]*.*$||'`


   ####################################################
   ## Make the new filename --- with actual image size
   ## attached to the filename.
   ####################################################

   NEWFILENAME="${FILEPREF}_${IMGSIZE}.$FILEEXT"


   ####################################################
   ## Rename the selected file, if the new name is not
   ## already used for an existing file --- in the
   ## current directory.
   ####################################################

   if test ! -f "$NEWFILENAME"
   then
      mv "$FILENAME" "$NEWFILENAME"
   fi

done
## END OF 'for FILENAME' loop
