#!/bin/sh
##
## Nautilus
## SCRIPT: 02d_multi-level-audio-files_PLAY-MP3_find-f-file-egrep-mplayer-fs.sh
##
## PURPOSE: Finds ALL the files (non-directory) at ALL LEVELS under
##          the current directory whose file-type contains the string
##          'MPEG' and 'layer III' --- using 'find', 'file', and 'egrep'.
##
##          Example output from the 'file' command:
##
##            filename: MPEG ADTS, layer III, v1, 128 kbps, 44.1 kHz, JntStereo
##
##          Shows the files with a audio player, 'mplayer'.
##
## METHOD:  Puts the name of each audio file found by the 'find-file-egrep'
##          combo of commands in a variable. In a 'for' loop, starts up 
##          the audio player on each file.
##
## HOW TO USE: Right-click on the name of any file (or directory) in
##             a Nautilus list, after navigating to a 'base' directory.
##             Then choose this Nautilus script (name above).
##
## Created: 2013feb22
## Changed: 2013

## FOR TESTING: (show statements as they execute)
#  set -x


########################################################################
## Put the 'find-file-egrep' output in a variable.
########################################################################

FILENAMES=`find . -type f -exec file {} \; | egrep "Flash Video|MPEG|AVI" | cut -d: -f1`

########################################################################
## 'for' loop to play the audios.
########################################################################

AUDIOPLAYER="/usr/bin/mplayer -fs"

for FILE in $FILENAMES
do
   xterm -fg white -bg black -hold -geometry 90x24+100+100 -e \
      $AUDIOPLAYER "$FILE"

   ###################################################
   ## A zenity OK/Cancel prompt for 'Exit?'.
   ## (This allows for quickly exiting this loop, esp.
   ## when there are many audio files, rather than
   ## looking for this process to kill it.)
   ##################################################

   zenity  --question --title "Exit?" \
      --text  "Exit?  Cancel = No."

   if test $? = 0
   then
      exit
   fi

done
