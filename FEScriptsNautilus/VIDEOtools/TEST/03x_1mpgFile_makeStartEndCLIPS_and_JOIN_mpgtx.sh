#!/bin/sh
##
## Nautilus
## SCRIPT: 03x_1mpgFile_makeStartEndCLIPS_and_JOIN_mpgtx.sh
##
## PURPOSE: For multiple, user-specifed start-and-end times,
##          select 'clips' from a given movie file (mpeg or other format
##          supported by mpgtx) --- AND join the selected clips together
##          into a new (shorter) movie --- using 'mpgtx'.
##
##          Can install 'mpgtx' using 'sudo apt-get install mpgtx'.
##
## METHOD:  Uses 'zenity --entry' to prompt for start and end times
##          for the clips to be extracted from the selected file.
##
##          Run 'mpgtx -j' on the selected file, with the specified
##          start and end times.
## 
##          Shows the new movie in a movie player.
##
## REFERENCES:
##   http://superuser.com/questions/21736/how-to-trim-or-delete-parts-of-an-mpeg-video-from-the-linux-command-line
##            Some comments from this web page are in comments below,
##            near the call to 'mpgtx'.
##       OR
##            do a web search on keywords such as 'mpgtx clip join start end'.
##
##
## HOW TO USE: In Nautilus, select one '.mpg' movie file.
##             Then right-click and choose this VIDEOtools script to run
##             (name above).
##
## NOTE on TESTING:
##       This script has NOT been tested on non-mpg movie file formats
##       that mpgtx may support. Seems to work for 'mpg'.
##
#############################################################################
## Started: 2011apr20
## Changed: 2012may24 Changed script name in comments above and touched up
##                    the comments. Changed some indenting below.
###########################################################################

## FOR TESTING: (display statements that are executed)
# set -x

##########################################
## Get the filename of the selected file.
##########################################

# FILENAMES="$@"
# FILENAMES="$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS"

FILENAME="$1"


##################################################################
## Check that the selected file is a 'flv' or 'wmv' or 'avi' or
## 'mpg' --- or some other movie file, suffix to be added.
##  (Assumes just one dot [.] in the filename, at the extension.)
##################################################################

FILEEXT=`echo "$FILENAME" | cut -d\. -f2`
 
#  if test "$FILEEXT" != "flv" -a "$FILEEXT" != "wmv" -a \
#          "$FILEEXT" != "avi" -a "$FILEEXT" != "mov" -a \
#          "$FILEEXT" != "mpg"
#  then
#     exit
#  fi


############################################################
## Prompt for the start and end times (one or more pairs)
## to be selected from the movie.
############################################################

STARTSENDS=""

STARTSENDS=$(zenity --entry \
   --title "Specify Start and End time(s)." \
   --text "\
Enter Start and End times (must include minutes as well as seconds).
Examples:
[0:10-0:20] [0:42-0:52] [1:23-1:33]
          grabs seconds 10-20, 42 through 52, then 1:23 through 1:33
[-0:20] [0:42-0:52] [1:23-]
          gets the first 20 seconds, secs 42 through 52, then 1:23 through the end" \
   --entry-text "[0:10-0:20] [0:42-0:52] [1:23-1:33]")

if test "$STARTSENDS" = ""
then
   exit
fi


##########################################
## Prepare the output filename.
##########################################

FILENAMECROP=`echo "$FILENAME" | cut -d\. -f1`

FILEOUT="${FILENAMECROP}_SELECTED.$FILEEXT"

if test -f "$FILEOUT"
then
   rm -f "$FILEOUT"
fi


#################################################################
## Use 'mpgtx' to make the new movie clip file.
#################################################################
## See the web page referenced above.
#################################################################
## NOTE from the web page 
## http://superuser.com/questions/21736/
## how-to-trim-or-delete-parts-of-an-mpeg-video-from-the-linux-command-line :
##
##    Re-encoding an mpeg file if the timings are off
##
##    You may find that the timings are not very accurate because of
##    the way that mpgtx works (which is on a group of pictures, GOP, basis).
##    I have found that reencoding the mpeg at a constant bitrate leads
##    to files which then can be split very precisely with the above method.
##    A simple re-encoding call is as follows.
##
##    Re-encode at a constant bit rate of 2250k
##
##    ffmpeg -i input.mpg -b 2250k -minrate 2250k -maxrate 2250k \
##           -bufsize 1000k output.mpg
##
##    Note. ffmpeg can do much of what mpgtx can do, but the latter makes
##    it much easier to specify multiple cuts (and you can give the input
##    in start and end times, as opposed to start and durations). However,
##    ffmpeg is a great companion. I find that converting AVIs to mpeg with
##    ffmeg, then doing the splitting with mpgtx is the quickest means to
##    get the job done. 
##########################################################################

## FOR TEST:
#   set -x

xterm -hold -fg white -bg black -e \
      mpgtx -j "$FILENAME" "$STARTSENDS" -o "$FILEOUT"

## FOR TEST:
#    set -


###########################################
## Show the clipped (shortened) movie file.
###########################################

if test ! -f "$FILEOUT"
then
   exit
fi

# MOVIEPLAYER="/usr/bin/vlc"
# MOVIEPLAYER="/usr/bin/gnome-mplayer"
# MOVIEPLAYER="/usr/bin/smplayer"
# MOVIEPLAYER="/usr/bin/totem"

MOVIEPLAYER="/usr/bin/ffplay -stats"

xterm -fg white -bg black -hold -geometry 90x24+100+100 -e \
        $MOVIEPLAYER "$FILEOUT"

###############################################################
## Use a user-specified MOVIEPLAYER.  Someday?
###############################################################

#  . $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
#  . $DIR_NautilusScripts/.set_VIEWERvars.shi

#   $MOVIEPLAYER "$FILEOUT" &
