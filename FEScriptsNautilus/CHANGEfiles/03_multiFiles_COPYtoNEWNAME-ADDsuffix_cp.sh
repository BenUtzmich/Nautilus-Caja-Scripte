#!/bin/sh
##
## Nautilus
## SCRIPT: 03_multiFiles_COPY-ADDsuffix_cp.sh
##
## PURPOSE: Copy the user-selected files to new filenames that
##          have a user-specified suffix added to the original filenames.
##          Note: 
##          This suffix will appear after an 'extension', if any, on each
##          selected filename.
##
## METHOD:  Uses 'zenity' to prompt for the suffix.
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
##       the copy again.
##
## DISK SPACE NOTE:
##       If the user copies large numbers of files or some very large files,
##       the user may use up a lot of disk space. This should be taken
##       into consideration. One techinque is do 'small' batches at a time.
##
## Created: 2010sep06
## Changed: 2011jul07 Changed to handle filenames with embedded spaces.
##                    (Removed use of FILENAMES var and we use a 'for' loop
##                     WITHOUT the 'in' phrase.  Ref: man bash )
## Changed: 2012feb13 Changed script name. Added the 'HOW TO USE' section
##                    above. Added to the 'METHOD' section above.
##                    Added the 'DISK SPACE NOTE' section above.
##                    Changed the indenting below. Added a disk space warning
##                    in the zenity prompt below.
##                    Added a directory check on $FILENAME below.

## FOR TESTING: (show statements as they execute)
# set -x

###########################################
## Prompt for the suffix for the filenames. 
###########################################

FILESUFFIX=""

FILESUFFIX=$(zenity --entry \
   --title "Enter SUFFIX to use for copied filenames." \
   --text "\
Enter a COMMON SUFFIX for the new filenames, for the copies
of the selected files.
Examples:
  __BKUP  OR   .txt   OR   __2010aug22   OR   __OBSOLETE   OR   __OLD

Warning: Take disk space into consideration if you selected many files
or some very large files." \
   --entry-text "_BKUP")

if test "$FILESUFFIX" = ""
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

   cp -- "$FILENAME" "${FILENAME}$FILESUFFIX"
   
done
## END OF LOOP: for FILENAME



