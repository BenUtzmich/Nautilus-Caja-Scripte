#!/bin/sh
##
## Nautilus
## SCRIPT: 08m_multi-mp3-files_PLAY-in-xterm-Mplayer-ShuffleOpt_for-loop-makeTmpPlaylistFile.sh
##
## PURPOSE: Plays user-selected mp3 files in the current directory
##          using 'mplayer' in an 'xterm'.
##
## METHOD:  Uses a for-loop to build a playlist file (in /tmp) from
##          the user-selected filenames.
##
##          Uses a zenity prompt to determine whether to 'shuffle' the files.
##
##          Uses 'zenity --info' to show a window of Mplayer controls info.
##
##          Plays the files by passing the playlist file to 'mplayer'.
##
## HOW TO USE: In Nautilus, navigate to a directory of mp3 files,
##             select the files to play (can use the Ctl key or
##             the Shift key),
##             right-click on the selected files in the directory,
##             then choose this Nautilus script to run.
##
#############################################################################
## Created: 2010dec05
## Changed: 2011may02 Added $USER to a temp filename.
## Changed: 2011jul07 Removed use of a NAUTILUS_SCRIPT var. In its place,
##                    we use a 'for' loop, WITHOUT the 'in' phrase, to handle
##                    filenames with embedded spaces.  Ref: man bash
## Changed: 2012feb29 Changed the scriptname, in the comment above.
##                    Reorged the 'METHOD' comment section above. 
## Changed: 2012oct01 Changed script name from '_xterm-Mlayer' to
##                    '-in-xterm-Mlayer' --- and added
##                    '_for-loop-makeTmpPlaylistFile'.
## Changed: 2013apr10 Added check for the player executable.
###########################################################################

## FOR TESTING: (show statements as they execute)
# set -x

#########################################################
## Check if the player executable exists.
#########################################################

EXE_FULLNAME="/usr/bin/mplayer"

if test ! -f "$EXE_FULLNAME"
then
   zenity  --info --title "Player NOT FOUND." \
   --no-wrap \
   --text  "\
The player executable
   $EXE_FULLNAME
was not found. Exiting.

If the player is in a different location,
you can edit this script to change the filename."
   exit
fi


##########################################
## Prepare a playlist filename for mplayer.
##########################################

TEMPFILE="/tmp/${USER}_mplayer.pls"
rm -f "$TEMPFILE"

#########################################
## Put the filenames in the playlist file.
##
## We use 'echo' and 'grep' to filter out
## the non-mp3 files selected and put the
## filtered names into the playlist file.
##
## NOTE: These filenames may be fully
## qualified with 'file://' prefixed
## to each full filename.
#######################################################################
## Rather than using a NAUTILUS_SCRIPT var to make the playlist file,
## we use a 'for FILENAME' loop technique --- so that this script
## may be usable with other file managers.
## So we avoid this:
##   echo "$NAUTILUS_SCRIPT_SELECTED_URIS" | grep '\.mp3$' > "$TEMPFILE"
######################################################################
 
# CURDIR="`pwd`"

for FILENAME
do
   FILECHK=`echo "$FILENAME" | grep '\.mp3$'`
   if test ! "$FILECHK" = ""
   then
      echo "file://$FILENAME" >>  "$TEMPFILE"
   fi
done


#############################################
## A zenity OK/Cancel prompt for 'Shuffle?'.
#############################################

zenity  --question --title "Shuffle?" \
   --text  "\
Shuffle (randomize) the songs?
         Cancel = No."

if test $? = 0
then
   ANS="Yes"
else
   ANS="No"
fi

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

zenity  --info --title "Mplayer Keyboard Controls" \
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


#############################################
## Play the playlist, with 'mplayer'.
#############################################

if test "$ANS" = "Yes"
then
   xterm -hold -fg white -bg black -geometry 90x24+100+100 -e \
      $EXE_FULLNAME -shuffle -playlist "$TEMPFILE"
      #  /usr/bin/mplayer -shuffle -playlist "$TEMPFILE"
else
   xterm -hold -fg white -bg black -geometry 90x24+100+100 -e \
      $EXE_FULLNAME  -playlist "$TEMPFILE"
      # /usr/bin/mplayer -playlist "$TEMPFILE"
fi

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
## script or use Gnome System Monitor.
#################################################

   FILENAMES_GET="$@"
#  FILENAMES_GET="$NAUTILUS_SCRIPT_SELECTED_URIS"
#  FILENAMES_GET="$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS"


#########################################################
## Shuffle the filenames.
##
## NOTE:
## 'sed' is used to change a 'space' separator between
## the filenames into line-feeds --- because 'shuf' wants
## separate lines to shuffle, not words in a string.
##     This assumes no embedded blanks in the filenames.
##
## NOTE: Could try the '-shuffle' option of mplayer, below.
##########################################################

FILENAMES=`echo "$FILENAMES_GET" | sed 's| |\n|g' | shuf`

###########################################
## START THE LOOP on the filenames.
###########################################

for FILENAME in "$FILENAMES"
do

   ##################################################
   ## Get and check that file extension is 'mp3'. 
   ##  Assumes one '.' in filename, at the extension.
   ##################################################

   FILEEXT=`echo "$FILENAME" | cut -d\. -f2`

   if test "$FILEEXT" != "mp3" 
   then
      continue
      # exit
   fi

   #######################################
   ## Play the file.
   #######################################

   # /usr/bin/mplayer -shuffle "$FILENAME"

   # /usr/bin/mplayer "$FILENAME"

   $EXE_FULLNAME "$FILENAME"
done
