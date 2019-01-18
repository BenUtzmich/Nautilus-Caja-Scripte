#!/bin/sh
##
## Nautilus
## SCRIPT: 01_multi-level-JPEG-files_COPY_zenity-get-TO-dir_find-f-file-grep_cp-loop.sh
##
## PURPOSE: 1) Finds ALL the files (non-directory) at ALL LEVELS under
##             the current directory whose file-type contains the string
##             'JPEG image data' --- using 'find', 'file', and 'grep'.
##
##             Example outputs from 'file' on JPEG files:
##
##            JPEG image data, EXIF standard 
##            JPEG image data, JFIF standard 1.01 
##            JPEG image data, JFIF standard 1.02
##
##          
##          2) Uses a 'zenity -file-selection' prompt to prompt for
##             a TO directory for the copy.
##
##          3) Uses a 'for loop' 
##          Shows the files with an image viewer --- currently 'eog' ---
##          by passing a list of filenames to 'eog' on the command line.
##
## METHOD:  Builds a list of JPEG filenames --- found by the 'find-file-grep'
##          combo --- performs the zenity prompt --- then performs the
##          'cp' command in a loop on the list of JPEG filenames.
##
##          Note that this technique works even if the JPEG files
##          have no suffix, such as '.jpg' --- or a wrong suffix.
##
## HOW TO USE: Right-click on the name of any file (or directory) in
##             a Nautilus list, after navigating to a 'base' directory.
##             Then choose this Nautilus script (name above).
#########################################################################
## MAINTENANCE HISTORY:
## Created: 2013may28
## Changed: 2013
#########################################################################

## FOR TESTING: (show statements as they execute)
   set -x


########################################################################
## Use 'find-file-grep' to get the JPEG filenames.
########################################################################

FILENAMES=`find . -type f -exec file {} \; | grep "JPEG image data" | cut -d: -f1`

if test "$FILENAMES" = ""
then
   zenity  --info --title "NO MATCHES." \
      --text  "No JPEG files found. EXITING."
   exit
fi

## FOR TESTING:
#  xterm -fg white -bg black -hold -geometry 90x24+100+100 -e \
#  echo "FILENAMES: $FILENAMES"

JPEGcnt=`echo "$FILENAMES" | wc -l`

## FOR TESTING:
#  xterm -fg white -bg black -hold -geometry 90x24+100+100 -e \
#  echo "JPEG FILES FOUND: $JPEGcnt"


####################################
## Get the TO directory name.
####################################

DIR_TO=""

DIR_TO=$(zenity --file-selection \
   --title "Select the 'TO' directory for the COPY of the found JPEG files." \
   --text "\
Select the 'TO' directory for the COPY of $JPEGcnt JPEG files that were found,
by using the 'find' command with 'file' and a 'grep' for the string
'JPEG image data' in the output for each execution of the 'file' command.
" \
   --directory --filename "$CURDIR" --confirm-overwrite)

if test "$DIR_TO" = ""
then
   exit
fi


########################################################################
## LOOP thru the set of JPEG filenames to 'cp' the files to
## the 'TO' directory.
########################################################################

for FILENAME in $FILENAMES
do
   ## Could add a check here to prompt whether to continue,
   ## for each JPEG after the first copy.
   ## See VIDEOtools/02f_multi-movie-files_PLAY-in-ffplay_for-loop-playEachFile.sh
   cp $FILENAME $DIR_TO/
done
