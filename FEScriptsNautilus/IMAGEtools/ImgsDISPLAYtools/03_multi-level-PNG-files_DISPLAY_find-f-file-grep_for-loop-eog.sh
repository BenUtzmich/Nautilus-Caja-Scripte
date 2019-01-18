#!/bin/sh
##
## Nautilus
## SCRIPT: 00_multi-level-PNG-files_DISPLAY_find-f-file-grep-eog.sh
##
## PURPOSE: Finds ALL the files (non-directory) at ALL LEVELS under
##          the current directory whose file-type contains the string
##          'PNG image' --- using 'find', 'file', and 'grep'.
##
##          Example output from the 'file' command on a PNG file:
##
##            PNG image, 992 x 272, 8-bit/color RGBA, non-interlaced
##
##          Shows the files with an image viewer, currently 'eog'.
##
## METHOD:  For each PNG file found by the 'find-file-grep' combo of
##          commands, starts up the image viewer on the file.
##
##          Note that this technique works even if the PNG files
##          have no suffix, such as '.png' --- or a wrong suffix.
##
## HOW TO USE: Right-click on the name of any file (or directory) in
##             a Nautilus list, after navigating to a 'base' directory.
##             Then choose this Nautilus script (name above).
########################################################################
## MAINTENANCE HISTORY:
## Created: 2012dec30
## Changed: 2013feb23 Added '-c -f -n' to the 'eog' command.
##                    Added '_for-loop' to script name.
########################################################################

## FOR TESTING: (show statements as they execute)
   set -x


########################################################################
## Use 'find-file-grep' to get the PNG filenames.
########################################################################

FILENAMES=`find . -type f -exec file {} \; | grep "PNG image" | cut -d: -f1`

if test "$FILENAMES" = ""
then
   zenity  --info --title "NO MATCHES." \
      --text  "No PNG files found. EXITING."
   exit
fi

## FOR TESTING:
#  xterm -fg white -bg black -hold -geometry 90x24+100+100 -e \
#  echo "FILENAMES: $FILENAMES"

########################################################################
## Show the PNG files, one invocation of the image viewer per file.
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


   ######################################################
   ## A zenity OK/Cancel prompt for 'Exit?'.
   ## (This allows for quick exit if many files are found,
   ## rather than trying to find this process to kill it.)
   ######################################################

   zenity  --question --title "Exit?" \
      --text  "Exit?  Cancel = No."

   if test $? = 0
   then
      exit
   fi

done
