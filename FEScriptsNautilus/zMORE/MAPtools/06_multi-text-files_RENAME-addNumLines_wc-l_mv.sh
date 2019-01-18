#!/bin/sh
##
## Nautilus
## SCRIPT: 06_multi-text-files_RENAME-addNumLines_wc-l_mv.sh
##
## PURPOSE: Renames a set of selected text files (best not to use
##          this on 'binary' files) so that each filename contains
##          the number of lines in the file.
## 
##          Example: joe.txt  to  joe_640lines.txt
##
## METHOD: Uses the 'wc' Word-and-line count) command to get the number
##         of lines in each file and uses 'mv' to rename it.
##
## HOW TO USE: In Nautilus, select one or more text files.
##             Then right-click and choose this script to run (name above).
##
#########################################################################
## Created: 2016nov09 Based on FE 'Nautilus Script' in the IMAGEtools group
##          '00_multi-jpg-png-gif-files_RENAMEto_actualXXXxYYY_identify-mv.sh'.
## Changed: 2016
###########################################################################

## FOR TESTING: (show statements as they execute)
#  set -x


#####################################
## START THE LOOP on the filenames.
#####################################

for FILENAME
do

   ################################################################
   ## Get the file extension --- such as 'txt' 'lis' 'log' ... 
   ##     Assumes one '.' in filename, at the extension.
   ################################################################

   FILEEXT=`echo "$FILENAME" | cut -d\. -f2`

   ## Could check the extension, and skip files with certain extensions.
   ## But this is too restrictive. We may use the 'file' command someday
   ## to skip files that appear to be binary files rather than text files.

   # if test "$FILEEXT" != "txt" -a "$FILEEXT" != "lis" -a "$FILEEXT" != "log"
   # then 
   #    continue
   #    # exit
   # fi

   ########################################
   ## Get number of lines in file $FILENAME.
   ########################################

   NUMLINES=`wc -l "$FILENAME"| cut -d' ' -f1`

   #####################################
   ## Get the 'midname' of the filename ---
   ## the part before the extension.
   #####################################

   MIDNAME=`echo "$FILENAME" | cut -d\. -f1`


   ####################################################
   ## Make the new filename --- with actual the
   ## number-of-lines in the new filename.
   ####################################################

   NEWFILENAME="${MIDNAME}_${NUMLINES}lines.$FILEEXT"


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
