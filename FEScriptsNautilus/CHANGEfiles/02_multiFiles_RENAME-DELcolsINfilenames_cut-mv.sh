#!/bin/sh
##
## Nautilus
## SCRIPT: 02_multiFiles_RENAME_DELcolsINfilenames_cut-mv.sh
##
## PURPOSE: For each of the user-selected file(s), we delete a
##          user-specified columns-range of characters from each filename.
## 
## METHOD: Uses 'zenity' to prompt for the column-range to delete.
##         In a for-loop,
##            1) uses 'cut' to delete the user-specified range of
##               columns (character positions) in each selected filename
##         and
##            2) renames each file 'in place' with the 'mv' command.
##
## HOW TO USE: In Nautilus, select one or more files in a directory.
##             (The selected files can be directories.)
##             Right click and, from the 'Scripts >' submenus,
##             choose to run this script (name above).
##
## BATCH NOTE:
##       Use with care. If you wrongly delete columns in a bunch of
##       filenames and you have to rename them back to the original
##       names, GOOD LUCK. You will probably have to add back the
##       removed characters manually, for each filename --- if you can
##       remember what was removed from each filename.
##
##       It would probably be best to work with copies of the
##       files you want to rename. Then, if it turns out you
##       can successfully use the new-named files, and you 
##       think you do not need the originals, then delete the
##       originals.
##
##       Alternatively, when doing a large batch of files,
##       use this utility on 2 or 3 files. If those renames go OK,
##       do the rest of the batch --- in small batches, if you want
##       to be extra careful.
##
## FOR-LOOP NOTE:   (See the 2011jul07 'Changed:' note below.)
##     Before I found the 'for FILENAME'-without-'in' technique,
##     via 'man bash', I used a 'while-loop-with-"$1"-and-shift' technique.
##
##     I forget where I found the 'while-loop-with-"$1"-and-shift'
##     technique for handling files with spaces in the names,
##     but there is a paragraph on this at the bottom of
##     http://atastypixel.com/blog/a-brief-shell-scripting-tutorial/
##
## Created: 2011mar28
## Changed: 2011may02 Add $USER to a temp filename.
## Changed: 2011jul07 Changed to handle filenames with embedded spaces.
##                    (Removed remnants of use of FILENAMES var and
##                     removed use of 'shift'. We use a 'for' loop
##                     WITHOUT the 'in' phrase. Ref: man bash )
## Changed: 2012feb13 Changed script name. Added the 'HOW TO USE' section
##                    above. Added to the 'METHOD' section above. Added
##                    to the 'BATCH NOTE' section above.
##                    Changed the indenting below.

## FOR TESTING: (show statements as they execute)
#  set -x


############################################################
## Prompt for the column-range to delete from the filenames. 
############################################################

COLRANGE=""

COLRANGE=$(zenity --entry \
   --title "Enter COLUMN-RANGE to delete from filename(s)." \
   --text "\
Enter a COLUMN-RANGE of chars to delete from filename(s) of
the selected file(s).
Example: 9-12" \
   --entry-text "")

if test "$COLRANGE" = ""
then
   exit
fi

########################################
## START THE LOOP on the filenames.
########################################

for FILENAME
do

   ###################################
   ## Make the new name for the file.
   ###################################

   NEWNAME=`echo "$FILENAME" | cut -b$COLRANGE --complement`

   ###################################
   ## Use 'mv' to rename the file.
   ###################################
   ## '--' allows for filenames that
   ## begin with '-'.
   ###################################

   mv -- "$FILENAME" "$NEWNAME"

done
## END OF LOOP: for FILENAME


