#!/bin/sh
##
## Nautilus
## SCRIPT: 13waf1_1movieFile_CONVERTto_ASF-WMV2-WMAV2_flv2wmv_ffmpeg.sh
##
## PURPOSE: Convert a movie file to a '.asf' container movie file ---
##          with a WMV2 video stream and a WMAV2 audio stream ---
##          using 'ffmpeg'.
##
## METHOD:  There are no prompts to the user --- any parms such as bitrates
##          are hard-coded.
##
##          Uses 'ffmpeg' with parms including: 
##          1.  '-f asf' for container format
##          2.  '-vcodec wmv2' and '-sameq' for video encoding
##          3.   -acodec wmav2' for audio encoding
##
##          Shows the '.asf' file in a movie player.
##
## REFERENCES:
##       These 'ffmpeg' options come FROM an example on (2009) web page: 
##       http://ubuntuforums.org/archive/index.php/t-1074152.html
##   OR
##       do a web search on keywords such as 'ffmpeg asf wmv2 wmav2'.
##
##
## HOW TO USE: In Nautilus, select a movie file.
##             Then right-click and choose this VIDEOtools script to run
##             (name above).
##
#########################################################################
## Started: 2010oct31
## Changed: 2012may24 Changed script name in comments above and touched up
##                    the comments. Changed some indenting below.
############################################################################

## FOR TESTING: (display statements that are executed)
# set -x

###########################################
## Get the filename of the selected file.
###########################################

# FILENAME="$@"
# FILENAMES="$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS"

FILENAME="$1"


#####################################################################
## Check that the selected file is a 'supported' movie file,
## via its suffix.
##     (Assumes just one dot [.] in the filename, at the extension.)
#####################################################################

#  FILEEXT=`echo "$FILENAME" | cut -d\. -f2`
 
#  if test "$FILEEXT" != "flv" -a  "$FILEEXT" != "mpg"
#  then
#     exit
#  fi


####################################################################
## Prepare the output '.asf' filename --- in /tmp.
##    (Assumes just one dot [.] in the filename, at the extension.)
####################################################################

FILENAMECROP=`echo "$FILENAME" | cut -d\. -f1`

FILEOUT="/tmp/${FILENAMECROP}_new.asf"

if test -f "$FILEOUT"
then
   rm -f "$FILEOUT"
fi

##########################################################
## Use 'ffmpeg' to make the '.asf' file.
##########################################################

xterm -hold -fg white -bg black -geometry 90x24+100+100 -e \
      ffmpeg -i "$FILENAME" -f asf \
            -vcodec wmv2 -sameq \
            -acodec wmav2 "$FILEOUT"

## These options come FROM an example on (2009) web page: 
## http://ubuntuforums.org/archive/index.php/t-1074152.html


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
