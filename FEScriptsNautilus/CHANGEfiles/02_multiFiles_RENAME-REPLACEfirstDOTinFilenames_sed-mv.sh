#!/bin/sh
##
## Nautilus
## SCRIPT: 02_multiFiles_RENAME_REPLACEfirstDOTinFilenames_sed-mv.sh
##
## PURPOSE: REPLACES the first dot (period), reading from the left, in
##          filename(s) of the user-selected file(s) --- with another
##          user-specified character or string.
##
## METHOD:  Uses 'zenity' to prompt for the replacement string or character.
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
## Created: 2012jul12
## Changed: 2012

## FOR TESTING: (show statements as they execute)
#  set -x


###########################################
## Prompt for the 'to' string or character
## --- to replace the first dot (period)
## (from the left) in each selected filename.
###########################################

TO_STRING=""

TO_STRING=$(zenity --entry \
   --title "Enter the 'TO' character or string." \
   --text "\
Enter the the 'to' string or character --- that is to
replace the first dot (period) (from the left) in each
selected filename.

For a default, the colon (:) character is provided.
Change it if you want a different character or string." \
   --entry-text ":")

if test "$TO_STRING" = ""
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

   ##################################################
   ## Use 'sed' to make the new filename.
   ##  (We replace the first occurrence of a dot,
   ##   reading from the left, in the filename.
   ##    We could use 'g' to replace all.)
   ##################################################

   NEWFILENAME=`echo "$FILENAME" | sed "s|\.|${TO_STRING}|"`

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
