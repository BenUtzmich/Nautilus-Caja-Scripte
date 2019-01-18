#!/bin/sh
##
## Nautilus
## SCRIPT: 00_multi-level-GIF-files_DISPLAY_find-f-file-grep_for-loop-eog.sh
##
## PURPOSE: Finds ALL the files (non-directory) at ALL LEVELS under
##          the current directory whose file-type contains the string
##          'GIF image data' --- using 'find', 'file', and 'grep'.
##
##          Example outputs from 'file' on GIF files:
##
##            GIF image data, version 89a, 40 x 19
##
##          Shows the files with an image viewer, currently 'eog'.
##
## METHOD:  For each GIF file found by the 'find-file-grep' combo of
##          commands, starts up the image viewer on the file.
##
## HOW TO USE: Right-click on the name of any file (or directory) in
##             a Nautilus list, after navigating to a 'base' directory.
##             Then choose this Nautilus script (name above).
########################################################################
## MAINTENANCE HISTORY:
## Created: 2013feb23
## Changed: 2013
########################################################################

## FOR TESTING: (show statements as they execute)
   set -x


########################################################################
## Use 'find-file-grep' to get the GIF filenames.
########################################################################

FILENAMES=`find . -type f -exec file {} \; | grep "GIF image data" | cut -d: -f1`

if test "$FILENAMES" = ""
then
   zenity  --info --title "NO MATCHES." \
      --text  "No GIF files found. EXITING."
   exit
fi

## FOR TESTING:
#  xterm -fg white -bg black -hold -geometry 90x24+100+100 -e \
#  echo "FILENAMES: $FILENAMES"

########################################################################
## Show the GIF files, one invocation of the image viewer per file.
########################################################################
## NOTE: 'eog -h' shows:
## Application Options:
##   -f, --fullscreen                   Open in fullscreen mode
##   -c, --disable-image-collection     Disable image collection
##   -s, --slide-show                   Open in slide show mode
##   -n, --new-instance                 Start a new instance instead of
##                                      reusing an existing one
#######################################################################

for FILE in $FILENAMES
do
   ## FOR TESTING:
   # xterm -fg white -bg black -hold -geometry 90x24+100+100 -e \

   eog -c -f -n "$FILE"


   ##################################################
   ## A zenity OK/Cancel prompt for 'Exit?'.
   ## (This allows for quickly exiting the loop when
   ##  there are many image files, rather than looking
   ##  for this process to kill it.)
   ##################################################

   zenity  --question --title "Exit?" \
      --text  "Exit?  Cancel = No."

   if test $? = 0
   then
      exit
   fi

done
