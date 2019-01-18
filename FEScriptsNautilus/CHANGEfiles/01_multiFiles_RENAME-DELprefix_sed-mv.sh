#!/bin/sh
##
## Nautilus
## SCRIPT: 00_multiFiles_RENAME_DELprefix_sed-mv.sh
##
## PURPOSE: DELETES a user-specified prefix from the name(s) of
##          the user-selected file(s).
##
## METHOD:  Uses 'zenity' to prompt for the prefix to delete.
##          In a for-loop,
##             1) uses 'sed' to make the new filename for each file,
##          and
##             2) uses 'mv' to rename each file.
##
## HOW TO USE: In Nautilus, select one or more files in a directory.
##             (The selected files can be directories.)
##             Right click and, from the 'Scripts >' submenus,
##             choose to run this script (name above).
##         
## UNDO NOTE:
##       If you accidentally rename the file(s) wrongly, you can usually
##       rename it/them back, by adding the removed prefix ---
##       using the 'ADDprefix' feNautilusScript in the 'CHANGEfiles' group.
##
## Created: 2010sep06
## Changed: 2011jun25 Fix 'sed' statement that makes new filename(s).
## Changed: 2011jul07 Changed to handle filenames with embedded spaces.
##                    (Removed use of FILENAMES var and we use a 'for' loop
##                     WITHOUT the 'in' phrase.  Ref: man bash )
## Changed: 2012feb13 Changed script name. Added the 'HOW TO USE' section
##                    above. Added to the 'METHOD' section above.
##                    Changed the indenting below.

## FOR TESTING: (show statements as they execute)
# set -x


###########################################
## Prompt for the prefix to remove from
## the filename(s). 
###########################################

FILEPREFIX=""

FILEPREFIX=$(zenity --entry \
   --title "Enter PREFIX to REMOVE from filenames." \
   --text "\
Enter a prefix to REMOVE from the filenames of the selected files.
Examples:
     PREP_   OR   DSC00   OR   Kevin-" \
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

  ## FOR TESTING: (show statements as they execute)
  #  set -x

  ######################################
  ## Use 'sed' to make the new filename.
  ######################################

  NEWFILENAME=`echo "$FILENAME" | sed "s|^${FILEPREFIX}||"`

  ##################################################
  ## Use 'mv' to rename the file.
  ## The '--' handles filenames that start with '-'.
  ## It avoids the 'invalid option' error.
  ##################################################

   mv -- "$FILENAME" "$NEWFILENAME"

  ## FOR TESTING: (turn off 'set -x')
  #  set -

done
## END OF LOOP: for FILENAME



