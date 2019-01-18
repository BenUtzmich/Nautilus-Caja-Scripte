#!/bin/sh
##
## Nautilus
## SCRIPT: vjM1_multi-mpg-files_JOIN_cat-ffmpeg-f-vcopy-acopy.sh
##
## PURPOSE: Uses 'cat' and 'ffmpeg' to merge multiple '.mpg' movie files.
##
## METHOD:  In a 'for' loop, puts the selected movie filenames in a string
##          --- space-separated and each filename in double-quotes.
##
##          Uses 'eval cat' to concatenate the selected '.mpg' files into
##          one temporary '.mpg' which is piped to 'ffmpeg'.
##
##          'ffmpeg' takes the concatenated '.mpg' file, via the pipe,
##          and uses the parms '-vcodec copy -acodec copy' to create the
##          'final' '.mpg' file.
##
##          Puts the messages from 'ffmpeg' into a text file and shows
##          the text file with a text-file viewer of the user's choice.
##
##          Shows the 'final' '.mpg' file in a movie player.
##
## REFERENCE: http://www.phpfreaks.com/forums/index.php?topic=195674.0
##            which shows an example using 'cat' and 'ffmpeg':
##
##    cat orig1.mpg orig2.mpg | ffmpeg -f mpeg  -i -  -vcodec copy \
##              -acodec copy  merged.mpg
##
## Alternatively,
##     do a web search on keywords such as
##              'ffmpeg cat mpg vcodec acodec copy (join|merge)'
##
##
## HOW TO USE: In Nautilus, select one or more '.mpg' movie files (of the same
##             video-audio encoding. (Can use the Ctl or Shift
##             keys to select multiple files.)
##             Then right-click and choose this VIDEOtools script to run
##             (name above).
##
########################################################################
## Started: 2012feb09
## Changed: 2012may24 Changed script name in comments above and touched up
##                    the comments. Changed some indenting below.
## Changed: 2012jun19 Put output file in curdir instead of /tmp, and
##                    build output filename from last input filename.
##                    Also put msgs file in urdir instead of /tmp, and
##                    build msgs filename from last input filename.
##########################################################################

## FOR TESTING: (display statements that execute)
# set -x


###################################################
## START a LOOP on the selected filenames, to
## put the names in a variable, INPUTFILES.
##     (Quote the filenames, in case they
##      contain embedded spaces.)
## We also check that the files have the same suffix
## (.mpg), i.e. are (probably) the same movie type
## and are probably an MPEG type which can be joined
## with 'cat'.
##################################################

INPUTFILES=""
CNT=1
FILEEXT1="mpg"

for FILENAME
do

   ######################################################
   ## Get the extension of the each selected movie file.
   ##
   ##     Assumes that there is only one period
   ##     in the filename --- at the extension.
   ######################################################

   FILEEXT=`echo "$FILENAME" | cut -d\. -f2`

   ###########################################################
   ## For the selected files, check that their extension
   ## matches $FILEEXT1.
   ###########################################################

   if test ! "$FILEEXT" = "$FILEEXT1"
   then
      zenity --info \
         --title "FILE EXTENSION IS QUESTIONABLE.  EXITING ..." \
         --text "\
File $FILENAME
is not a '.$FILEEXT1' suffix file.

Exiting ..."
      exit
   fi
   ## END OF if test ! "$FILEEXT" = "$FILEEXT1"


   ###################################################
   ## Add $FILENAME to the string of input filenames
   ## --- with names separated by a space character.
   ##################################################

   INPUTFILES="$INPUTFILES \"$FILENAME\""

   CNT=`expr $CNT + 1`

done
## END OF LOOP: for FILENAME


###############################################################
## Prepare the output movie filename --- in the /tmp directory.
## Use $FILEEXT1 as the extension for the output movie file.
##############################################################

FILENAMECROP=`echo "$FILENAME" | cut -d\. -f1`

# OUTFILE="/tmp/${USER}_cat-ffmpeg-merged_${FILEEXT1}_files.$FILEEXT1"
OUTFILE="${FILENAMECROP}_cat-ffmpeg-MERGED.$FILEEXT1"

if test -f "$OUTFILE"
then
   rm -f "$OUTFILE"
fi


############################################################
## Prepare the 'cat' err-messages filename.
############################################################

# OUTLIST="/tmp/${USER}_cat-ffmpeg-merged_${FILEEXT1}_files_msgs.lis"
OUTLIST="${FILENAMECROP}_cat-ffmpeg-MERGED_files_msgs.lis"

if test -f "$OUTLIST"
then
   rm -f "$OUTLIST"
fi


###########################################
## MERGE the files with 'cat' and 'ffmpeg'.
###########################################

## FOR TESTING:
# set -x

eval cat  $INPUTFILES | ffmpeg -f mpeg -i - -vcodec copy -acodec copy \
     "$OUTFILE" 2> "$OUTLIST"

## FOR TESTING:
# set -


#######################################
## Show the 'cat' err-messages file.
#######################################

. $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
. $DIR_NautilusScripts/.set_VIEWERvars.shi

# if test ! -s "$OUTLIST"
# then
   $TXTVIEWER "$OUTLIST" &
# fi


##############################
## Show the merged movie file.
##############################

if test ! -f "$OUTFILE"
then
   exit
fi

# MOVIEPLAYER="/usr/bin/vlc"
# MOVIEPLAYER="/usr/bin/gnome-mplayer"
# MOVIEPLAYER="/usr/bin/gmplayer -vo xv"
# MOVIEPLAYER="/usr/bin/totem"

MOVIEPLAYER="/usr/bin/ffplay -stats"

xterm -fg white -bg black -hold -geometry 90x24+100+100 -e \
      $MOVIEPLAYER "$OUTFILE"

#########################################################
## Use a user-specified MOVIEPLAYER.  Someday?
#########################################################

# . $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
# . $DIR_NautilusScripts/.set_VIEWERvars.shi

# $MOVIEPLAYER "$OUTFILE" &
