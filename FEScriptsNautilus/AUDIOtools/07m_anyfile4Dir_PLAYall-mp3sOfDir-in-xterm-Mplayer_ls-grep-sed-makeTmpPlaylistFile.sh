#!/bin/sh
##
## Nautilus
## SCRIPT: 07m_anyfile4Dir_PLAYall_mp3sOfDir-in-xterm-Mplayer_ls-grep-sed-makeTmpPlaylistFile.sh
##
## PURPOSE: Plays the mp3 files in the current directory,
##          sequentially using 'mplayer' in an 'xterm'.
##
## METHOD:  Uses the  'ls' and 'grep' commands to make a '.pls'
##          playlist file (in /tmp).
##
##          Plays the files by passing the playlist file to 'mplayer'.
##
##          The mp3's are played sequentially, from 'first' to 'last',
##          according to the 'ls' sorting algorithm.
##
## HOW TO USE: In Nautilus, navigate to a directory of mp3 files,
##             right-click on any file in the directory, then
##             choose this Nautilus script to run.
##
########################################################################
## Created: 2010dec05
## Changed: 2011may02 Added $USER to a temp filename.
## Changed: 2012feb29 Changed the scriptname, in the comment above.
##                    Reorged the 'METHOD' comment section above. 
## Changed: 2012oct01 Changed script name from '_xterm-Mplayer' to
##                    '-in-xterm-Mplayer' --- and added
##                    '_ls-grep-sed-makeTmpPlaylistFile'.
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
was not found. Exiting."
   exit
fi


#########################################################
## Prepare a 'play list' file to hold the audio filenames.
#########################################################

TEMPFILE="/tmp/${USER}_mplayer.pls"
rm -f $TEMPFILE

#########################################################
## Generate the 'play list' file, with 'ls' and 'grep'.
##
## NOTE: mplayer seems to need the string 'file://'
##       prefixed on fully-qualified filenames.
#########################################################

# CURDIR=`pwd`
# ls  | grep '\.mp3$' | eval "sed 's|^|file://$CURDIR|' > $TEMPFILE"

ls  | grep '\.mp3$' | sed 's|^|file://|' > $TEMPFILE


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
## Play the playlist files with 'mplayer'.
#############################################

## /usr/bin/mplayer -loop 0 -playlist $TEMPFILE
## '-loop' does not seem to work with playlist. Only works with movies?

# xterm -hold -fg white -bg black -geometry 90x24+100+100 -e \
#       /usr/bin/mplayer -playlist $TEMPFILE

xterm -hold -fg white -bg black -geometry 90x24+100+100 -e \
        $EXE_FULLNAME  -playlist $TEMPFILE


## We could add a zenity prompt to 'shuffle' the files.
#  /usr/bin/mplayer -shuffle -playlist $TEMPFILE

exit
###################################
## This exit is to avoid executing
## the following, alternative code.
###################################


#############################################
## BELOW IS AN ALTERNATE VERSION :
##   mplayer invoked once for each music file.
##
## But it is difficult to break in and cancel
## the loop. Could use a 'kill' command on this
## script or use Gnome System Monitor.
#############################################

   FILENAMES=`ls`
#  FILENAMES="$@"
#  FILENAMES="$NAUTILUS_SCRIPT_SELECTED_URIS"
#  FILENAMES="$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS"

###################################
## START THE LOOP on the filenames.
###################################

for FILENAME in $FILENAMES
do

  #################################################
  ## Get and check that file extension is 'mp3'. 
  ## THIS ASSUMES one '.' in filename, at the extension.
  #################################################

  FILEEXT=`echo "$FILENAME" | cut -d\. -f2`

  if test "$FILEEXT" != "mp3" 
  then
     continue
     # exit
  fi

  #############################
  ## Play the file.
  #############################

  # /usr/bin/mplayer "$FILENAME"

   $EXE_FULLNAME "$FILENAME"
done
