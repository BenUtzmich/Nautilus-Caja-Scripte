#!/bin/sh
##
## Nautilus
## SCRIPT: 00_multiFiles_RENAME_SPACE2underscore_UPPER2lower_tr-mv.sh
##
## PURPOSE: For each of the user-selected files, the filename
##          is converted from UPPER-CASE to lower-case --- AND
##          each space is converted to an underscore.
##
## METHOD:  Both the UC-to-LC and spaces-to-underscores operations
##          are done with the 'tr' command.
##          Each file is renamed 'in place' with the 'mv' command.
##
## HOW TO USE: In Nautilus, select one or more files in a directory.
##             (The selected files can be directories.)
##             Right click and, from the 'Scripts >' submenus,
##             choose to run this script (name above).
##
## UC2LC NOTE:
##          If there is an 'extension' (several characters after a period
##          near the end of the filename) on a selected file, the extension
##          is converted to lower-case along with the rest of the filename.
##
## BATCH NOTE:
##          Use with care. If you rename a bunch of mixed-case
##          files, if you have to rename them back to the original
##          names, GOOD LUCK.
##
##          It would probably be best to work with copies of the
##          files you want to rename. Then, if it turns out you
##          can successfully use the new-named files, and you 
##          think you do not need the originals, then delete the
##          originals.
##
##          Alternatively, if doing a big batch of renames, do
##          2 or 3 first. If those go OK, select the rest of the batch.
##
## FOR-LOOP NOTE:   (See 2011jul07 'Changed:' note below.)
##    Before I found the 'for FILENAME'-without-'in' technique,
##    via 'man bash', I used a 'while-loop-with-"$1"-and-shift' technique.
##
##    I forget where I found the 'while-loop-with-"$1"-and-shift'
##    technique for handling files with spaces in the names,
##    but there is a paragraph on this at the bottom of
##    http://atastypixel.com/blog/a-brief-shell-scripting-tutorial/
##
## Created: 2010aug25
## Changed: 2011may02 Add $USER to a temp filename.
## Changed: 2011jul07 Changed to handle filenames with embedded spaces.
##                    (Removed remnants of use of FILENAMES var and
##                     removed use of 'shift'. We use a 'for' loop
##                     WITHOUT the 'in' phrase. Ref: man bash )
## Changed: 2012feb13 Changed script name. Added the 'HOW TO USE' section
##                    above. Added to the 'METHOD' section above.
##                    Changed the indenting below.

## FOR TESTING: (show statements as they execute)
#  set -x

########################################
## START THE LOOP on the filenames.
########################################

for FILENAME
do

   ###################################
   ## Make the new name for the file.
   ###################################

   NEWNAME=`echo "$FILENAME" | tr [A-Z] [a-z] | tr ' ' '_'`

   #####################################
   ## Use 'mv' to rename the file.
   #####################################
   ## '--' allows for use with filenames
   ## that start with '-'.
   #####################################

   mv -- "$FILENAME" "$NEWNAME"

done
## END OF LOOP: for FILENAME


