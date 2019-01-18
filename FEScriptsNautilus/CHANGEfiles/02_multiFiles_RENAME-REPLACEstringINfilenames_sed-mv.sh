#!/bin/sh
##
## Nautilus
## SCRIPT: 02_multiFiles_RENAME_REPLACEstringINfilenames_sed-mv.sh
##
## PURPOSE: REPLACES a user-specified string in the filename(s) of
##          the user-selected file(s) --- with another user-specified string.
##
## METHOD:  Uses 'zenity' to prompt for the two strings.
##          In a for-loop,
##             1) uses 'sed' to do the string replacement in each selected
##              filename
##          and
##             2) uses 'mv' to do the rename of each selected file.
##
## HOW TO USE: In Nautilus, select one or more files in a directory.
##             (The selected files can be directories.)
##             Right click and, from the 'Scripts >' submenus,
##             choose to run this script (name above).
##
## UNDO NOTE:
##       If you accidentally rename the file(s) wrongly, you can usually
##       rename it/them back, by using this same script.
##
## Created: 2011jun25
## Changed: 2011jul07 Changed to handle filenames with embedded spaces.
##                    (Removed use of FILENAMES var and we use a 'for' loop
##                     WITHOUT the 'in' phrase.  Ref: man bash )
## Changed: 2012feb13 Changed script name. Added the 'HOW TO USE' section
##                    above. Added to the 'METHOD' section above.
##                    Changed the indenting below.

## FOR TESTING: (show statements as they execute)
#  set -x


###########################################
## Prompt for the two strings --- the 'from'
## and 'to' strings --- to replace and
## replace-with in the filename(s). 
###########################################

STRINGS1and2=""

STRINGS1and2=$(zenity --entry \
   --title "Enter 2 strings --- old and new." \
   --text "\
Enter the 'to-be-replaced' string and the 'replacement' string ---
for the filename(s) of the selected file(s).

Separate the 2 strings by a space.
(This assumes no embedded spaces in the 2 strings.)
Examples:
      Album WeStartedNothing
      Artist TingTings" \
   --entry-text "")

if test "$STRINGS1and2" = ""
then
   exit
fi

STRING1=`echo "$STRINGS1and2" | cut -d' ' -f1`
STRING2=`echo "$STRINGS1and2" | cut -d' ' -f2`


###################################
## START THE LOOP on the filenames.
###################################

for FILENAME
do

   ## FOR TESTING: (show statements as they execute)
   #  set -x

   ##################################################
   ## Use 'sed' to make the new filename.
   ##  (We replace the first occurrence of STRING1
   ##   in the filename. Could use 'g' to replace all.)
   ##################################################

   NEWFILENAME=`echo "$FILENAME" | sed "s|${STRING1}|${STRING2}|"`

   ##################################################
   ## Use 'mv' to rename the file.
   ##################################################
   ## The '--' handles filenames that start with '-'.
   ## It avoids the 'invalid option' error.
   ##################################################

   mv -- "$FILENAME" "$NEWFILENAME"
 
   ## FOR TESTING: (turn off 'set -x')
   #  set -
  
done
## END OF LOOP: for FILENAME



