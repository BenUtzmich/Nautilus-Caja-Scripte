#!/bin/sh
##
## Nautilus
## SCRIPT: 13am2_1movieFile_CONVERTto_AVI-MSMPEG4V2-LAVC_flv2avi_mencoder.sh
##
## PURPOSE: Convert a movie file to a '.avi' movie file with 'msmpeg4v2'
##          video encoding and 'lavc' audio encoding.  Uses 'mencoder'.
##          
##          These 'mencoder' parms were reportedly used to convert a
##          '.flv' container movie file to a '.avi' container movie file.
##
## METHOD:  There are no prompts to the user --- any parms such as bitrates
##          are hard-coded.
##
##          Uses 'mencoder' with parms including '-oac lavc' with
##          '-lavcopts acodec=mp3' to specify the audio codec and '-ovc lavc'
##          with '-lavcopts vcodec=msmpeg4v2' to specify the video codec.
##
##          Shows the '.avi' file in a movie player.
##
## REFERENCES:
##          These 'mencoder' options came FROM an example on web page: 
##          http://www.mydigitallife.info/2006/03/19/convert-flash-video-flv-files-to-mpg-or-avi-and-other-media-formats/
##       OR
##          Google the string 'vcodec=msmpeg4v2:acodec=mp3:abitrate=64'
##          and you will find lots of examples. (717 hits in 2011may)
##       OR 
##          see http://ubuntuforums.org/archive/index.php/t-1074152.html  (2009)
##
## HOW TO USE: In Nautilus, select a movie file.
##             Then right-click and choose this VIDEOtools script to run
##             (name above).
##
###############################################################################
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
## Check that the selected file is a 'flv' movie file via its suffix.
##     (Assumes just one dot [.] in the filename, at the extension.)
## COMMENTED.
#####################################################################

#  FILEEXT=`echo "$FILENAME" | cut -d\. -f2`
 
#  if test "$FILEEXT" != "flv"
#  then
#     exit
#  fi


####################################################################
## Prepare the output '.avi' filename --- in /tmp.
##    (Assumes just one dot [.] in the filename, at the extension.)
####################################################################

FILENAMECROP=`echo "$FILENAME" | cut -d\. -f1`

FILEOUT="/tmp/${FILENAMECROP}_new.avi"

if test -f "$FILEOUT"
then
   rm -f "$FILEOUT"
fi


##########################################################
## Use 'mencoder' to make the 'avi' file.
##########################################################

xterm -hold -fg white -bg black -geometry 90x24+100+100 -e \
      mencoder "$FILENAME" -ofps 15 -vf scale=300:-2 \
               -oac lavc -ovc lavc \
               -lavcopts vcodec=msmpeg4v2:acodec=mp3:abitrate=64 \
               -o "$FILEOUT"

## These options came FROM an example on web page: 
## http://www.mydigitallife.info/2006/03/19/convert-flash-video-flv-files-to-mpg-or-avi-and-other-media-formats/

## Google the string 'vcodec=msmpeg4v2:acodec=mp3:abitrate=64'
## and you will find lots of examples. (717 hits in 2011may)

## ALTERNATIVE:
##
# mencoder "$FILENAME" -forceidx -mc 0 -noskip -skiplimit 0 \
#          -ovc lavc -lavcopts vcodec=msmpeg4v2:vhq -o "$FILEOUT"
##
## OR
##
# mencoder "$FILENAME" -forceidx -mc 0 -noskip -skiplimit 0 \
#          -ovc lavc -lavcopts vcodec=mpeg4:vhq:mbd=2:trell:v4mv:vbitrate=9800 \
#          -o "$FILEOUT"
##
## FROM (2009): http://ubuntuforums.org/archive/index.php/t-1074152.html


## ALTERNATIVE:
##
#  mencoder "$FILENAME" -mc 0 -noskip -vf harddup \
#           -oac twolame -twolameopts br=56 -ovc lavc -o "$FILEOUT"
##
## FROM:
## http://www.linuxquestions.org/questions/linux-software-2/converting-flv-to-mpg-with-audio-and-ffmpeg-646876/


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
