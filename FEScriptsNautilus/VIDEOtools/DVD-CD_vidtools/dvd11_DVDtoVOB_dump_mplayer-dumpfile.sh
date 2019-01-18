#!/bin/sh
##
## Nautilus
## SCRIPT: dvd11_DVDtoVOB_dump_mplayer-dumpfile.sh
##
## PURPOSE: Dump a (video) DVD to a VOB (.vob) file.
##
## METHOD:  Uses 'zenity --entry' to prompt for the ID of the DVD drive.
##
##          Uses 'mplayer' with '-dumpstream' and '-dumpfile' parms to
##          extract the '.vob' file from the DVD.
##
##          Puts the '.vob' file in /tmp.
##
##          Tries to play the '.vob' file with a movie player.
##
## HOW TO USE: In Nautilus, select to ANY file in ANY directory.
##             Then right-click, then choose to run this script (name above).
##
############################################################################
## Started: 2011may11 
## Changed: 2012may22 Changed script name in comments above and touched up
##                    the comments. Changed some indenting below.
###########################################################################

## FOR TESTING: (display statements that are executed)
# set -x

###########################################
## Get the filename of the selected file.
###########################################

# FILENAME="$@"
  FILENAME="$1"
# FILENAMES="$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS"


############################################################
## Ask for an integer identifier of the DVD drive.
############################################################

NDVD=""

NDVD=$(zenity --entry \
   --title "ENTER an id NUMBER for the DVD drive." \
   --text "\
Enter an id number for the DVD drive.
      Typically 1 or 2. (OR 0 or 1?)

The 'mplayer' dump process will be started in a terminal
window so that startup and encoding messages can be watched.

When 'mplayer' is finished, CLOSE the terminal window.
The output file, if good, could be shown in a video player." \
       --entry-text "1")

if test "$NDVD" = ""
then
   exit
fi


####################################################################
## Prepare the output '.vob' filename --- in /tmp.
####################################################################

FILEOUT="/tmp/${USER}_mplayer_dump.vob"

if test -f "$FILEOUT"
then
   rm -f "$FILEOUT"
fi

##########################################################
## Use 'mplayer' to make the '.vob' file.
##########################################################

xterm -hold -fg white -bg black -geometry 90x48+100+100 -e \
      mplayer dvd://$NDVD -dumpstream -dumpfile  "$FILEOUT"


## This code is from a bigger example on converting vob-to-flv ---
## FROM (2009):
## http://linux-issues.blogspot.com/2009/05/converting-vob-to-flv-format.html
##
##
##   mplayer dvd://1 -dumpstream -dumpfile myvideo.vob
##   mencoder myvideo.vob -of lavf \
##            -ovc lavc -lavcopts vcodec=flv:vbitrate=150 -ofps 25 \
##            -oac mp3lame -lameopts abr:br=32 -srate 44100 \
##            -vf scale=720 -o outputfile.flv
##
## which was accompanied by the note:
##  The "flv" format files can only support 8000, 22050 and 44100 I believe for
##  the available -srate.


###########################################################
## Show the '.vob' file (when user closes the xterm window).
##      (May need to change this, say to simply show
##       VOB file properties.)
###########################################################

if test ! -f "$FILEOUT"
then
   exit
fi


# MOVIEPLAYER="/usr/bin/mplayer"
# MOVIEPLAYER="/usr/bin/gmplayer -vo xv"
# MOVIEPLAYER="/usr/bin/smplayer"
# MOVIEPLAYER="/usr/bin/totem"
# MOVIEPLAYER="/usr/bin/vlc"

MOVIEPLAYER="/usr/bin/ffplay -stats"

xterm -fg white -bg black -hold -geometry 90x48+100+100 \
      -e $MOVIEPLAYER "$FILEOUT"

## NOTE: 'totem' (based on gstreamer, version ?) tends to play
##        only a second or so of an mpeg1video that I created
##        with ffmpeg.
##        But 'ffplay' does a good job. 'mplayer' does OK.
##        'totem' is suspect. (Or the ffmpeg recording parms?)


#########################################################
## Use a user-specified MOVIEPLAYER.  Someday?
#########################################################

# . $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
# . $DIR_NautilusScripts/.set_VIEWERvars.shi

# $MOVIEPLAYER "$FILEOUT" &
