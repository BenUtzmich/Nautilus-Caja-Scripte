#!/bin/sh
##
## Nautilus
## SCRIPT: 10_multiFiles_DELcarr-returnsWITHIN_MS2UNIX_tr_toNewfile.sh
##
## PURPOSE: For each of the user-selected files, a new file is created while
##          using the 'tr' command to REMOVE CARRIAGE RETURN CHARS from
##          lines/records within each selected file.
##
##             For each selected file, the processed data is put
##             in a new file whose name is the old filename with
##             the suffix '_NOcarr-returns' added.
##
## METHOD:  In a for-loop, for each of the selected files, the 'tr' command
##          is applied as described above.
##
##          There are no prompts to the user. The user should see the new
##          files, with the '_NOcarr-returns' suffix, pop up in the view
##          of the filenames in the current directory.
##
##            (Note: It is highly unlikely that there will be existing files
##             with these names.
##             It there are, it is quite likely that it is OK to overlay them.
##             If necessary, a check for the new filename could be added and
##             the processing of the files for those existing new filenames
##             could be skipped --- with a 'zenity --info' popup to let the
##             user know of each such file.)
##
## HOW TO USE: In Nautilus, select one or more (text) files in a directory.
##             (The selected files should NOT be directories.)
##             Right click and, from the 'Scripts >' submenus,
##             choose to run this script (name above).
##
## DISK SPACE NOTE:
##       If the user applies this utility to large numbers of files or to
##       some very large files, the user may use up a lot of disk space ---
##       for the new versions of the originals. This should be taken
##       into consideration. One techinque is do 'small' batches at a time.         
##
## Created: 2010oct21
## Changed: 2011may02 Add $USER to a temp filename.
## Changed: 2011jul07 Changed to handle filenames with embedded spaces.
##                    (Removed use of FILENAMES var and we use a 'for' loop
##                     WITHOUT the 'in' phrase.  Ref: man bash )
## Changed: 2012feb13 Changed script name. Added the 'HOW TO USE'
##                    section. Added to the 'METHOD' section title.
##                    Added the 'DISK SPACE NOTE' section above.
##                    Touched up indenting below. Added a check to skip
##                    any $FILENAME that is a directory.

## FOR TESTING: (show statements as they execute)
# set -x

########################################
## START THE LOOP on the filenames.
########################################

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


   ########################################
   ## Make the name for the output file.
   ########################################

   NEWNAME="${FILENAME}_NOcarr-returns"

   ##################################################
   ## Remove carriage-returns everywhere in the file.
   ## (They are almost always just at linefeeds.
   ##  If this does not work in some cases,
   ##  could try a 'sed' formulation.)
   ##################################################

   tr -d '\015' < "$FILENAME" > "$NEWNAME"

   ####################################################
   ## On some Unixes (like SGI IRIX),
   ## you could use unix 'to_unix' command,
   ## if available.
   ##
   ## 'to_unix' is actually a script that uses 
   ##       tr -d '\015\032'
   ## to strip out "all carriage-returns and ctrl-Z's".
   ####################################################
  
done
## END OF LOOP: for FILENAME


