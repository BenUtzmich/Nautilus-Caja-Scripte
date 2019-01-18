#!/bin/sh
##
## Nautilus
## SCRIPT: 02t_multi-movie-files_PLAY-in-Totem_for-loop-make-filenames-string.sh
##
## PURPOSE: Plays SELECTED movie files in the current directory.
##          Plays the files with 'totem'.
##
## METHOD:  In a 'for' loop, builds a string of filenames (separated
##          by spaces and enclosed in double-quotes) to pass to 'totem'.
##
##          Uses 'zenity --info' to show some info on usage of 'totem'.
##
##          Passes the string of filenames to 'totem', using 'eval'.
##
##      REFERENCE:  Based on the similar AUDIOtools script
##               08m_multiplay_mp3s_selectedShuffled_Totem.sh
##
## HOW TO USE: In Nautilus, navigate to a directory of movie files, and
##             select the files to play. (Can use the Ctl key or
##             the Shift key to select multiple files.)
##             Then right-click on the selected files in the directory,
##             and choose this Nautilus script to run (name above).
##
#########################################################################
## Created: 2011apr20
## Changed: 2011may02 Add $USER to temp filename.
## Changed: 2011jul08 To handle filenames with spaces in the names.
##                    Changed a MOVIENAMES="$@" method to a 'for' loop
##                    with no 'in' phrase, to handle spaces in filenames.
## Changed: 2012may24 Changed script name in comments above and touched up
##                    the comments. Changed some indenting below.
## Changed: 2012oct01 Changed script name from '-filenames-string' to
##                    '-make-filenames-string' --- and 'PLAY_Totem' to
##                    'PLAY-in-Totem'.
###########################################################################

## FOR TESTING: (show statements as they execute)
# set -x

##############################################################
## Prepare a playlist filename for Totem.
##   NOTE: 'totem' does not seem to accept a playlist file,
##   although you can '--enqueue' filenames into its playlist.
##   Ref: man totem
## COMMENTED, until we find if Totem does accept a playlist.
##############################################################

#  TEMPFILE="/tmp/${USER}_vids_totem.pls"
#  rm -f "$TEMPFILE"


####################################
## Generate a string of movie filenames
## from the selected filenames.
##
## We use 'echo' to put the (quoted)
## filenames into the playlist file.
##
## NOTE: These filenames may be fully
## qualified with 'file://' prefixed
## to each full filename.
####################################

#  MOVIENAMES="$@"

FILENAMES=""

for FILENAME
do
   FILENAMES="$FILENAMES \"$FILENAME\""
done


#############################################################
## A zenity info display on how to shuffle the files in Totem.
#############################################################

zenity  --info \
   --title "How to use Totem." \
   --text  "\
In Totem, use 'Edit > Shuffle Mode' to randomize
the playing of the selected movie files.

Use 'Edit > Repeat Mode' to keep cycling 
through the playlist composed of the selected movie files.

If 'Properties' show on the right, you can replace that
info with the list of selected files by
clicking on 'Playlist' at the top of the selector
in the right sidebar ---
or click on 'Properties' to replace the 'Playlist'.

Close this window to startup 'Totem'."

sleep 3


#############################################
## Play the files, with 'totem'.
#################################################################
## 'totem' does not have command line options like '-shuffle'
## or '-random' to randomize the playing of the files.
##
## totem does not have a command line option like '-loop'
## to call for repeating the playing N times or indefinitely.
##
## But if such techniques are available, by some other means,
## we could use zenity to prompt for those actions to be triggered.
##################################################################

## FOR TESTING:
#  set -x

eval /usr/bin/totem "$FILENAMES"

## WAS
#   /usr/bin/totem $MOVIENAMES

exit 
###################################
## This exit is to avoid executing
## the following, alternative code.
###################################


#################################################
## BELOW IS AN ALTERNATE VERSION :
##     totem invoked once for each music file.
##
## But it is difficult to break in and cancel
## the loop. Could use a 'kill' command on this
## script or use Gnome System Monitor.
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

   # if test "$FILEEXT" != "mp4" -a "$FILEEXT" != "wmv" -a ...
   # then
   #    continue
   #    # exit
   # fi

   #######################################
   ## Play the file.
   #######################################

   /usr/bin/totem "$FILENAME"

done
## END OF 'for FILENAME' loop.
