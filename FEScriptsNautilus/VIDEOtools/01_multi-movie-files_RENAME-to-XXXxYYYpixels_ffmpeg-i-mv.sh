#!/bin/sh
##
## Nautilus
## SCRIPT: 01_multi-movie-files_RENAME_toXXXxYYYpixels_ffmpeg-i-mv.sh
##
## PURPOSE: Renames a set of selected video files ('.mpg' or '.wmv' or
##          '.flv' or whatever) to contain the x-y pixel-size of the file.
##          Uses 'ffmpeg -i' with grep and awk.
##
##          Example: joe.mpg  to  joe_Nsec_640x480.mpg
##
## METHOD:  There is no prompt for parameters.
##
##          Uses 'ffmpeg -i' to get the pixel size of each selected file.
##          Uses 'grep', 'awk', and 'sed' to extract the pixel size from the
##          appropriate line of text --- one containing the strings
##          'Stream' and 'Video:'.
##
##          Uses 'mv' to do the rename of the input file(s).
##
##          NOTE on OUTPUT FILE NAMING:
##          We put '_Nsec' in the filename to remind the user to put
##          file duration in the filename after editing the video.
##          (Often one will trim the length of the video.)
##
## HOW TO USE: In Nautilus, select one or more movie files.
##             Then right-click and choose this script to run (name above).
##
############################################################################
## Created: 2011dec08
## Changed: 2012may22 Changed script name in comments above and touched up
##                    the comments. Changed some indenting below.
############################################################################

## FOR TESTING: (show statements as they execute)
#  set -x


#####################################
## START THE LOOP on the filenames.
#####################################

for FILENAME
do

   ################################################################
   ## Get the file extension. 
   ##     Assumes one '.' in filename, at the extension.
   ################################################################

   FILEEXT=`echo "$FILENAME" | cut -d\. -f2`

   ################################################################
   ## Check that file extension is 'mpg' or 'wmv' or 'flv'
   ## or other. 
   ##     Assumes one '.' in filename, at the extension.
   ## COMMENTED, for now.
   ################################################################

   # if test "$FILEEXT" != "mpg" -a "$FILEEXT" != "wmv" -a "$FILEEXT" != "flv"
   # then 
   #    continue
   #    # exit
   # fi

   ##########################################
   ## Get filesize (XXXxYYY).
   ##  (Skip the file if FILESIZE is empty.)
   ##########################################

   FILESIZE=`ffmpeg -i "$FILENAME" 2>&1 | grep 'Stream' | grep 'Video:' | \
           awk '{print $6}' | sed 's|,||'`

   if test "$FILESIZE" = ""
   then 
      continue
      # exit
   fi


   ###############################################
   ## Get file prefix (strip extension).
   ##    Assumes one period (.) in the filename,
   ##    at the extension.
   ################################################

   ##  FILEPREF=`echo "$FILENAME" | sed 's|\.mpg$||'`


   ## Strip off ending chars like _123...x123..._yadayada.mpg
   ##                          OR _XXXxYYY_yadayada.wmv
   ##                          OR _XXXx123..._yadayada.flv

   # FILEPREF=`echo "$FILENAME" | sed 's|_[0-9X][0-9X]*x[0-9Y][0-9Y]*.*$||'`


   ## Strip off extension. (Assumes one period in filename.)
   ##
   ##   [We could use something like
   ##         grep '\..*\.'
   ##    to skip the file if more than one period is in the filename.]

   FILEPREF=`echo "$FILENAME" | sed 's|\..*$||'`

   ####################################################
   ## Rename the file to include its size in the name.
   ####################################################

   mv "$FILENAME" "${FILEPREF}_Nsec_${FILESIZE}.$FILEEXT"

done
## END OF 'for FILENAME' loop.
