#!/bin/sh
##
## Nautilus
## SCRIPT: 06_multiFiles_CHG-STRING-WITHIN_cp-bkup_sed.sh
##
## PURPOSE: For each of the user-selected files, the file contents
##          are scanned via the 'sed' utility and a user-specified
##          string is replaced, throughout the file, with a second
##          user-specified string.
##
## METHOD:  Each selected file is renamed to have an '_${MINS}$SECS'
##          minutes-seconds suffix, and the 'changed-string' file
##          (copied from the original file) ends up in a file with
##          the original filename. Hence, a backup is preserved.
##
##          Uses 'zenity' (twice) to prompt for the 'from' and 'to' strings.
##          (Using two prompts facilitates allowing for spaces in the 2 strings.)
##
##          In a for-loop,
##            1) uses 'cp -p' to make the '_${MINS}$SECS'-suffix backup
##               of each original file (The '-p' preserves the time stamps.)
##          and
##            2) uses 'sed' to make the string changes in each original file.
##               (Note: The 'string-changed' file has the original filename.)
##
## HOW TO USE: In Nautilus, select one or more (text) files in a directory.
##             (The selected files should NOT be directories.)
##             Right click and, from the 'Scripts >' submenus,
##             choose to run this script (name above).
##
## UNDO NOTE:
##        If a mistake has been made and the user wishes to remove
##        the new file copies that have been made and 'go back' to
##        the originals, the user can avoid manually recovering.
##        In Nautilus:
##        1)  Select and delete (or batch rename) the copied files.
##        2)  Select the '_${MINS}$SECS' files and apply a 'DELsuffix' or
##            'CHGstringINfilenames' utility in the 'CHANGEfiles'
##            group of feNautilusScripts.
##
## LARGE BATCH NOTE: 
##       Use with care. The user should apply the change to one or two
##       files first. If that goes OK, then the user could do the rest
##       of the files in a large batch (or several large batches).
##
## DISK SPACE NOTE:
##       If the user applies this utility to large numbers of files or to
##       some very large files, the user may use up a lot of disk space ---
##       for the '_${MINS}$SECS' backups of the originals. This should be taken
##       into consideration. One techinque is do 'small' batches at a time.
##
## Created: 2010sep06
## Changed: 2011may02 Add $USER to a temp filename.
## Changed: 2011jul07 Changed to handle filenames with embedded spaces.
##                    (Removed use of FILENAMES var and we use a 'for' loop
##                     WITHOUT the 'in' phrase.  Ref: man bash )
## Changed: 2012feb13 Changed script name. Added the 'HOW TO USE'
##                    section. Added to the 'METHOD' section.
##                    Added the 'DISK SPACE NOTE' section above.
##                    Touched up the 'UNDO' & 'LARGE BATCH' NOTE sections above.
##                    Touched up text in the 2 'zenity' prompts below.
##                    Touched up indenting below. Added a check below to
##                    skip any $FILENAME that is a directory.

## FOR TESTING: (show statements as they execute)
# set -x

############################################
## Prompt for the 'from' string. 
############################################

STR1=""

STR1=$(zenity --entry \
   --title "Enter the 'from' STRING." \
   --text "\
Enter a string to change in the selected files.
Examples:
      VIEWER
   OR
      } else (

NOTE: The original data file(s) will be put in file(s) of the same name BUT
with a minutes-seconds SUFFIX ADDED. The changed data will be in
file(s) with the original filename(s)." \
   --entry-text "")

if test "$STR1" = ""
then
   exit
fi


############################################
## Prompt for the 'to' string. 
############################################

STR2=""

STR2=$(zenity --entry \
   --title "Enter the 'to' STRING." \
   --text "\
'FROM' STRING: $STR1

Enter the 'TO' string for the selected files.
Examples:
      TXTVIEWER   to replace   VIEWER
   OR
      } else {    to replace   } else (" \
   --entry-text "")

if test "$STR2" = ""
then
   exit
fi


#############################################
## START THE LOOP on the selected filename(s).
#############################################

for FILENAME
do

   ###############################################
   ## Skip the selected file if it is a directory.
   ###############################################

   if test -d "$FILENAME"
   then
      # exit
      continue
   fi


   ###################################
   ## Use 'cp -p' to backup the file,
   ## preserving timestamps.
   ###################################

   SECS=`date +%S`
   MINS=`date +%M`
   BKUPNAME="${FILENAME}_${MINS}${SECS}"

   while test -f "$BKUPNAME"
   do
      sleep 1
      SECS=`date +%S`
      MINS=`date +%M`
      BKUPNAME="${FILENAME}_${MINS}${SECS}"
   done

   cp -p "$FILENAME" "$BKUPNAME"

   #########################################
   ## Use 'sed' to change the file contents
   ## 'in place'.
   #########################################

   ## FOR TESTING:
   #   set -x

   ## Could run the command in a window, for each file,
   ## to see err msgs, if any.
   ## Could use zenity to offer this as an option.
   # xterm -fg white -bg black -hold -e \

   sed -i -e s/"$STR1"/"$STR2"/g "$FILENAME"

   ## OTHER ATTEMPTS: (failed??)
   # eval "sed -i -e 's|$STR1|$STR2|g' \"$FILENAME\" "
   # sed -i -e "s/$STR1/$STR2/g" "$FILENAME"

   ## FOR TESTING:
   #   set -

done
## END OF LOOP: for FILENAME

