#!/bin/sh
##
## Nautilus
## SCRIPT: 00_one-level-JPEG-files_SLIDESHOW_ls-file-grep_files-list-to-ONE-eog-s.sh
##
## PURPOSE: Finds ALL the files in the current directory
##          whose file-type contains the string
##          'JPEG image data' --- using 'ls', 'file', and 'grep'.
##
##          Example outputs from 'file' on JPEG files:
##
##            JPEG image data, EXIF standard 
##            JPEG image data, JFIF standard 1.01 
##            JPEG image data, JFIF standard 1.02
##
##          Shows the files with an image viewer --- currently 'eog -s' ---
##          by passing a list of filenames to 'eog' on the command line.
##
## METHOD:  Builds a list of JPEG filenames --- found by the 'ls-file-grep'
##          combo --- and starts up ONE INSTANCE of the image viewer on
##          the filenames.
##
##          Note that this technique works even if the JPEG files
##          have no suffix, such as '.jpg' --- or a wrong suffix.
##
## HOW TO USE: Right-click on the name of any file (or directory) in
##             a Nautilus list, after navigating to a 'base' directory.
##             Then choose this Nautilus script (name above).
#########################################################################
## MAINTENANCE HISTORY:
## Created: 2013feb23
## Changed: 2013
#########################################################################

## FOR TESTING: (show statements as they execute)
   set -x


########################################################################
## Use 'ls-file-grep' to get the JPEG filenames.
########################################################################
## REFERENCE for this technique - FE Nautilus script:
## 07t_anyfile4Dir_PLAYall-mp3sOfDir-in-Totem_ls-grep-make-filenames-string.sh
## in the 'AUDIOtools' group.
########################################################################

## This does not work for filenames with embedded spaces.
#  JPGNAMES=`ls  | grep '\.jpg$' | sed 's|$| |'`

FILENAMES=`ls`
 
HOLD_IFS="$IFS"
## We put a single line-feed in IFS.
IFS='
'

## It would be nice to avoid changing IFS, but I have not
## found a way, yet, to make the 'in' reader
## of the 'for' loop recognize the separate filenames
## when filenames contain spaces.
##   (Perhaps we could use 'sed' to put a quote at the
##    beginning and end of each line in $FILENAMES.)

JPGNAMES=""

for FILENAME in $FILENAMES
do
   FILECHK=`file "$FILENAME" | grep 'JPEG image'`
   if test ! "$FILECHK" = ""
   then
      JPGNAMES="$JPGNAMES \"$FILENAME\""
   fi
done

IFS="$HOLD_IFS"

if test "$JPGNAMES" = ""
then
   zenity  --info --title "NO MATCHES." \
      --text  "No JPEG files found. EXITING."
   exit
fi

## FOR TESTING:
#  xterm -fg white -bg black -hold -geometry 90x24+100+100 -e \
#  echo "JPGNAMES: $JPGNAMES"

########################################################################
## Pass the string of filenames to the image viewer command.
## (Simply using $FILENAMES as input to the viewer will encounter failures
##  when there are spaces embedded in filenames.)
########################################################################
## NOTE: 'eog -h' shows:
## Application Options:
##   -f, --fullscreen                   Open in fullscreen mode
##   -c, --disable-image-collection     Disable image collection
##   -s, --slide-show                   Open in slide show mode
##   -n, --new-instance                 Start a new instance instead of
##                                      reusing an existing one
#######################################################################

## This gives a 'Given location contains no images' error from eog.
#   eog -c -n -f -s $JPGNAMES

## Works:
eval /usr/bin/eog -c -n -f -s "$JPGNAMES"
