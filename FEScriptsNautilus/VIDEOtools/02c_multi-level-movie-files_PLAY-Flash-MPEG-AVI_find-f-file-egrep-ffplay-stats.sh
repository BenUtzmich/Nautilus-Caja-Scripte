#!/bin/sh
##
## Nautilus
## SCRIPT: 02c_multi-level-movie-files_PLAY-Flash-MPEG-AVI_find-f-file-egrep-ffplay-stats.sh
##
## PURPOSE: Finds ALL the files (non-directory) at ALL LEVELS under
##          the current directory whose file-type contains the string
##          'Flash' or 'MPEG' or 'AVI' --- using 'find', 'file', and 'egrep'.
##
##          Example output from the 'file' command:
##
##               ISO Media, MPEG v4 system, version 1
##               Macromedia Flash Video
##               ... AVI ...
##
##          Shows the files with a movie player, currently 'ffplay'.
##
##          NOTE: SWF (shockwave) files usually show as
##                Macromedia Flash data (compressed), version 9
##                and are not playable by 'ffplay'.
##
## METHOD:  Puts the name of each movie file found by the 'find-file-egrep'
##          combo of commands in a variable. In a 'for' loop, starts up 
##          the movie player on each file.
##
## HOW TO USE: Right-click on the name of any file (or directory) in
##             a Nautilus list, after navigating to a 'base' directory.
##             Then choose this Nautilus script (name above).
##
## Created: 2012dec09
## Changed: 2012dec30 Added 'zenity' exit-prompt ---
##                    to allow for exiting the loop, esp. when
##                    there are many movie files.
## Changed: 2013feb22 Added '-Flash-MPEG-AVI' to script name. Add AVI type.

## FOR TESTING: (show statements as they execute)
#  set -x


########################################################################
## Put the 'find-file-egrep' output in a variable.
########################################################################

FILENAMES=`find . -type f -exec file {} \; | egrep "Flash Video|MPEG|AVI" | cut -d: -f1`

########################################################################
## 'for' loop to play the movies.
########################################################################

MOVIEPLAYER="/usr/bin/ffplay -stats"

for FILE in $FILENAMES
do
   xterm -fg white -bg black -hold -geometry 90x24+100+100 -e \
      $MOVIEPLAYER "$FILE"

   ###################################################
   ## A zenity OK/Cancel prompt for 'Exit?'.
   ## (This allows for quickly exiting this loop, esp.
   ## when there are many movie files, rather than
   ## looking for this process to kill it.)
   ##################################################

   zenity  --question --title "Exit?" \
      --text  "Exit?  Cancel = No."

   if test $? = 0
   then
      exit
   fi

done
