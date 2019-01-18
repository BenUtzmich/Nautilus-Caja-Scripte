#!/bin/sh
##
## Nautilus
## SCRIPT: 13fm1_1movieFile_CONVERTto_FLV-MP3-FLV_mp4TOflv_mencoder.sh
##
## PURPOSE: Convert a movie file to a '.flv' Flash container movie file.
##          Uses 'mencoder'.
##
##          These 'mencoder' parms were reportedly used to  convert a
##          '.mp4' container movie file to a '.flv' container movie file.
##
## METHOD: There are no prompts to the user --- any parms such as bitrates
##          are hard-coded.
##
##          Uses 'mencoder' with parms including '-oac mp3lame' to specify the
##          audio codec and '-ovc lavc' with '-lavcopts vcodec=flv'
##          to specify the video codec.
##
##          Shows the '.flv' file in a movie player.
##
## REFERENCES:
##         These 'mencoder' options come FROM an example on web page: 
##         http://www.zimbio.com/mp4+Converter/articles/109/Convert+mp4+flv+using+mencoder
##     OR
##         do a web search on keywords such as 'mencoder flv ovc lavc vcodec'.
##
##
## HOW TO USE: In Nautilus, select a movie file.
##             Then right-click and choose this VIDEOtools script to run
##             (name above).
##
###########################################################################
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
## Check that the selected file is a 'supported' movie file
## via its suffix.
##     (Assumes just one dot [.] in the filename, at the extension.)
## COMMENTED.
#####################################################################

#  FILEEXT=`echo "$FILENAME" | cut -d\. -f2`
 
#  if test "$FILEEXT" != "mp4"
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
## Use 'mencoder' to make the 'flv' file.
##########################################################

xterm -hold -fg white -bg black -geometry 90x48+100+100 -e \
      mencoder "$FILENAME" -o "$FILEOUT" -of lavf \
      -oac mp3lame -lameopts abr:br=56 \
      -ovc lavc \
      -lavcopts vcodec=flv:vbitrate=800:mbd=2:mv0:trell:v4mv:cbp:last_pred=3 \
      -srate 22050 -ofps 24 -vf harddup

## These option come FROM an example on web page: 
## http://www.zimbio.com/mp4+Converter/articles/109/Convert+mp4+flv+using+mencoder


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
