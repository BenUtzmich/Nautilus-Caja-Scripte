#!/bin/sh
##
## Nautilus
## SCRIPT: 00_multiFiles_RENAME_ADDprefix_mv.sh
##
## PURPOSE: Adds a user-specified prefix to the names of
##          the user-selected files.
##
## METHOD:  Uses 'zenity' to prompt for the prefix.
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
#############################################################################
## Created: 2010may19
## Changed: 2011jul07 Changed to handle filenames with embedded spaces.
##                    (Removed use of FILENAMES var and we use a 'for' loop
##                     WITHOUT the 'in' phrase.  Ref: man bash )
## Changed: 2012feb13 Changed script name. Added the 'HOW TO USE'
##                    section. Added to the 'METHOD' section.
##                    Changed the indenting below.
## Changed: 2012jun04 Removed some null lines at bottom of script.
#############################################################################

## FOR TESTING: (show statements as they execute)
# set -x


############################################
## Prompt for the prefix for the filenames. 
############################################

FILEPREFIX=""

FILEPREFIX=$(zenity --entry \
   --title "Enter PREFIX to add to filenames." \
   --text "\
Enter a prefix for the new filenames of the selected files.
Examples:
      Vacation2010may_  OR  Kevin-  OR  GrandCanyon_  OR Birthday2009_" \
   --entry-text "")

if test "$FILEPREFIX" = ""
then
   exit
fi


###################################
## START THE LOOP on the filenames.
###################################

for FILENAME
do

  ##################################################
  ## Use 'mv' to rename the file.
  ##################################################
  ## The '--' handles filenames that start with '-'.
  ## It avoids the 'invalid option' error.
  ##################################################

   mv -- "$FILENAME" "${FILEPREFIX}$FILENAME"
   
done
## END OF 'for FILENAME' loop.
