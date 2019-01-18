#!/bin/sh
##
## Nautilus
## SCRIPT: 02g_multi-movie-files_PLAY-in-Gmplayer_for-loop-makeTmpPlaylistFile.sh
##
## PURPOSE: Plays SELECTED movie files in the current directory.
##          Plays the files with 'gmplayer'.
##
## METHOD:  In a 'for' loop, builds a play-list file using the names of
##          the selected movie files.
##
##          Passes the playlist file to 'gmplayer'.
##
## HOW TO USE: In Nautilus, navigate to a directory of movie files, and
##             select the files to play. (Can use the Ctl key or
##             the Shift key to select multiple files.)
##             Then right-click on the selected files in the directory,
##             and choose this Nautilus script to run (name above).
## 
##       REFERENCE:  Based on similar AUDIOtools script
##             08g_multiplay_mp3s_selectedShuffled_Gmplayer.sh
##
###############################################################################
## Created: 2011apr20
## Changed: 2011may02 Add $USER to the TEMPFILE name.
## Changed: 2011jul07 Removed use of a NAUTILUS_SCRIPT var. In its place,
##                    we use a 'for' loop, WITHOUT the 'in' phrase, to handle
##                    filenames with embedded spaces.  Ref: man bash
## Changed: 2012may24 Changed script name in comments above and touched up
##                    the comments. Changed some indenting below.
## Changed: 2012oct01 Changed script name from '-playlistFile' to
##                    '-makeTmpPlaylistFile' --- and 'PLAY_Gmplayer' to
##                    'PLAY-in-Gmplayer'.
#############################################################################

## FOR TESTING: (display statements as they execute)
# set -x

#######################################
## Prepare a playlist file for gmplayer.
#######################################

TEMPFILE="/tmp/${USER}_vids_Gmplayer.pls"

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
######################################################################
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


#############################################
## Play the playlist, with 'gmplayer'.
#############################################

#  if test "$ANS" = "Yes"
#  then
#     /usr/bin/gmplayer -shuffle -playlist "$TEMPFILE"
#  else

     /usr/bin/gmplayer -playlist "$TEMPFILE"

#  fi

exit 
###################################
## This exit is to avoid executing
## the following, alternative code.
###################################


#################################################
## BELOW IS AN ALTERNATE VERSION :
##     gmplayer invoked once for each music file.
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

   /usr/bin/gmplayer "$FILENAME"

done
## END OF 'for FILENAME' loop.
