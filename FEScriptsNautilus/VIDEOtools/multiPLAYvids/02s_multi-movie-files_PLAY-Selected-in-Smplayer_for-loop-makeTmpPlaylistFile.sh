#!/bin/sh
##
## Nautilus
## SCRIPT: 02s_multi-movie-files_PLAY-in-Smplayer_for-loop-makeTmpPlaylistFile.sh
##
## PURPOSE: Plays SELECTED movie files in the current directory.
##          Plays the files with 'smplayer'.
##
## METHOD:  In a 'for' loop, builds a play-list file using the names of
##          the selected movie files.
##
##          Uses 'zenity --info' to show some info on how to control
##          movie playback with 'smplayer'.
##
##          Passes the playlist file to 'smplayer'.
##
## HOW TO USE: In Nautilus, navigate to a directory of movie files, and
##             select the files to play. (Can use the Ctl key or
##             the Shift key to select multiple files.)
##             Then right-click on the selected files in the directory,
##             and choose this Nautilus script to run (name above).
##
##        REFERENCE:  Based on the similar AUDIOtools script
##             08s_multiplay_mp3s_selectedShuffled_Smplayer.sh
##
############################################################################
## Created: 2011apr20
## Changed: 2011jul07 Removed use of a MOVIENAMES="$@" method. In its place,
##                    we use a 'for' loop, WITHOUT the 'in' phrase, to handle
##                    filenames with embedded spaces and build a playlist file.
##                    Ref: man bash
## Changed: 2012may24 Changed script name in comments above and touched up
##                    the comments. Changed some indenting below.
## Changed: 2012oct01 Changed script name from '-playlistFile' to
##                    '-makeTmpPlaylistFile' --- and 'PLAY_Smplayer' to
##                    'PLAY-in-Smplayer'.
#############################################################################

## FOR TESTING:
# set -x

#############################################################
## Prepare a 'play list' filename to hold the video filenames.
#############################################################

TEMPFILE="/tmp/${USER}_vids_Smplayer.pls"

if test -f "$TEMPFILE"
then
   rm -f "$TEMPFILE"
fi


######################################################
## Put the selected filenames in the 'play list' file.
##
## We use 'echo' to put the
## filenames into the playlist file.
##
## NOTE1: Smplayer seems to need the string 'file://'
##        prefixed on fully-qualified filenames.
##
## We could build the a FILENAMES list of filenames
## with a 'for' loop, like MP3NAMES is built
## in the AUDIOtools script
##   07t_multiplay_mp3s_allOfDir_Totem.sh
######################################################

CURDIR="`pwd`"

for FILENAME
do
   ## Some file suffix checking could go here.
   echo "file://${CURDIR}/$FILENAME" >> "$TEMPFILE"
done


###################################################################
## A zenity info display on how to shuffle the files in 'smplayer'.
###################################################################

zenity  --info \
   --title "How to use Smplayer." \
   --text  "\
In Smplayer, you can use 'Options > Playlist' show the selected
files in a list window. At the bottom of that list window are
icons for various actions.

Click on the two-arrows icon to keep repeat-playing the list.
Click on the dice icon to randomize the playing of the selected
movie files." &

sleep 2


#############################################
## Play the playlist, with 'smplayer'.
#############################################

## FOR TESTING:
# xterm -fg white -bg black -hold -geometry 90x24+100+100 -e \

/usr/bin/smplayer -playlist "$TEMPFILE"

exit 
###################################
## This exit is to avoid executing
## the following, alternative code.
###################################


#################################################
## BELOW IS AN ALTERNATE VERSION :
##     smplayer invoked once for each music file.
##
## But it is difficult to break in and cancel
## the loop. Could use a 'kill' command on the
## script or use Gnome System Monitor.
#################################################


###########################################
## START THE LOOP on the filenames.
###########################################

for FILENAME
do

   ##########################################################
   ## Get and check that file extension is 'mp4' or whatever. 
   ## Assumes one '.' in filename, at the extension.
   ##########################################################

   # FILEEXT=`echo "$FILENAME" | cut -d\. -f2`

   # if test "$FILEEXT" != "mp4" -a  "$FILEEXT" != "wmv" -a ...
   # then
   #    continue
   #    # exit
   # fi

   #######################################
   ## Play the file.
   #######################################

   /usr/bin/smplayer "$FILENAME"

done
## END OF 'for FILENAME' loop.
