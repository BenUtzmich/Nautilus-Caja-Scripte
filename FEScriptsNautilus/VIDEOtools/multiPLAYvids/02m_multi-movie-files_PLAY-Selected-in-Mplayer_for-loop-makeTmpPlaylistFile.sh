#!/bin/sh
##
## Nautilus
## SCRIPT: 02m_multi-movie-files_PLAY-in-Mplayer_for-loop-makeTmpPlaylistFile.sh
##
## PURPOSE: Plays SELECTED movie files in the current directory.
##          Plays the files with 'mplayer'.
##
## METHOD:  In a 'for' loop, builds a play-list file using the names
##          of the selected movie files.
##
##          Uses 'zenity --info' to show how to control movie playback
##          in 'mplayer'.
##
##          (Could use a 'zenity --question' prompt to ask the user whether to
##          'shuffle' the files.)
##
##          Passes the playlist file to 'mplayer'.
##
##          Runs 'mplayer' in an 'xterm' so that messages can be seen.
##
##        REFERENCE:  Based on the similar AUDIOtools script
##             08m_multiplay_mp3s_selectedShuffled_Mplayer.sh
##
## HOW TO USE: In Nautilus, navigate to a directory of movie files, and
##             select the files to play. (Can use the Ctl key or
##             the Shift key to select multiple files.)
##             Then right-click on the selected files in the directory,
##             and choose this Nautilus script to run (name above).
##
###############################################################################
## Created: 2011apr20
## Changed: 2011may02 Add $USER to the TEMPFILE name.
## Changed: 2011jul07 Removed use of a NAUTILUS_SCRIPT var. In its place,
##                    we use a 'for' loop, WITHOUT the 'in' phrase, to handle
##                    filenames with embedded spaces.  Ref: man bash
## Changed: 2012may22 Changed script name in comments above and touched up
##                    the comments. Changed some indenting below.
## Changed: 2012oct01 Changed script name from '-playlistFile' to
##                    '-makeTmpPlaylistFile' --- and 'PLAY_Mplayer' to
##                    'PLAY-in-Mplayer'.
###########################################################################

## FOR TESTING: (display statements as they execute)
# set -x

#######################################
## Prepare a playlist file for mplayer.
#######################################

TEMPFILE="/tmp/${USER}_vids_mplayer.pls"

if test -f "$TEMPFILE"
then
   rm -f "$TEMPFILE"
fi

###########################################
## Put the filenames in the playlist file.
##
## We use 'echo' to put the selected
## filenames into the playlist file.
##
## NOTE: We could use 'grep' to select
## only the files with certain suffixes, like
## 'mpg', 'flv', 'ogv', etc. 
##
## NOTE: These filenames may be fully
## qualified with 'file://' prefixed
## to each full filename.
#######################################################################
## Rather than using a NAUTILUS_SCRIPT var to make the playlist file,
## we use a 'for FILENAME' loop technique --- so that this script
## may be usable with other file managers.
## So we avoid this:
##    echo "$NAUTILUS_SCRIPT_SELECTED_URIS" > "$TEMPFILE"
######################################################################
 
# CURDIR="`pwd`"

for FILENAME
do
   echo "file://$FILENAME" >>  "$TEMPFILE"
   # echo "file://${CURDIR}/$FILENAME" >>  "$TEMPFILE"
done


#############################################
## A zenity OK/Cancel prompt for 'Shuffle?'.
#############################################

#  zenity  --question --title "Shuffle?" \
#          --text  "Shuffle (randomize) the songs?
#                   Cancel = No."

#  if test $? = 0
#  then
#     ANS="Yes"
#  else
#     ANS="No"
#  fi

## An ALTERNATE zenity prompt (radiolist for Yes/No to 'Shuffle?').
##
#  ANS=$(zenity --list --radiolist \
#               --title "Shuffle?" --text "Shuffle (randomize) the songs?" \
#               --column "Cancel" --column "= Yes" \
#              TRUE Yes FALSE No)
#
#  if test "$ANS" = ""
#  then
#     ANS="Yes"
#  fi


###########################################################
## A zenity 'info' window to show Mplayer keyboard controls.
###########################################################

zenity  --info \
   --title "Mplayer Keyboard Controls" \
   --no-wrap \
   --text  "\
Mplayer keyboard controls:
  left and right arrows   seek backward/forward 10 seconds.
  up and down arrows      seek forward/backward 1 minute.
  pgup and pgdown         seek forward/backward 10 minutes.
  [ and ]                 decrease/increase current playback speed by 10%.
  { and }                 halve/double current playback speed.
  backspace               reset playback speed to normal.
  less-than/greater-than  go backward/forward in the playlist.
  ENTER                   go forward in the playlist, even over the end.
  p or SPACE              pause (pressing again unpauses).
  q or ESC                stop playing and quit.
  + and -                 adjust audio delay by +/- 0.1 seconds.
  / and *                 decrease/increase volume.
  9 and 0                 decrease/increase volume.
  ( and )                 adjust audio balance in favor of left/right channel.
  m                       mute sound.
" &

sleep 3


#############################################
## Play the playlist, with 'mplayer'.
#############################################

#  if test "$ANS" = "Yes"
#  then
#    xterm -hold -fg white -bg black -geometry 90x24+100+100 -e \
#         /usr/bin/mplayer -shuffle -playlist "$TEMPFILE"
#  else

xterm -hold -fg white -bg black -geometry 90x24+100+100 -e \
      /usr/bin/mplayer -playlist "$TEMPFILE"

#  fi

exit 
###################################
## This exit is to avoid executing
## the following, alternative code.
###################################


#################################################
## BELOW IS AN ALTERNATE VERSION :
##     mplayer invoked once for each music file.
##
## But it is difficult to break in and cancel
## the loop. Could use a 'kill' command on this
## script or Gnome System Monitor.
#################################################

###########################################
## START THE LOOP on the filenames.
###########################################

for FILENAME
do

   #########################################################
   ## Get and check that file extension is 'mp4' or whatever. 
   ## Assumes one '.' in filename, at the extension.
   #########################################################

   # FILEEXT=`echo "$FILENAME" | cut -d\. -f2`

   # if test "$FILEEXT" != "mp4" -a "$FILEEXT" != "flv" -a ...
   # then
   #    continue
   #    # exit
   # fi

   #######################################
   ## Play the file.
   #######################################

   /usr/bin/mplayer "$FILENAME"

done
## END OF 'for FILENAME' loop.
