#!/bin/sh
##
## Nautilus
## SCRIPT: 06v_multi-movie-files_PLAY-in-VLC_for-loop-make-filenames-string.sh
##
## PURPOSE: Plays SELECTED movie files in the current directory.
##          Plays the files with 'vlc'.
##
## METHOD:  In a 'for' loop, builds a string of the selected filenames,
##          space-separated and each name in double-quotes.
##
##          Passes the string of filenames to 'vlc', using 'eval'.
##
##            Could use 'zenity --info'  to provide some usage info in a
##            popup window. Someday?
##
##            For now, use the separate scripts
##               00_anyfile_shoHELP_vlc-H.sh
##            and
##               00_anyfile_shoHELP_vlc-h.sh
##            to show usage info on 'vlc'.
##           
##      NOTE on playlist file:
##          It would be nice to use a 'playlist' file
##          to feed the filenames to ONE call of 'vlc',
##          but after much web searching, I have not
##          found an example of doing that.
##
##          Furthermore,
##          'vlc' does not seem to take a playlist file
##          (according to 'man vlc'), so we build a string of
##          filenames (quoted to handle filenames with spaces),
##          and feed that string to the 'vlc' command.
##
##      NOTE on length of the string of arguments:
##         I am concerned about passing all the filenames
##         on the VLC command line. There is a limit of around 2KB
##         (maybe much more nowadays) on the length of a command line.
##         An alternate implementation could call 'vlc' once for
##         each file --- or use 'xargs'.
##
##       REFERENCE:  See the similar AUDIOtools script
##               08v_multi-mp3-files_PLAYselected_shuffleOption_VLC.sh
##
## HOW TO USE: In Nautilus, navigate to a directory of movie files,
##             select the files to play (can use Ctl key or
##             the Shift key),
##             right-click on the selected files in the directory,
##             then choose this Nautilus script to run.
##
###############################################################################
## Started: 2011apr20
## Changed: 2011jul08 To avoid using a NAUTILUS_SCRIPT var.
##                    Replaced a NAUTILUS_SCRIPT var technique with a
##                    'for' loop with no 'in' phrase, to handle spaces in names.
## Changed: 2012may24 Changed script name in comments above and touched up
##                    the comments. Changed some indenting below.
## Changed: 2012oct01 Changed script name from '-filenames-string' to
##                    '-make-filenames-string' --- and 'PLAY_VLC' to
##                    'PLAY-in-VLC'.
###########################################################################

## FOR TESTING: (show statements as they execute)
# set -x

#############################################################
## Prepare a 'play list' filename to hold the video filenames.
##
## NOTE: 'vlc' does not seem to accept a playlist file,
## although you can '--playlist-enqueue' filenames into
## its playlist when in '--one-instance' mode.
## Ref: vlc -H
##
## So the following playlist-file creation is commented.
## It may be activated if it ever becomes known that
## VLC supports input via a playlist file.
#############################################################

#  TEMPFILE="/tmp/${USER}_vids_vlc.pls"

# if test -f  "$TEMPFILE"
# then
#    rm -f "$TEMPFILE"
# fi

#############################################################
## Generate a string of (quoted) movie filenames from the
## selected filenames.
#############################################################

FILENAMES=""

for FILENAME
do
   FILENAMES="$FILENAMES \"$FILENAME\""
done


############################################
## A zenity OK/Cancel prompt for 'Shuffle?'.
############################################

zenity  --question \
   --title "Shuffle?" \
   --text  "Shuffle (randomize) the movies?
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
#               --title "Shuffle?" --text "Shuffle (randomize) the movies?" \
#               --column "Cancel" --column "= Yes" \
#              TRUE Yes FALSE No)
#
#  if test "$ANS" = ""
#  then
#     ANS="Yes"
#  fi


#######################################
## Play the selected files, with vlc --
## with shuffle or without.
###############################################################
## We could use '--loop' to repeat-play the files, indefinitely.
## But if there is a problem, VLC tends to get in a loop and
## it is a bit of a pain to kill VLC (especially for a newbie).
## We could add a zenity prompt whether to loop.
###############################################################
## A possible alternative is to quit after one play-through,
## instead of looping indefinitely:
## Use '--play-and-exit' instead of '--loop'.
############################################################
## Another option:  '--qt-start-minimized'
############################################################

if test "$ANS" = "Yes"
then
   eval /usr/bin/vlc --random --no-http-album-art --album-art 0 \
            --no-http-forward-cookies --playlist-tree \
            --one-instance --playlist-enqueue \
            "$FILENAMES"
else
   eval /usr/bin/vlc --no-http-album-art --album-art 0 \
            --no-http-forward-cookies --playlist-tree \
            --one-instance --playlist-enqueue \
            "$FILENAMES"
fi

exit
###################################
## This exit is to avoid executing
## the following, alternative code.
###################################

############################################################
## ALTERNATIVE VERSION --- using a loop through the filenames.
## Initiates VLC over and over, instead of calling VLC once.
##
## NOTE: It is difficult to break in and cancel
## the loop. Could use a 'kill' command on this script
## or use Gnome System Monitor.
############################################################

######################################
## START THE LOOP on the filenames.
######################################

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

   #########################
   ## Play the file with vlc.
   #########################

   /usr/bin/vlc --no-http-album-art --album-art 0 --play-and-exit \
         --qt-start-minimized "$FILENAME"

done
## END OF 'for FILENAME' loop.
