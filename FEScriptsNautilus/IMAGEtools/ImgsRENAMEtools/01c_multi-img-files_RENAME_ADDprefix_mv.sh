#!/bin/sh
##
## SCRIPT: 01c_multi-img-files_RENAME_ADDprefix_mv.sh
##
## PURPOSE: Adds a user-specified prefix to the names of
##          the user-selected files.
##
## METHOD:  Uses 'zenity --entry' to prompt for the prefix.
##          Uses 'mv' to do the rename.
##
## NOTE: If you accidentally rename the wrong file(s), you can simply
##       rename it/them back, by removing the prefix.
##
########################################################################
## Created: 2010may19
## Changed: 2011jul07 Changed to handle filenames with embedded spaces.
##                    (Removed use of FILENAMES var and use a 'for' loop
##                     WITHOUT the 'in' phrase.  Ref: man bash )
## Changed: 2012may12 Changed script name in comments above and touched up
##                    the comments. Changed some indenting below.
###########################################################################

## FOR TESTING: (show statements as they execute)
# set -x

############################################
## Prompt for the prefix for the filenames. 
############################################

FILEPREFIX=""

FILEPREFIX=$(zenity --entry \
   --title "Enter PREFIX to add to filenames." \
   --text "\
Enter a prefix for the new filenames of the selected files. Examples:
      Vacation2010may_  OR  Kevin-  OR  GrandCanyon_  OR Birthday2009_" \
   --entry-text "")

if test "$FILEPREFIX" = ""
then
   exit
fi


####################################
## START THE LOOP on the filenames.
####################################

for FILENAME
do

  ##############################################
  ## Use 'convert' to make the resized jpg file.
  ##############################################

   mv "$FILENAME" "${FILEPREFIX}$FILENAME"
   
done
## END OF 'for FILENAME' loop
