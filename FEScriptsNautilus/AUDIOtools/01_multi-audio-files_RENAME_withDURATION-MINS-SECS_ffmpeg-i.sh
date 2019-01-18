#!/bin/sh
##
## Nautilus
## SCRIPT: 00_multi-audio-files_RENAME_withDURATION-MINS-SECS_ffmpeg-i.sh
##
## PURPOSE: Renames a set of selected audio files (esp. '.mp3' files)
##          to contain the duration info in the filename --- hh:mm:ss.
## 
##          Example: joe.jpg  to  joe_00:03:13.jpg
##
## METHOD: Uses the 'ffmpeg' command to get the duration
##         and uses 'mv' to rename it.
##
## HOW TO USE: In Nautilus, select one or more '.mp3' (or whatever)
##             audio files.
##             Then right-click and choose this script to run (name above).
##
#########################################################################
## Created: 2013mar05
## Changed: 2013
###########################################################################

## FOR TESTING: (show statements as they execute)
#  set -x


#####################################
## START THE LOOP on the filenames.
#####################################

for FILENAME
do

   ################################################################
   ## Get and check that file extension is 'mp3' or 'wav' or other. 
   ##     Assumes one '.' in filename, at the extension.
   ################################################################

   FILEEXT=`echo "$FILENAME" | cut -d\. -f2`

   if test "$FILEEXT" != "mp3" -a "$FILEEXT" != "wav"
   then 
      continue
      # exit
   fi

   ########################################
   ## Get duration (hh:mm:ss) of $FILENAME.
   ########################################

   DURATION=` ffmpeg -i  "$FILENAME" 2>&1 |grep Duration|cut -d, -f1|awk '{print $2}'|cut -d. -f1`


   #####################################
   ## Get file prefix (strip extension).
   #####################################

   if test "$FILEEXT" = "mp3"
   then
      FILEPREF=`echo "$FILENAME" | sed 's|\.mp3$||'`
   fi

   if test "$FILEEXT" = "wav"
   then
      FILEPREF=`echo "$FILENAME" | sed 's|\.wav$||'`
   fi

   ## Alternative:
   # FILEEXT=`echo "$FILENAME" | cut -d\. -f1`


   #################################################
   ## Strip off suffix like _99:99:99_yadayada
   ##                    OR _XX:YY:ZZ_EDITcrop
   #################################################

   FILEPREF=`echo "$FILEPREF" | sed 's|_[0-9X][0-9X]:[0-9Y][0-9Y]:[0-9Z][0-9Z].*$||'`


   ####################################################
   ## Make the new filename --- with actual image size
   ## attached to the filename.
   ####################################################

   NEWFILENAME="${FILEPREF}_${DURATION}.$FILEEXT"


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
