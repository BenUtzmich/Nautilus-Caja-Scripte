#!/bin/sh
##
## Nautilus
## SCRIPT: 13m1m1_1movieFile_CONVERTto_MPG-MPEG1VID-COPY_mencoder.sh
##
## PURPOSE: Convert a  movie file to an '.mpg' container movie file with
##          'mpeg1' video encoding.  Uses 'mencoder'.
##
##
## METHOD:  There are no prompts to the user --- any parms such as bitrates
##          are hard-coded.
##
##          Uses 'mencoder' with parms including '-of mpeg' for the container
##          format and '-ovc lavc -lavcopts vcodec=mpeg1video' for the
##          video encoding and '-oac copy' for the audio encoding.
##
##          Shows the '.mpg' in a movie player.
##
## REFERENCES:  These 'encoder' options come FROM web page:
##              http://www.debianhelp.org/node/9448
##          Alternatively,
##              do a web search on keywords such as 'mencoder mpeg1 mpg'.
##
##
## HOW TO USE: In Nautilus, select a movie file.
##             Then right-click and choose this VIDEOtools script to run
##             (name above).
##
##     NOTE on TESTING:
##       This script needs to be tested on a wide variety of types of
##       input file, such as 'flv', 'wmv', 'avi', and 'mov' container files.
##       May need to use different 'mencoder' parms for some of these
##       input formats.
##
############################################################################
## Started: 2010oct31
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
## Check that the selected file is a 'supported' movie file,
## via its suffix.
##     (Assumes just one dot [.] in the filename, at the extension.)
## COMMENTED.
#####################################################################

#  FILEEXT=`echo "$FILENAME" | cut -d\. -f2`
 
#  if test "$FILEEXT" != "flv" -a "$FILEEXT" != "wmv" -a \
#          "$FILEEXT" != "avi" -a "$FILEEXT" != "mov"
#  then
#     exit
#  fi


####################################################################
## Prepare the output '.mpg' filename --- in /tmp.
##    (Assumes just one dot [.] in the filename, at the extension.)
####################################################################

FILENAMECROP=`echo "$FILENAME" | cut -d\. -f1`

FILEOUT="/tmp/${FILENAMECROP}_new.mpg"

if test -f "$FILEOUT"
then
   rm -f "$FILEOUT"
fi


##########################################################
## Use 'mencoder' to make the 'mpg' file.
##########################################################

xterm -hold -fg white -bg black -geometry 90x24+100+100 -e \
      mencoder "$FILENAME" -of mpeg \
            -ovc lavc -lavcopts vcodec=mpeg1video \
            -oac copy -o "$FILEOUT"

## These options come FROM web page:
## http://www.debianhelp.org/node/9448


########################
## Show the movie file.
########################

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
