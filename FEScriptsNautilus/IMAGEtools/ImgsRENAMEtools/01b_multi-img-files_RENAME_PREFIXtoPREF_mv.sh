#!/bin/sh
##
## SCRIPT: 01b_multi-img-files_RENAME_PREFIXtoPREF_mv.sh
##
## PURPOSE: Changes the prefix on multiple ('.jpg') files.
##          Example: change prefix DSFC0 to D
##
## METHOD:  Uses 'zenity' to prompt user for the old and new prefixes.
##
## HOW TO USE: In Nautilus, select one or more image files, such as
##             '.jpg', '.png', '.gif', or other image files.
##             Then right-click and choose this script to run (name above).
##
###########################################################################
## Created: 2011mar28 based on '01c_multiRename_DSCF0toD.sh'
## Changed: 2011jul07 Changed to handle filenames with embedded spaces.
##                    (Removed use of FILENAMES var and use a 'for' loop
##                     WITHOUT the 'in' phrase.  Ref: man bash )
## Changed: 2012feb22 Changed default entry for $PREFIXES in zenity prompt.
## Changed: 2012may12 Touched up the comments above.
###########################################################################

## FOR TESTING: (show statements as they execute)
# set -x

############################################################
## Prompt for the old and new prefixes. 
############################################################

PREFIXES=""

PREFIXES=$(zenity --entry \
   --title "Enter OLD and NEW PREFIXES for renaming files." \
   --text "\
Enter OLD and NEW PREFIXES, separated by a space.
Example: DSCF0 D" \
   --entry-text "DSCF0 D")

if test "$PREFIXES" = ""
then
   exit
fi

PREFIX1=`echo "$PREFIXES" | cut -d' ' -f1`
PREFIX2=`echo "$PREFIXES" | cut -d' ' -f2`


####################################
## START THE LOOP on the filenames.
####################################

for FILENAME
do

   #################################################
   ## Get and check that file extension is 'jpg'. 
   ## Assumes one '.' in filename, at the extension.
   ##   COMMENTED for now.
   #################################################

   #  FILEEXT=`echo "$FILENAME" | cut -d\. -f2`

   #  if test "$FILEEXT" != "jpg" 
   #  then 
   #     continue
   #     # exit
   #  fi

   ############################################################
   ## Make the new filename and rename.
   ###########
   ## The '--' in 'mv' allows for filenames that start with '-'.
   ############################################################

   FILENAME2=`echo "$FILENAME" | sed "s|^$PREFIX1|$PREFIX2|"`

   mv -- "$FILENAME" "$FILENAME2"

done
## END OF LOOP: for FILENAME
