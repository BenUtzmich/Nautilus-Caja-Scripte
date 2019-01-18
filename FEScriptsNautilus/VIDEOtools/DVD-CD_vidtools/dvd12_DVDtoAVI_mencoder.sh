#!/bin/sh
##
## Nautilus
## SCRIPT: dvd12_DVDtoAVI_mencoder.sh
##
## PURPOSE: Dump-convert a (video) DVD to a '.avi' file
##          --- MPEG4-MP3-AVI video-audio-container.
##
## METHOD:  Uses 'zenity --entry' to prompt for the ID of a DVD drive.
##
##          (May need to add a prompt for the '-xy' parm of 'mencoder'.)
##
##          Uses 'mencoder' with '-ovc' and '-oac' parms to make
##          a '.avi' container file with mpeg4 video and mp3 audio.
##
##          Shows the '.avi' file in a movie player (ffplay).
##
##       REFERENCE: The 'mencoder' code is from the 2011feb07 web page
##           http://www.cyberciti.biz/tips/linux-dvd-ripper-software.html
##
## HOW TO USE: In Nautilus, select ANY file in ANY directory.
##             Then right-click and choose to run this script (name above).
##
##########################################################################
## Started: 2011dec12 
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

The 'mencoder' dump-conversion process will be started in a terminal
window so that startup and encoding messages can be watched.

When 'mencoder' is finished, CLOSE the terminal window.
The output file, if good, could be shown in a video player." \
   --entry-text "1")

if test "$NDVD" = ""
then
   exit
fi


####################################################################
## Prepare the output '.avi' filename --- in /tmp.
####################################################################

FILEOUT="/tmp/${USER}_mencoder_dvd2avi.avi"

if test -f "$FILEOUT"
then
   rm -f "$FILEOUT"
fi

##########################################################
## Use 'mencoder' to make the '.avi' file.
##########################################################

xterm -hold -fg white -bg black -geometry 90x48+100+100 -e \
      mencoder dvd://$NDVD -ovc lavc \
      -lavcopts vcodec=mpeg4:vhq:vbitrate="1200" -vf scale \
      -zoom -xy 640 -oac mp3lame -lameopts br=128 \
      -o "$FILEOUT"

## This code is from the 2011feb07 web page
## http://www.cyberciti.biz/tips/linux-dvd-ripper-software.html

## Change '-xy' parm?  or prompt for it?

###########################################################
## Show the '.avi' file (when user closes the xterm window).
##      (May need to change this, say to simply show
##       AVI file properties.)
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
