#!/bin/sh
##
## Nautilus
## SCRIPT: 02f_multi-movie-files_PLAY-in-ffplay_for-loop-playEachFile.sh
##
## PURPOSE: Plays SELECTED movie files in the current directory.
##
## METHOD:  Uses 'zenity --info' to show info on how to use 'ffplay'
##          to control movie playback.
##
##          Uses a for-loop to execute 'ffplay' on each selected
##          movie file.
##
##          Runs 'ffplay' in an 'xterm' so that messages can be seen.
##
##          Provides a 'zenity' prompt after exiting ffplay (after
##          playing each file) to ask user whether to exit the loop.
##
##             Otherwise, it is difficult to break in and cancel
##             the loop. Could use a 'kill' command on this
##             script or use Gnome System Monitor.
##
## HOW TO USE: In Nautilus, navigate to a directory of movie files, and
##             select the files to play. (Can use the Ctl key or
##             the Shift key to select multiple files.)
##             Then right-click on the selected files in the directory,
##             and choose this Nautilus script to run (name above).
##
#############################################################################
## Created: 2011jun13
## Changed: 2011jul07 Removed use of a '$1-and-shift' technique. In its place,
##                    we use a 'for' loop, WITHOUT the 'in' phrase, to handle
##                    filenames with embedded spaces.  Ref: man bash
## Changed: 2012may24 Changed script name in comments above and touched up
##                    the comments. Changed some indenting below.
## Changed: 2012oct01 Chgd scriptname from 'PLAY_ffplay' to 'PLAY-in-ffplay'.
###########################################################################

## FOR TESTING: (display statements as they execute)
# set -x


###########################################
## Show some keyboard control codes for
## managing the 'ffplay' movie viewer.
###########################################

zenity  --info \
   --title "'ffplay' Keyboard Controls" \
   --no-wrap \
   --text  "\
'ffplay' keyboard controls, while movie is playing :

   q or ESC    Quit.

 p or SPACE    Pause.

mouse click    Seek to percentage in file corresponding to location
               of click on left/right of ffplay window.

 left/right    Seek backward/forward 10 seconds.
     arrows

    down/up    Seek backward/forward 1 minute.
     arrows

          f    Toggle full screen.

          a    Cycle audio channel.
          v    Cycle video channel.
          t    Cycle subtitle channel.
          w    Show audio waves.
" &

sleep 3


###########################################
## START THE LOOP on the filenames.
###########################################

FILECNT=0

for FILENAME
do

   #######################################
   ## Ask whether to exit, AFTER 1st file.
   #######################################

   if test $FILECNT -ne 0
   then

      zenity --question \
      --title "Play next movie?" \
      --text "\
Click OK to play next movie.  Or click Cancel to exit." 
               
      if test ! $? = 0
      then
         exit
      fi

   fi
   ## END OF if test $FILECNT -ne 0

  FILECNT=`expr $FILECNT + 1`

  #########################################################
  ## Get and check that file extension is a 'supported' movie
  ## file --- via the file suffix.
  ##
  ##      Could check for ordinarily-good suffixes such as
  ##      'mpg', 'mpeg',
  ##      'wmv', 'asf',
  ##      'avi', 'flv',
  ##      'mp4', 'mkv',
  ##      'ogg', 'ogv', etc.
  ##
  ##   Assumes one '.' in filename, at the extension.
  #########################################################

  # FILEEXT=`echo "$FILENAME" | cut -d\. -f2`

  # if test "$FILEEXT" != "mpg" -a  "$FILEEXT" != "mpeg" -a \
  #         "$FILEEXT" != "wmv" -a  "$FILEEXT" != "asf"  -a \
  #         "$FILEEXT" != "avi" -a  "$FILEEXT" != "flv"  -a \
  #         "$FILEEXT" != "mp4" -a  "$FILEEXT" != "mkv"  -a \
  #         "$FILEEXT" != "ogg" -a  "$FILEEXT" != "ogv"
  # then
  #    continue
  #    # exit
  # fi

  #######################################
  ## Play the file with 'ffplay -stats'.
  #######################################

  eval xterm -fg white -bg black -geometry 90x24+100+100 -e \
             /usr/bin/ffplay -stats "$FILENAME"

done
## END OF 'for FILENAME' loop.
