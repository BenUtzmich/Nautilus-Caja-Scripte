#!/bin/sh
##
## Nautilus
## SCRIPT: 00_multiFiles_RENAME_ADDsuffix_mv.sh
##
## PURPOSE: Adds a user-specified suffix to the names of
##          the user-selected files.
##
## METHOD:  Uses 'zenity' to prompt for the suffix.
##          Uses the 'mv' command, in a loop, for the renames.
##
## HOW TO USE: In Nautilus, select one or more files in a directory.
##             (The selected files can be directories.)
##             Right click and, from the 'Scripts >' submenus,
##             choose to run this script (name above).
##
## UNDO NOTE: 
##       If you accidentally rename the file(s) wrongly, you can usually
##       rename it/them back, by removing (or changing) the suffix ---
##       using another feNautilusScript 'CHANGEfiles' tool.
##
## Created: 2010aug22
## Changed: 2011jul07 Changed to handle filenames with embedded spaces.
##                    (Removed use of FILENAMES var and we use a 'for' loop
##                     WITHOUT the 'in' phrase.  Ref: man bash )
## Changed: 2012feb13 Changed script name. Added the 'HOW TO USE' section
##                    above. Added to the 'METHOD' section above.
##                    Changed the indenting below.

## FOR TESTING: (show statements as they execute)
# set -x


###########################################
## Prompt for the suffix for the filenames. 
###########################################

FILESUFFIX=""

FILESUFFIX=$(zenity --entry \
   --title "Enter a SUFFIX to add to filename(s)." \
   --text "\
Enter a suffix for the new filename(s) of the selected file(s).
Examples:
      .txt   OR   __2010aug22   OR   __OBSOLETE   OR   __OLD

This suffix will be added after an 'extension' on the filename,
if any." \
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

   ###################################################
   ## Use 'mv' to rename the file.
   ###################################################
   ## The '--' handles filenames that start with '-'.
   ## It avoids the 'invalid option' error.
   ##################################################

   mv -- "$FILENAME" "${FILENAME}$FILESUFFIX"
   
done




