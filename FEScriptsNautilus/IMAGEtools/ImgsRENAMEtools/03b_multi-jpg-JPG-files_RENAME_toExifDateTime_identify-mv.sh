#!/bin/sh
##
## Nautilus
## SCRIPT: 03b_multi-jpg-JPG-files_RENAME_toExifDateTime_identify-mv.sh
##
## PURPOSE: Renames a set of selected '.jpg' (or '.JPG') files to contain
##          date-time --- in the form from the 'identify' command,
##          the 'exif:DateTimeOriginal: line --- but with the colons
##          replaced by hyphens.
##
##          Example:
##                  exif:DateTimeOriginal: 2011:03:04 13:42:07
##            gives
##                  2011-03-04_13-42-07
##
## METHOD: Uses ImageMagick 'identify' to get the EXIF date-time data.
##         Uses 'mv' to do the rename.
##
## HOW TO USE: In Nautilus, select one or more '.jpg' or '.JPG' files.
##             Then right-click and choose this script to run (name above).
##
#########################################################################
## Created: 2011mar26
## Changed: 2011jul07 Changed to handle filenames with embedded spaces.
##                    (Removed use of FILENAMES var and use a 'for' loop
##                     WITHOUT the 'in' phrase.  Ref: man bash )
## Changed: 2012may12 Changed script name in comments above and touched up
##                    the comments. Changed some indenting below.
## Changed: 2012jul12 Fixed setting of FILEPREF when suffix is '.JPG'.
###########################################################################

## FOR TESTING: (show statements as they execute)
# set -x


###################################
## START THE LOOP on the filenames.
###################################

for FILENAME
do

   #######################################################
   ## Get and check that file extension is 'JPG' or 'jpg'. 
   ## Assumes one '.' in filename, at the extension.
   #######################################################

   FILEEXT=`echo "$FILENAME" | cut -d\. -f2`

   if test "$FILEEXT" != "jpg" -a "$FILEEXT" != "JPG"
   then
      continue
      # exit
   fi

   ########################################
   ## Get and apply the file date and time.
   ########################################

   FILEDATE=`identify -verbose "$FILENAME" | grep 'exif:DateTimeOriginal:' | \
            awk '{print $2}' | sed 's|:|-|g'`

   FILETIME=`identify -verbose "$FILENAME" | grep 'exif:DateTimeOriginal:' | \
            awk '{print $3}' | sed 's|:|-|g'`

   FILEPREF=`echo "$FILENAME" | sed 's|\.JPG$||'`
   FILEPREF=`echo "$FILEPREF" | sed 's|\.jpg$||'`

   mv -- "$FILENAME" "${FILEPREF}_${FILEDATE}_${FILETIME}.$FILEEXT"

done
## END OF 'for FILENAME' loop
