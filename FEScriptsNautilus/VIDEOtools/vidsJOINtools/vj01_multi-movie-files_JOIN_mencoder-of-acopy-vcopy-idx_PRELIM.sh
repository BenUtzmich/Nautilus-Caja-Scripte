#!/bin/sh
##
## Nautilus
## SCRIPT: vj01_multi-movie-files_JOIN_mencoder-of-acopy-vcopy-idx_PRELIM.sh
##
## PURPOSE: Uses 'mencoder' to merge multiple same-format movie files ---
##          such as flv, avi, mpg, wmv, etc.
##
## METHOD:  In a 'for' loop, puts the selected movie filenames in a string
##          --- space-separated and each filename in double-quotes.
##
##          Sets the output file container-format based on the extension of
##          the 'first' file of the selected movie files.
##
##          Passes the string of selected filenames to 'mencoder' ---
##          which is run, using 'eval',  with parms '-oac copy -ovc copy -idx'.
##
##          Puts the messages from 'mencoder' into a text file and shows
##          the text file with a text-file viewer of the user's choice.
##
##          Shows the merged file in a movie player.
##
## REFERENCES:
##         http://en.wikibooks.org/wiki/Mplayer#Join.2FMerge_multiple_videos
##         says:
##
## "To join two or more video files into one, do this:
##
##      mencoder -oac copy -ovc copy -idx -o whole.avi part1.avi part2.avi ...
##
##  This will only work if the video contained in the files have the same
##  resolution and use the same codec. Of course, this works for any file
##  format that MPlayer can play, not just AVI files. If your files are not
##  AVI files you have to specify the output format '-of'. Otherwise your
##  joined mpeg movies will reside in an AVI container. This is because AVI
##  is the default output format. (To see the available output formats,
##  type 'mencoder -of help'.)"
##
##    Alternatively,
##         do a web search on keywords such as
##              'mencoder (join|merge) (video|movie) multiple files'
##
##
## HOW TO USE: In Nautilus, select one or more movie file (of the same
##             container-video-audio format. (Can use the Ctl or Shift
##             keys to select multiple files.)
##             Then right-click and choose this VIDEOtools script to run
##             (name above).
##
##       NOTE on TESTING:
##           This script needs to be tested on a wide variety of input movie
##           file container types, such as 'avi', 'flv', 'mpeg', 'wmv/asf',
##           'mov', 'mp4', 'matroska' --- and various video and audio
##           encodings in the input movie.
##           May need to use different/added mencoder parms for some of these
##           input formats.
##
#######################################################################
## Started: 2012feb09
## Changed: 2012may24 Changed script name in comments above and touched up
##                    the comments. Changed some indenting below.
##############################################################################

## FOR TESTING: (display statements that execute)
# set -x


###################################################
## START a LOOP on the selected filenames, to
## put the names in a variable, INPUTFILES.
##     (Quote the filenames, in case they
##      contain embedded spaces.)
## We also check that the files have the same
## suffix, i.e. are (probably) the same movie type.
##################################################

INPUTFILES=""
CNT=1

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
   ## for the first file, store its extension in $FILEEXT1.
   ## For the other selected files, check that their extension
   ## matches $FILEEXT1.
   ###########################################################

   if test $CNT = 1
   then
      FILEEXT1="$FILEEXT"
   else
      if test ! "$FILEEXT" = "$FILEEXT1"
      then
         zenity --info \
            --title "FILE EXTENSION MISMATCH.  EXITING ..." \
            --text "\
File $FILENAME
is not a '.$FILEEXT1' suffix file, like the first file.

Exiting ..."
         exit
      fi
   fi
   ## END OF if test $CNT = 1


   ###################################################
   ## Add $FILENAME to the string of input filenames
   ## --- with names separated by a space character.
   ##################################################

   INPUTFILES="$INPUTFILES \"$FILENAME\""

   CNT=`expr $CNT + 1`

done
## END OF LOOP: for FILENAME


############################################################
## Prepare the output movie filename.
## Use $FILEEXT1 as the extension for the output movie file,
## but override it in certain cases.
###########################################################

FILEEXTOUT="avi"

if test "$FILEEXT1" = "avi"
then
   FILEEXTOUT="avi"
fi

if test "$FILEEXT1" = "mpg"
then
   FILEEXTOUT="mpeg"
fi

if test "$FILEEXT1" = "flv"
then
   FILEEXTOUT="flv"
fi

if test "$FILEEXT1" = "wmv"
then
   FILEEXTOUT="asf"
fi

## More exceptions are probably coming.

OUTFILE="/tmp/${USER}_mencoder-MERGED_${FILEEXT1}_files.$FILEEXT1"

if test -f "$OUTFILE"
then
   rm -f "$OUTFILE"
fi


############################################################
## Prepare the output mencoder err-messages filename.
############################################################

OUTLIST="/tmp/${USER}_mencoder-MERGED_${FILEEXT1}_files_mencoder-err-msgs.lis"

if test -f "$OUTLIST"
then
   rm -f "$OUTLIST"
fi


########################################
## MERGE the files with 'mencoder'.
########################################

## FOR TESTING:
# set -x

eval mencoder -of "$FILEEXTOUT" -oac copy -ovc copy -idx -o \
      "$OUTFILE" $INPUTFILES 2> "$OUTLIST"

## FOR TESTING:
# set -


#######################################
## Show the mencoder err-messages file.
#######################################

. $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
. $DIR_NautilusScripts/.set_VIEWERvars.shi

$TXTVIEWER "$OUTLIST" &


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
