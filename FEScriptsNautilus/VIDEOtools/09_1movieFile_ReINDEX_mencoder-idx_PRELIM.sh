#!/bin/sh
##
## Nautilus
## SCRIPT: 01_1movieFile_ReINDEX_mencoder-idx_PRELIM.sh
##
## PURPOSE: Tries to re-index each selected movie using the '-forceidx'
##          (or '-idx') option of the 'mencoder' utility.
##
##          This can sometimes fix 'broken' movie files --- for example,
##          movies for which movie players cannot seem to figure out their length
##          and hence the display of the time-line of the movie is 'broken'. 
##
##          NOTE:
##          The forced-indexing may only work with AVI container files.
##          If that is the case, the string 'ReINDEX' in the script name
##          may be changed to 'ReINDEX-AVI'.
##
## METHOD:  We attempt to make the output clip file in the same format
##          (video-audio) as the input file.
##
##          We use the '-ovc copy -oac copy' mencoder parms. !PRELIMINARY!
##          We may add checks on the input file extension and build the
##          output file extension (container format) based on the input
##          file extension. For example, see a 'CHGaudioVOLUME' '-vcodec' script.
##
##       NOTES on OUTPUT FORMAT:
##       'mencoder' ordinarily chooses the output container format based on
##       the file extension of the output (?) file --- unless the '-of'
##       (container format) option is specified.
##
##       Sometimes making the output file have the same extension as
##       the input file MAY work --- for '.flv' and '.mp4' and '.avi' files.
##       Some input file extensions on the output file may NOT work --- such as
##       '.wmv' or '.ogv' or '.mpg'. However, they may work if '-of' is used with
##       specifications such as 'asf' or 'ogg' or 'mpeg', respectively.
##
##       This script may be enhanced to work by trying to figure out an appropriate
##       value for '-of' from the input file suffix --- and the suffix on the
##       output file may be set to indicate the container format.
##
##       For sample code, see an 'ffmpeg' script like
##           04a_oneMovie_CLIP_vcopy_acopy_ffmpeg.sh
##
##       NOTE on TESTING:
##       This script needs to be tested on a wide variety of movie container formats
##       and file suffixes --- 'mp4', 'mkv', 'avi', 'wmv', 'asf', 'mpg', 'mpeg',
##       'mov', '3gp', and some other movie file formats.
##
##       REFERENCES: 
##       Do a web search on keywords 'mencoder idx' or 'mencoder forceidx' or
##                                   'mencoder broken movie' or ...
##
## HOW TO USE: In Nautilus, select a movie file.
##             Then right-click and choose this script to run (name above).
##
###############################################################################
## Created: 2010oct31
## Changed: 2011jun13 Changed to do only one movie, instead of multiple movies.
##                    I.e. removed the loop, to simplify the code,
##                    in anticipation of having to add a lot of
##                    'if' statements to set a 'container' format for
##                    the output file, using the mencoder '-of' parm.
## Changed: 2011jul07 Removed use of FILENAMES var --- just use FILENAME.
## Changed: 2012may22 Changed script name in comments above and touched up
##                    the comments. Changed some indenting below.
## Changed: 2016oct21 Added some comments above, after finding that this
##                    utility may only work on AVI container files.
###########################################################################

## FOR TESTING: (display commands that are executed)
# set -x

FILENAME="$1"

################################################################
## For the selected file, extracts the file extension and
## the 'middle-name' of the file --- to build the output
## filename of the re-indexed file --- with an extra
## qualifier like '_REINDEXED' added to the output filename.
##
## (Preliminary. May have to check for certain file
##  container/suffix types, like 'avi', supported by 'mencoder'.)
################################################################
##  (Assumes one dot (.) in the filename, at the extension.)
################################################################

FILEEXT=`echo "$FILENAME" | cut -d\. -f2`
FILEMIDNAME=`echo "$FILENAME" | cut -d\. -f1`

##############################################################
## Prepare the output movie filename for this movie file.
##############################################################
   
FILEOUT="${FILEMIDNAME}_REINDEXED.$FILEEXT"

if test -f "$FILEOUT"
then
   rm -f "$FILEOUT"
fi


#############################################################
## Use 'mencoder' to re-index the movie, using
##    '-forceidx' (or '-idx') to re-build the index.
#############################################################

## FOR TESTING: (show the statements as they execute)
# set -x

xterm -hold -fg white -bg black -geometry 90x48+100+100 -e \
      mencoder -forceidx -ovc copy -oac copy \
      -mc 0 -noskip -vf harddup \
      -of lavf \
      "$FILENAME" -o "$FILEOUT"

## Alternatively, try '-idx' instead of '-forceidx'.
 
## REFERENCE for some of these parameters:
## http://forum.videohelp.com/threads/281560-AVI-to-FLV-using-mencoder?s=db3edf03c6bf2ba2e6634d44ac501333
##
## I had to provide the '-of lavf' option to get Mplayer to
## recognize the video component of an input video file that was
## encoded with '-ovc lavc -oac faac'.
##
## A 'zenity' prompt may need to be added to this script to prompt
## for the output container format desired --- such as avi or other.

#########################################
## Show the new (re-indexed) movie file.
#########################################

if test ! -f "$FILEOUT"
then
   exit
fi

# MOVIEPLAYER="/usr/bin/vlc"
# MOVIEPLAYER="/usr/bin/mplayer"
# MOVIEPLAYER="/usr/bin/gnome-mplayer"
# MOVIEPLAYER="/usr/bin/totem"

MOVIEPLAYER="/usr/bin/ffplay -stats"

xterm -fg white -bg black -geometry 90x24+100+100 -hold -e \
      $MOVIEPLAYER "$FILEOUT"

###############################################
## Use a user-specified MOVIEPLAYER. Someday?
###############################################

# . $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
# . $DIR_NautilusScripts/.set_VIEWERvars.shi

# $MOVIEPLAYER "$FILEOUT" &
