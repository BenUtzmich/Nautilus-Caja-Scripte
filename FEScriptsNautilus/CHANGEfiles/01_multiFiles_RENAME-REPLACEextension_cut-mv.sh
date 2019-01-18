#!/bin/sh
##
## Nautilus
## SCRIPT: 01_multiFiles_RENAME_REPLACEextension_cut-mv.sh
##
## PURPOSE: For each of the user-selected filename(s), this utility
##          replaces the 'extension' on each filename, if any,
##          with a user-specified extension. 
##          (Assumes a single extension indicator, a period, in the filenames.)
##
## METHOD:  Uses 'zenity' to prompt for the new 'extension'.
##          In a for-loop,
##             1) uses the 'cut' command to strip off the current
##                extension from each selected filename
##                (Alternatively, 'sed' could be used instead of 'cut'.)
##          and
##             2) uses 'mv' to rename each selected file with the new
##                user-specified extension.
##
## HOW TO USE: In Nautilus, select one or more files in a directory.
##             (The selected files can be directories.)
##             Right click and, from the 'Scripts >' submenus,
##             choose to run this script (name above).
##
## NO-EXTENSION NOTE:
##          This utility is written to skip any selected filenames
##          that do not have an extension, but this behavior could
##          easily be changed by commenting out an if-then statement.
##
##          In other words, this utility could easily be made to add
##          a common extension on selected filenames without extensions.
##          If this is done, the script should probable be renamed to
##          change the string 'REPLACE' to 'REPLACEorADD'.
##         
## UNDO NOTE:
##       If you accidentally rename the file(s) wrongly, you can usually
##       rename it/them back, by replacing the extension again --- using
##       this utility or some other feNautilusScripts utility in the
##       'CHANGEfiles' group.
##
## Created: 2011jan29
## Changed: 2011jul07 Changed to handle filenames with embedded spaces.
##                    (Removed use of FILENAMES var and we use a 'for' loop
##                     WITHOUT the 'in' phrase.  Ref: man bash )
## Changed: 2012feb13 Changed script name. Added the 'HOW TO USE' section
##                    above. Added to the 'METHOD' section above.
##                    Changed the indenting below.

## FOR TESTING: (show statements as they execute)
# set -x


#############################################################
## Prompt for the new extension for the selected filename(s). 
#############################################################

NEWEXT=""

NEWEXT=$(zenity --entry \
   --title "Enter NEW EXTENSION for the filename(s)." \
   --text "\
Enter a NEW EXTENSION to be used to replace the current extension
on each of the selected filename(s).
Examples:
  txt  OR  lis  OR  log  OR  text  OR  list  OR  pdf  OR
  html  OR  htm  OR  jpg  OR  jpeg  OR  mpg  OR  mpeg  OR
  wrl  OR  vrml  OR  vrml1  OR  vrml2  OR  vr1  OR  vr2

NOTE1:
 This utility requires that the selected files should have a single period
 (.) in their names, just in front of the current extensions.

NOTE2:
  As currently written, this utility skips selected filenames that have
  no extension (no period). This could be changed to allow this utility
  to add the extension to filenames with no extension. It simply requires
  commenting one if-then clause in this script." \
   --entry-text "")

if test "$NEWEXT" = ""
then
   exit
fi


###################################
## START THE LOOP on the filenames.
###################################

for FILENAME
do

   ####################################################
   ## Get the file extension and check that it is not
   ## blank. Skip the filename if it has no extension.
   ##  (Assumes one '.' in filename, at the extension.)
   ####################################################

   FILEEXT=`echo "$FILENAME" | cut -d\. -f2`

   if test "$FILEEXT" = "" 
   then 
      # exit
      # break
      continue
   fi

   ####################################################
   ## Get the 'midname' of the file, the part before
   ## the period and the extension.
   ####################################################

   MIDNAME=`echo "$FILENAME" | cut -d\. -f1`

   ##################################################
   ## Use 'mv' to rename the file.
   ##################################################
   ## The '--' handles filenames that start with '-'.
   ## It avoids the 'invalid option' error.
   ##################################################

   mv -- "$FILENAME" "${MIDNAME}.$NEWEXT"
   
done
## END OF LOOP: for FILENAME



