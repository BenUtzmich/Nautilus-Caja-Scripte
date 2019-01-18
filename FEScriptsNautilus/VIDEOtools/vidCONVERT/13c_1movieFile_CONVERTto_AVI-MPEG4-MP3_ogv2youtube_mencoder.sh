#!/bin/sh
##
## Nautilus
## SCRIPT: 13am1_1movieFile_CONVERTto_AVI-MPEG4-MP3_ogv2youtube_mencoder.sh
##
## PURPOSE: Converts a movie file to a '.avi' movie file, using 'mencoder'.
##          
##          These 'mencoder' parms were reportedly used to  convert a
##          '.ogv' (Ogg Theora) movie file (from gtk-recordMyDesktop) to
##          a '.avi' movie file (for upload to YouTube).
##
## METHOD:  There are no prompts to the user --- any parms such as bitrates
##          are hard-coded.
##
##          Uses 'mencoder' with parms including '-oac mp3lame' to specify the
##          audio codec and '-ovc lavc' with '-lavcopts vcodec=mpeg4'
##          to specify the video codec.
##
##          Shows the output '.avi' file in a movie player.
##
## REFERENCE: http://ubuntuforums.org/archive/index.php/t-1500992.html
##            in particular, the command
##      mencoder source.ogv -o output.avi -oac mp3lame -lameopts \
##      fast:preset=standard -ovc lavc -lavcopts vcodec=mpeg4:vbitrate=4000
##
##
## HOW TO USE: In Nautilus, select a movie file.
##             Then right-click and choose this VIDEOtools script to run
##             (name above).
##
########################################################################################
## Started: 2011apr20
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
## WE COULD
## Check that the selected file is a valid input movie file via its suffix.
##     (Assumes just one dot [.] in the filename, at the extension.)
#####################################################################

# FILEEXT=`echo "$FILENAME" | cut -d\. -f2`
 
#  if test "$FILEEXT" != "ogv" -a  "$FILEEXT" != "ogg"
#  then
#     exit
#  fi


####################################################################
## Prepare the output '.avi' filename.
##    (Assumes just one dot [.] in the filename, at the extension.)
####################################################################

FILENAMECROP=`echo "$FILENAME" | cut -d\. -f1`

# FILEOUT="${FILENAMECROP}_${FILEEXT}2avi_FROMmencoder.avi"
FILEOUT="${FILENAMECROP}_ogv2avi_FROMmencoder.avi"

if test -f "$FILEOUT"
then
   rm -f "$FILEOUT"
fi

##########################################################
## Use 'mencoder' to make the '.avi' file.
##     See web page referenced above.
##########################################################

xterm -hold -fg white -bg black -geometry 90x48+100+100 -e \
      mencoder "$FILENAME" -o "$FILEOUT" -oac mp3lame -lameopts \
      fast:preset=standard -ovc lavc -lavcopts vcodec=mpeg4:vbitrate=4000

## Also may try
##   mencoder -idx "$FILENAME" -ovc lavc -oac mp3lame -o "$FILEOUT"
## as seen in the video at
## http://www.youtube.com/watch?v=ByLcVpAsqDE&feature=related


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
