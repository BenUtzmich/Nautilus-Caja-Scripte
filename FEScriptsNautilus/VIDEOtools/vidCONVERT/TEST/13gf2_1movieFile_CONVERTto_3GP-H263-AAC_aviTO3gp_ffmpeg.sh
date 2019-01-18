#!/bin/sh
##
## Nautilus
## SCRIPT: 13gf2_1movieFile_CONVERTto_3GP-H263-AAC_aviTO3gp_ffmpeg.sh
##
## PURPOSE: Convert an movie file to a '.3gp' file, suitable for
##          mobile phones. Uses 'ffmpeg'.
##
##          These 'ffmpeg' parms were reportedly used to  convert a
##          '.avi' container movie file to a small-format 
##          '.3gp' movie file for use on a mobile phone.
##
## METHOD:  There are no prompts to the user --- any parms such as bitrates
##          are hard-coded.
##
##          Uses 'ffmpeg' with parms including '-s qcif' (image size 176x144)
##          and '-vcodec h263' for the video codec and '-r 25' for the
##          frame rate and '-acodec aac' for the audio codec.
##
##          Shows the '.3gp' file in a movie player.
##
## REFERENCES:
##          These 'ffmpeg' options come FROM an example on web page: 
##          http://goinggnu.wordpress.com/2007/02/13/convert-avi-to-3gp-using-ffmpeg/
##       OR
##          see  http://rolandmai.com/node/23    (circa 2008?)
##       OR
##          see the 2010oct response at bottom of 2008-posted page
##          http://www.catswhocode.com/blog/19-ffmpeg-commands-for-all-needs
##       OR
##          do a web search on keywords such as 'ffmpeg 3gp'
##
##
## HOW TO USE: In Nautilus, select a movie file.
##             Then right-click and choose this VIDEOtools script to run
##             (name above).
##
##########################################################################
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
## Check that the selected file is a 'supported' movie file,
## via its suffix.
##     (Assumes just one dot [.] in the filename, at the extension.)
#####################################################################

#  FILEEXT=`echo "$FILENAME" | cut -d\. -f2`
 
#  if test "$FILEEXT" != "mpg" -a  "$FILEEXT" != "avi"
#  then
#     exit
#  fi


####################################################################
## Prepare the output '.3gp' filename --- in /tmp.
##    (Assumes just one dot [.] in the filename, at the extension.)
####################################################################

FILENAMECROP=`echo "$FILENAME" | cut -d\. -f1`

FILEOUT="/tmp/${FILENAMECROP}_new.3gp"

if test -f "$FILEOUT"
then
   rm -f "$FILEOUT"
fi


##########################################################
## Use 'ffmpeg' to make the '.3gp' file.
## Note the low audio parm values.
##########################################################

xterm -hold -fg white -bg black -geometry 90x48+100+100 -e \
      ffmpeg -i "$FILENAME" \
            -s qcif -vcodec h263 -r 25 \
            -acodec aac -ar 22050 -ab 128k -ac 1 "$FILEOUT"

## These options come FROM an example on web page: 
## http://goinggnu.wordpress.com/2007/02/13/convert-avi-to-3gp-using-ffmpeg/

## ALTERNATIVE:
##
# ffmpeg -y -i "$FILENAME" -vcodec mpeg4 -s 480x320 -r 15 -b 700k \
#        -acodec libfaac -ac 2 -ar 32000 -ab 64k -f 3gp "$FILEOUT"
##
## FROM 2010oct response at bottom of 2008-posted page
## http://www.catswhocode.com/blog/19-ffmpeg-commands-for-all-needs


## Another ALTERNATIVE, for flv to 3gp for phone:
##
# ffmpeg -i "$FILENAME" -s qcif -vcodec h263 -r 10 -b 180k -sameq \
#        -acodec libfaac -ab 64k -ar 22050 -ac 1 "$FILEOUT"
##
## FROM (2008?): http://rolandmai.com/node/23


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
