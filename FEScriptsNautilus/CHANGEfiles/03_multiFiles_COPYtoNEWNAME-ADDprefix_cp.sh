#!/bin/sh
##
## Nautilus
## SCRIPT: 03_multiFiles_COPY-ADDprefix_cp.sh
##
## PURPOSE: Copy the user-selected files to new filenames that
##          have a user-specified prefix added to the original filenames.
##
## METHOD:  Uses 'zenity' to prompt for the prefix.
##          In a for-loop, uses 'cp' to copy each file to its new name.
##
## HOW TO USE: In Nautilus, select one or more files in a directory.
##             (The selected files should NOT be directories.)
##             Right click and, from the 'Scripts >' submenus,
##             choose to run this script (name above).
##
## WRONG-NAME(S) NOTE:
##       If the user accidentally ends up with wrong filenames for the new
##       file-copies, the user can simply delete the new files and try
##       the copy again. Or use one of the 'RENAME' utilities in the
##       feNautilusScripts 'CHANGEfiles' group of scripts.
##
## DISK SPACE NOTE:
##       If the user copies large numbers of files or some very large files,
##       the user may use up a lot of disk space. This should be taken
##       into consideration. One techinque is do 'small' batches at a time.
##
## Created: 2012feb13 Based on '03_multiFiles_COPY-ADDsufffix_cp.sh'.
## Changed: 2012

## FOR TESTING: (show statements as they execute)
# set -x

###########################################
## Prompt for the prefix for the filenames. 
###########################################

FILEPREFIX=""

FILEPREFIX=$(zenity --entry \
   --title "Enter PREFIX to use for copied filenames." \
   --text "\
Enter a COMMON PREFIX for the new filenames, for the copies
of the selected files.
Examples:
  __BKUP  OR   .txt   OR   __2010aug22   OR   __OBSOLETE   OR   __OLD

Warning: Take disk space into consideration if you selected many files
or some very large files." \
   --entry-text "_BKUP")

if test "$FILEPREFIX" = ""
then
   exit
fi


###################################
## START THE LOOP on the filenames.
###################################

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


   ####################################
   ## Use 'cp' to make the file copies.
   ####################################
   ## '--' allows for filenames that
   ## start with '-'.
   ####################################

   cp -- "$FILENAME" "${FILEPREFIX}$FILENAME"
   
done
## END OF LOOP: for FILENAME



