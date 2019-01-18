#!/bin/sh
##
## Nautilus
## SCRIPT: 02G_multi-movie-files_PLAY-in-Gnome-mplayer_for-loop-makeTmpPlaylistFile.sh
##
## PURPOSE: Plays SELECTED movie files in the current directory.
##
## METHOD:  In a 'for' loop, creates a play-list file in /tmp.
##
##          Then uses 'zenity --question' to ask user whether he/she wants
##          the playback shuffled/randomized.
##
##          Then passes the play-list file to 'gnome-mplayer'.
##
## HOW TO USE: In Nautilus, navigate to a directory of movie files, and
##             select the files to play. (Can use the Ctl key or
##             the Shift key.)
##             Then right-click on the selected files in the directory,
##             then choose this Nautilus script to run (name above).
## 
##        REFERENCE:  Based on the AUDIOtools script
##             08G_multiplay_mp3s_selectedShuffled_Gnome-mplayer.sh
##
############################################################################
## Created: 2011jun13
## Changed: 2011jul07 Removed use of a NAUTILUS_SCRIPT var. In its place,
##                    we use a 'for' loop, WITHOUT the 'in' phrase, to handle
##                    filenames with embedded spaces.  Ref: man bash
## Changed: 2012may24 Changed script name in comments above and touched up
##                    the comments. Changed some indenting below.
## Changed: 2012oct01 Changed script name from '-playlistFile' to
##                    '-makeTmpPlaylistFile'.
###########################################################################

## FOR TESTING: (display statements as they execute)
# set -x

############################################
## Prepare a playlist file for gnome-mplayer.
############################################

TEMPFILE="/tmp/${USER}_vids_Gnome-mplayer.pls"

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
###########################################

# CURDIR="`pwd`"

for FILENAME
do
   # FILECHK=`echo "$FILENAME" | egrep '\.flv$|\.avi$'|`\.mpg$'
   # if test ! "$FILECHK" = ""
   # then
      echo "file://$FILENAME" >>  "$TEMPFILE"
   # fi
done


#############################################
## A zenity OK/Cancel prompt for 'Shuffle?'.
#############################################

zenity  --question \
   --title "Shuffle?" \
   --text  "Shuffle (randomize) the songs?
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


#############################################
## Play the playlist, with 'gnome-mplayer'.
#############################################

if test "$ANS" = "Yes"
then
   /usr/bin/gnome-mplayer --random --playlist "$TEMPFILE"
else
   /usr/bin/gnome-mplayer --playlist "$TEMPFILE"
fi

exit 
###################################
## This exit is to avoid executing
## the following, alternative code.
###################################


#################################################
## BELOW IS AN ALTERNATE VERSION :
##     gnome-mplayer invoked once for each music file.
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

   # if test "$FILEEXT" != "mp4" -a  "$FILEEXT" != "flv" -a ... 
   # then
   #    continue
   #    # exit
   # fi

   #######################################
   ## Play the file.
   #######################################

   /usr/bin/gnome-mplayer "$FILENAME"

done
## END OF 'for FILENAME' loop.
