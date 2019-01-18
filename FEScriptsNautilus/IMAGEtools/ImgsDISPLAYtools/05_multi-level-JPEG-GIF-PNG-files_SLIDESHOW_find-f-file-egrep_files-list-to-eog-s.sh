#!/bin/sh
##
## Nautilus
## SCRIPT: 03_multi-level-JPEG-GIF-PNG-files_SLIDESHOW_find-f-file-egrep_files-list-to-eog-s.sh
##
## PURPOSE: Finds ALL the files (non-directory) at ALL LEVELS under
##          the current directory whose file-type contains the string
##          'JPEG', 'GIF', or 'PNG' --- using 'find', 'file', and 'egrep'.
##
##          Example outputs from 'file' on JPEG files:
##            JPEG image data, EXIF standard 
##            JPEG image data, JFIF standard 1.01 
##            JPEG image data, JFIF standard 1.02
##
##          Example outputs from 'file' on GIF files:
##            GIF image data, version 89a, 40 x 19
##
##          Example output from the 'file' command on a PNG file:
##            PNG image, 992 x 272, 8-bit/color RGBA, non-interlaced
##
##
##          Shows the files with an image viewer, currently 'eog -s',
##          where the '-s' invokes slideshow mode.
##
## METHOD:  Passes the JPEG/GIF/PNG filenames found by the 'find-file-grep'
##          combo of commands to the 'eog -s' command.
##
##          Note that this technique works even if the JPEG/GIF/PNG files
##          have no suffix, such as '.jpg' or '.gif' or '.png' --- or
##          if they have a wrong suffix.
##
## HOW TO USE: Right-click on the name of any file (or directory) in
##             a Nautilus list, after navigating to a 'base' directory.
##             Then choose this Nautilus script (name above).
##             It performs the 'find' starting from that 'base' directory.
##
#####################################################################
## MAINTENANCE HISTORY:
## Created: 2013feb23
## Changed: 2013
#####################################################################

## FOR TESTING: (show statements as they execute)
   set -x


########################################################################
## Use 'find-file-egrep' to collect the image filenames.
########################################################################

FILENAMES=`find . -type f -exec file {} \; | egrep "JPEG|GIF|PNG" | cut -d: -f1`

if test "$FILENAMES" = ""
then
   zenity  --info --title "NO MATCHES." \
      --text  "No JPEG or GIF or PNG files found. EXITING."
   exit
fi

## FOR TESTING:
  xterm -fg white -bg black -hold -geometry 90x24+100+100 -e \
  echo "FILENAMES: $FILENAMES"
 
########################################################################
## Put the image filenames (which are in a line-feed-separated list)
## into a string with double-quotes around each filename.
########################################################################

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

IMGNAMES=""

for FILENAME in $FILENAMES
do
   IMGNAMES="$IMGNAMES \"$FILENAME\""
done

IFS="$HOLD_IFS"

if test "$IMGNAMES" = ""
then
   zenity  --info --title "NO MATCHES." \
      --text  "No JPEG or GIF or PNG files found. EXITING."
   exit
fi


########################################################################
## Show the image files with one invocation of 'eog -s'.
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
# xterm -fg white -bg black -hold -geometry 90x24+100+100 -e \
#
#    eog -c -n -s "$IMGNAMES"

eval /usr/bin/eog  -c -n -s "$IMGNAMES"
