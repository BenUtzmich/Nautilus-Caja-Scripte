#!/bin/sh
##
## Nautilus
## SCRIPT: 13kf1_1movieFile_CONVERTto_MKV-X264-COPY_ogv2youtube_ffmpeg.sh
##
## PURPOSE: Converts a movie file to an '.mkv' movie file with a
##          H.264 video stream.  Uses 'ffmpeg'.
##
##          These 'ffmpeg' parms were reportedly used to  convert a
##          '.ogv' (Ogg Theora) movie file (from gtk-recordMyDesktop) to
##          a '.mkv' container movie file (for upload to YouTube).
##
## METHOD:  There are no prompts to the user --- any parms such as bitrates
##          are hard-coded.
##
##          Uses 'ffmpeg' with parm '-vcodec libx264' for the video codec
##          and with an output file with '.mkv' as the suffix.
##
##          Shows the '.mkv' file in a movie player.
##
## REFERENCES: 
##          See http://ubuntuforums.org/archive/index.php/t-1584154.html
##       OR
##          do a web search on keywords such as 'ffmpeg mkv libx264 vcodec'.
##
## HOW TO USE: In Nautilus, select a movie file.
##             Then right-click and choose this VIDEOtools script to run
##             (name above).
##
##########################################################################
## Started: 2011apr20
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
## Check that the selected file is a 'supported' movie input file,
## via its suffix.
##     (Assumes just one dot [.] in the filename, at the extension.)
## COMMENTED.
#####################################################################

#  FILEEXT=`echo "$FILENAME" | cut -d\. -f2`
 
#  if test "$FILEEXT" != "ogv" -a  "$FILEEXT" != "ogg"
#  then
#     exit
#  fi


####################################################################
## Prepare the output '.mkv' filename --- in /tmp.
##    (Assumes just one dot [.] in the filename, at the extension.)
####################################################################

FILENAMECROP=`echo "$FILENAME" | cut -d\. -f1`

FILEOUT="/tmp/${FILENAMECROP}_new_FROMffmpeg.mkv"

if test -f "$FILEOUT"
then
   rm -f "$FILEOUT"
fi

##########################################################
## Use 'ffmpeg' to make the '.mkv' file.
##########################################################

xterm -hold -fg white -bg black -geometry 90x48+100+100 -e \
      ffmpeg -i "$FILENAME" \
            -vcodec libx264 \
            -vpre medium \
            -crf 24 \
            -threads 0 -acodec copy "$FILEOUT"

## FROM http://ubuntuforums.org/archive/index.php/t-1584154.html
## the ffmpeg command
##    ffmpeg -i video-xx.ogv -vcodec libx264 -vpre medium -crf 24 \
##           -threads 0 -acodec copy video-xx.mkv
## is said to work. NOPE. It gives same 'Could not find codec parameters' msgs
## as seen in error messages below.
## Need fully-qualified filename for '-vpre'??   Examples:
##           -vpre /usr/share/ffmpeg/libx264-lossless_medium.ffpreset
##   OR
##           -vpre /usr/share/ffmpeg/libx264-lossless_slow.ffpreset

## I tried the (minimalist) command
##         ffmpeg -i /home/irv/Desktop/xxx.ogv /home/irv/Desktop/xxx3.avi
## FROM http://ubuntuforums.org/archive/index.php/t-1500992.html
##
## Tne minimalist command
##      ffmpeg -i "$FILENAME" "$FILEOUT"
## DID NOT WORK on an ogv file from recordMyDesktop. Gives the error msgs:
## [ogg @ 0x9526700]Could not find codec parameters (Invalid Codec type -1)
## [ogg @ 0x9526700]Could not find codec parameters (Video: theora, 1024x720)


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
