#!/bin/sh
##
## Nautilus
## SCRIPT: 13ff1_1movieFile_CONVERTto_FLV-COPY-COPY_mov2flv_ffmpeg.sh
##
## PURPOSE: Convert a movie file to a '.flv' movie file, copying
##          the video and audio streams in the same format.  Uses 'ffmpeg'.
##
##          These 'ffmpeg' parms were reportedly used to  convert a
##          '.mov' (Apple format) movie file to a '.flv' container movie file.
##
## METHOD:  There are no prompts to the user --- any parms such as bitrates
##          are hard-coded.
##
##          Uses 'ffmpeg' with parms including '-f flv' and a couple of
##          audio rate parms.
##
##          Shows the '.flv' file in a movie player.
##
## REFERENCES: 
##         These 'ffmpeg' options come FROM an example on web page: 
##         http://jamestombs.co.uk/2008-07-18/converting-video-avi-mov-mpg-mp4-to-flv-using-ffmpeg/531
##         where it was said
##     "I used these settings to convert some 500MB+ Apple Quicktime (MOV)
##      files down to ~20MB FLV which were perfect for uploading to YouTube."
##    OR
##         do a web search with keywords like 'ffmpeg flv copy'
##
##
## HOW TO USE: In Nautilus, select a movie file.
##             Then right-click and choose this VIDEOtools script to run
##             (name above).
##
#########################################################################
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
 
#  if test "$FILEEXT" != "mov" -a "$FILEEXT" != "mp4" -a "$FILEEXT" != "mpg"
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
## Use 'ffmpeg' to make the 'flv' file.
##########################################################

xterm -hold -fg white -bg black -geometry 90x24+100+100 -e \
       ffmpeg -i "$FILENAME" -f flv -ab 128k -ar 44100 "$FILEOUT" 

## These options come FROM an example on web page: 
## http://jamestombs.co.uk/2008-07-18/converting-video-avi-mov-mpg-mp4-to-flv-using-ffmpeg/531
## where it was said
## "I used these settings to convert some 500MB+ Apple Quicktime (MOV)
## files down to ~20MB FLV which were perfect for uploading to YouTube."

## ALTERNATIVE:
##
# ffmpeg -i "$FILENAME" -f flv -acodec libfaac -ab 156k -b 1024k "$FILEOUT"
##
## FROM (2008): http://www.catswhocode.com/blog/19-ffmpeg-commands-for-all-needs


## ALTERNATIVE - used for converting MP4 to FLV:
##
# ffmpeg -i "$FILENAME" -ar 44100 "$FILEOUT"
##
## FROM (2009): http://linux-issues.blogspot.com/2009/05/converting-vob-to-flv-format.html
##


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
