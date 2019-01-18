#!/bin/sh
##
## Nautilus
## SCRIPT: 13fm3_1movieFile_CONVERTto_FLV-FLV-MP3_vob2flv_mencoder.sh
##
## PURPOSE: Convert a movie file to a '.flv' container movie file.
##          Uses 'mencoder'.
##
##          These 'mencoder' parms were reportedly used to  convert a
##          '.vob' (from DVD) movie file to a '.flv' container movie file.
##
## METHOD:  There are no prompts to the user --- any parms such as bitrates
##          are hard-coded.
##
##          Uses 'mencoder' with parms including '-oac mp3lame' to specify the
##          audio codec and '-ovc lavc' with '-lavcopts vcodec=flv'
##          to specify the video codec.
##
##          Shows the '.flv' file in a movie player.
##
## REFERENCES:
##          These 'mencoder' options come FROM an example on web page (2009):
##          http://linux-issues.blogspot.com/2009/05/converting-vob-to-flv-format.html
##            where the '.vob' file was created with 'mplayer' using
##            the command:
##              mplayer dvd://1 -dumpstream -dumpfile myvideo.vob
##
##
## HOW TO USE: In Nautilus, select a movie file.
##             Then right-click and choose this VIDEOtools script to run
##             (name above).
##
#######################################################################
## Started: 2010oct31
## Changed: 2011may11
## Changed: 2012may24 Changed script name in comments above and touched up
##                    the comments. Changed some indenting below.
##############################################################################

## FOR TESTING: (display statements that are executed)
# set -x

###########################################
## Get the filename of the selected file.
###########################################

# FILENAME="$@"
# FILENAMES="$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS"

FILENAME="$1"


#####################################################################
## Check that the selected file is an mpeg movie file via its suffix.
##     (Assumes just one dot [.] in the filename, at the extension.)
## COMMENTED.
#####################################################################

#  FILEEXT=`echo "$FILENAME" | cut -d\. -f2`
 
#  if test "$FILEEXT" != "mp4" -a  "$FILEEXT" != "mpg"
#  then
#     exit
#  fi


####################################################################
## Prepare the output '.flv' filename --- in /tmp.
##    (Assumes just one dot [.] in the filename, at the extension.)
####################################################################

FILENAMECROP=`echo "$FILENAME" | cut -d\. -f1`

FILEOUT="/tmp/${FILENAMECROP}_new.flv"

if test -f "$FILEOUT"
then
   rm -f "$FILEOUT"
fi


##########################################################
## Use 'mencoder' to make the '.flv' file.
##########################################################

xterm -hold -fg white -bg black -geometry 90x24+100+100 -e \
   mencoder "$FILENAME" -o "$FILEOUT" \
      -of lavf -ovc lavc \
      -lavcopts vcodec=flv:vbitrate=150 -ofps 25 \
      -oac mp3lame -lameopts abr:br=32 -srate 44100 \
      -vf scale=720

## These options come FROM an example on web page (2009):
## http://linux-issues.blogspot.com/2009/05/converting-vob-to-flv-format.html
##
##   mplayer dvd://1 -dumpstream -dumpfile myvideo.vob
##   mencoder myvideo.vob -of lavf -ovc lavc \
##            -lavcopts vcodec=flv:vbitrate=150 -ofps 25 \
##            -oac mp3lame -lameopts abr:br=32 -srate 44100 \
##            -vf scale=720 -o outputfile.flv
##
## accompanied by the note:
##  The "flv" format files can only support 8000, 22050 and 44100 I believe for
##  the available -srate.


###########################################################
## Show the movie file (when user closes the xterm window).
###########################################################

if test ! -f "$FILEOUT"
then
   exit
fi

# MOVIEPLAYER="/usr/bin/vlc"
# MOVIEPLAYER="/usr/bin/mplayer"
# MOVIEPLAYER="/usr/bin/gmplayer -vo xv"
# MOVIEPLAYER="/usr/bin/smplayer"
# MOVIEPLAYER="/usr/bin/totem"

MOVIEPLAYER="/usr/bin/ffplay -stats"

xterm -fg white -bg black -hold -geometry 90x24+100+100 \
      -e $MOVIEPLAYER "$FILEOUT"

#########################################################
## Use a user-specified MOVIEPLAYER.  Someday?
#########################################################

# . $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
# . $DIR_NautilusScripts/.set_VIEWERvars.shi

# $MOVIEPLAYER "$FILEOUT" &
