#!/bin/sh
##
## Nautilus
## SCRIPT: 00_multi-level-MINKB-JPEG-files_SLIDESHOW_find-f-size-file-grep_files-list-to-ONE-eog-s.sh
##
## PURPOSE: Finds ALL the files (non-directory) at ALL LEVELS under
##          the current directory whose file-type contains the string
##          'JPEG image data' --- using 'find', 'file', and 'grep'.
##
##          Uses the '-size' parm of the 'find' command to select files
##          greater than a specifed size (in Kilobytes).
##
##          Uses 'zenity' to prompt for the min size (Kilobytes).
##
##          Example outputs from 'file' on JPEG files:
##
##            JPEG image data, EXIF standard 
##            JPEG image data, JFIF standard 1.01 
##            JPEG image data, JFIF standard 1.02
##
##          Shows the files with an image viewer --- currently 'eog' ---
##          by passing a list of filenames to 'eog' on the command line.
##
## METHOD:  Builds a list of JPEG filenames --- found by the 'find-f-size-file-grep'
##          combo --- and starts up ONE INSTANCE of the image viewer on
##          the filenames.
##
##          Note that this technique works even if the JPEG files
##          have no suffix, such as '.jpg' --- or if the JPEG files have
##          a wrong suffix.
##
## HOW TO USE: Right-click on the name of any file (or directory) in
##             a Nautilus list, after navigating to a 'base' directory.
##             Then choose this Nautilus script (name above).
#########################################################################
## MAINTENANCE HISTORY:
## Created: 2013apr01
## Changed: 2013
#########################################################################

## FOR TESTING: (show statements as they execute)
#   set -x

################################################################
## Prompt for a minimum file size, in KILOBYTES, using zenity.
################################################################

MINKB=""

MINKB=$(zenity --entry \
   --title "\
Enter MINIMUM KILOBYTES of JPEG files to be found." \
   --text "\
Enter  an integer.   Examples:
     50 for  50 Kilobytes
    250 for 250 Kilobytes
   1000 for 1 Megabyte = 1000 Kilobytes

NOTE: It may take more than 10 seconds to build the filenames list,
      if there are lots of JPEG files under this directory." \
   --entry-text "100")

if test "$MINKB" = ""
then
   exit
fi

MINBYTES=`expr $MINKB \* 1000`


########################################################################
## Use 'find-file-grep' to get the JPEG filenames.
########################################################################

FILENAMES=`find . -type f -size +${MINBYTES}c -exec file {} \; | grep "JPEG image data" | cut -d: -f1`

## FOR TESTING:
#  xterm -fg white -bg black -hold -geometry 90x24+100+100 \
#  -title "FILENAMES of JPEG FILES (bigger than $MINKB Kilobytes)" -e \
#  echo "FILENAMES: $FILENAMES"


########################################################################
## Build the list of large jpeg filenames.
########################################################################
## It would be nice to avoid changing IFS, but I have not
## found a way, yet, to make the 'in' reader
## of the 'for' loop recognize the separate filenames
## when filenames contain spaces.
##   (Perhaps we could use 'sed' to put a quote at the
##    beginning and end of each line in $FILENAMES.)
########################################################################

HOLD_IFS="$IFS"
## We put a single line-feed in IFS.
IFS='
'
BIGJPGNAMES=""

for FILENAME in $FILENAMES
do
   BIGJPGNAMES="$BIGJPGNAMES \"$FILENAME\""
done

IFS="$HOLD_IFS"


if test "$BIGJPGNAMES" = ""
then
   zenity  --info --title "NO MATCHES." \
      --text  "No 'big' JPEG files found. (Size > $MINKB Kilobytes.) EXITING."
   exit
fi

## FOR TESTING:
#   xterm -fg white -bg black -hold -geometry 90x24+100+100 \
#   -title "FILENAMES of 'BIG' JPEG FILES" -e \
#   echo "BIGJPGNAMES: $BIGJPGNAMES"


########################################################################
## Pass the string of filenames to the image viewer command.
## (NOTE: Simply using $FILENAMES as input to the viewer will encounter
##  failures when there are spaces embedded in filenames.)
########################################################################
## NOTE: 'eog -h' shows:
## Application Options:
##   -f, --fullscreen                   Open in fullscreen mode
##   -c, --disable-image-collection     Disable image collection
##   -s, --slide-show                   Open in slide show mode
##   -n, --new-instance                 Start a new instance instead of
##                                      reusing an existing one
#######################################################################

## FOR TESTING:
#  xterm -fg white -bg black -hold -geometry 90x24+100+100 -e \

# eog -c -n -f -s $BIGJPGNAMES

## Works:
eval /usr/bin/eog -c -n -f -s "$BIGJPGNAMES"
