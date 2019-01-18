#!/bin/sh
##
## Nautilus
## SCRIPT: 01_multiFiles_RENAME_DELsuffix_sed-mv.sh
##
## PURPOSE: DELETES a user-specified suffix from the name(s) of
##          the user-selected file(s).
##
## METHOD:  Uses 'zenity' to prompt for the suffix to delete.
##          In a for-loop,
##             1) uses 'sed' to remove the suffix on each selected file
##          and
##             2) uses 'mv' to rename each selected file.
##
## HOW TO USE: In Nautilus, select one or more files in a directory.
##             (The selected files can be directories.)
##             Right click and, from the 'Scripts >' submenus,
##             choose to run this script (name above).
##
## UNDO NOTE:
##       If you accidentally rename the file(s) wrongly, you can usually
##       rename it/them back, by adding the removed suffix --- using
##       an 'ADDsuffix' feNautilusScript in the 'CHANGEfiles' group.
##
## Created: 2010sep06
## Changed: 2011jun25 Fix the 'sed' statement that makes the new filename(s).
## Changed: 2011jul07 Changed to handle filenames with embedded spaces.
##                    (Removed use of FILENAMES var and we use a 'for' loop
##                     WITHOUT the 'in' phrase.  Ref: man bash )
## Changed: 2012feb13 Changed script name. Added the 'HOW TO USE' section
##                    above. Added to the 'METHOD' section above.
##                    Changed the indenting below.

## FOR TESTING: (show statements as they execute)
# set -x


###########################################
## Prompt for the suffix to remove from
## the filename(s). 
###########################################

FILESUFFIX=""

FILESUFFIX=$(zenity --entry \
   --title "Enter SUFFIX to REMOVE from filename(s)." \
   --text "\
Enter a suffix to REMOVE from the filename(s) of the selected file(s).
Examples:
   __ORIG   OR  __2010aug22   OR   .sh

NOTE: This utility removes the suffix from the very end of each filename,
after or including a file 'extension', if any." \
   --entry-text "")

if test "$FILESUFFIX" = ""
then
   exit
fi


###################################
## START THE LOOP on the filenames.
###################################

for FILENAME
do

   ## FOR TESTING: (show statements as they execute)
   # set -x

   ######################################
   ## Use 'sed' to make the new filename.
   ######################################

   NEWFILENAME=`echo "$FILENAME" | sed "s|${FILESUFFIX}$||"`

   ###################################################
   ## Use 'mv' to rename the file.
   ###################################################
   ## The '--' handles filenames that start with '-'.
   ## It avoids the 'invalid option' error.
   ###################################################

   mv -- "$FILENAME" "$NEWFILENAME"

   ## FOR TESTING: (turn off 'set -x')
   # set -

done
## END OF LOOP: for FILENAME



