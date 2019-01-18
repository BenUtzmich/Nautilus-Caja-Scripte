#!/bin/sh
##
## Nautilus
## SCRIPT: 00_multi-level-JPEG-files_DISPLAY_find-f-file-grep_files-list-to-ONE-eog.sh
##
## PURPOSE: Finds ALL the files (non-directory) at ALL LEVELS under
##          the current directory whose file-type contains the string
##          'JPEG image data' --- using 'find', 'file', and 'grep'.
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
## METHOD:  Builds a list of JPEG filenames --- found by the 'find-file-grep'
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
## Created: 2012dec30
## Changed: 2013feb23 Added '-c -n -f' to 'eog' command.
##                    Changed scriptname slightly (hyphen to underscore).
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

## FOR TESTING:
#  xterm -fg white -bg black -hold -geometry 90x24+100+100 -e \

eog -c -n -f $FILENAMES
