#!/bin/sh
##
## Nautilus
## SCRIPT: vj02_multi-movie-files_JOIN_ffmpeg-acopy-vcopy-newvideo_PRELIM.sh
##
## PURPOSE: Uses 'ffmpeg' to merge multiple movie files --- such as
##          avi, mpg, flv, wmv, etc.
##
## METHOD:  Uses 'zenity --list --radiolist' to prompt whether
##          1.  any of the movie files are missing the audio track, OR
##          2.  all of the movie files have an audio track.
##          If neither, the user can cancel.
##
##          In a 'for' loop, puts the selected movie filenames in a string
##          --- space-separated and each filename in double-quotes ---
##          and with '-i' in front of each filename.
##
##          Sets the output file container-format based on the extension of
##          the 'first' file of the selected movie files.
##
##          Passes the string of selected filenames to 'ffmpeg' ---
##          which is run, using 'eval',  with pairs of parms
##          '-acodec copy -vcodec copy' (or '-an -vcodec copy'),
##          one pair for each input movie file.
##
##          Puts the messages from 'ffmpeg' into a text file and shows
##          the text file with a text-file viewer of the user's choice.
##
##          Shows the merged file in a movie player.
##
## REFERENCES:
##         http://manpages.ubuntu.com/manpages/karmic/man1/ffmpeg.1.html
##         says:
##
## "You can put many streams of the same type in the output:
##
##   ffmpeg -i test1.avi -i test2.avi -vcodec copy -acodec copy \
##          -vcodec copy -acodec copy test12.avi -newvideo -newaudio
##
##  In addition to the first video and audio streams, the resulting output
##  file test12.avi will contain the second video and the second audio
##  stream found in the input streams list.
##
##  The "-newvideo", "-newaudio" and "-newsubtitle" options have to be
##  specified immediately after the name of the output file to which you
##  want to add them."
##
##
## HOW TO USE: In Nautilus, select one or more movie files (of the same
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
##           May need to use different/added ffmpeg parms for some of these
##           input formats.
##
############################################################################
## Started: 2012feb09
## Changed: 2012may24 Changed script name in comments above and touched up
##                    the comments. Changed some indenting below.
##############################################################################

## FOR TESTING: (display statements that execute)
# set -x


##############################################################
## Prompt for whether there is audio missing from any of the
## selected movie files.
##############################################################

AUDIOTYPE=""

AUDIOTYPE=$(zenity --list --radiolist \
   --title "Any of the movies MISSING the AUDIO TRACK?" \
   --text "\
Choose one of the following types of audio conditions of the selected
movie files. If there is audio missing from at least one, this utility
will proceed to make a video file, but without an audio track.

If you want audio, you can add an audio track to the movie files that
are missing an audio track. Then use this utility specifying 'audio-in-all'." \
   --column "" --column "Type" \
   TRUE audio-in-all FALSE audio-missing-from-some)

if test "$AUDIOTYPE" = ""
then
   exit
fi

###################################################
## START a LOOP on the selected filenames, to
## put the names in a variable, INPUTFILES.
##     (Quote the filenames, in case they
##      contain embedded spaces.)
## We also check that the files have the same
## suffix, i.e. are (probably) the same movie type.
##################################################

INPUTFILES=""
COPYPARMS=""
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
   ##
   ## Also build the vcodec and acodec copy parms,
   ## one pair for each input file.
   ##################################################

   INPUTFILES="$INPUTFILES -i \"$FILENAME\""
   if test "$AUDIOTYPE" = "audio-in-all"
   then
      COPYPARMS="$COPYPARMS -acodec copy -vcodec copy"
   else
      COPYPARMS="$COPYPARMS -an -vcodec copy"
   fi
   CNT=`expr $CNT + 1`

done
## END OF 'for FILENAME' loop.


############################################################
## Prepare the output movie filename.
## Use $FILEEXT1 as the extension for the output movie file,
## but override it in certain cases.
###########################################################

FILETYPOUT="avi"

if test "$FILEEXT1" = "avi"
then
   FILETYPOUT="avi"
fi

if test "$FILEEXT1" = "mpg"
then
   FILETYPOUT="mpeg"
fi

if test "$FILEEXT1" = "flv"
then
   FILETYPOUT="flv"
fi

if test "$FILEEXT1" = "wmv"
then
   FILETYPOUT="asf"
fi

## More exceptions are probably coming.

OUTFILE="/tmp/${USER}_ffmpeg-MERGED_${FILEEXT1}_files.$FILEEXT1"

if test -f "$OUTFILE"
then
   rm -f "$OUTFILE"
fi


############################################################
## Prepare the output ffmpeg err-messages filename.
############################################################

OUTLIST="/tmp/${USER}_ffmpeg-MERGED_${FILEEXT1}_files_ffmpeg-err-msgs.lis"

if test -f "$OUTLIST"
then
   rm -f "$OUTLIST"
fi


################################################################
## MERGE the files with 'ffmpeg'.
## (We may need to assure that the same audio and video bitrates
##  are used for each of the movie files.)
################################################################

if  test "$AUDIOTYPE" = "audio-in-all"
then
   NEWPARMS=" -newvideo -newaudio"
else
   NEWPARMS=" -newvideo"
fi

## FOR TESTING:
# set -x

## Note: The '-ab' and '-vb' parm pairs are for testing
##       with TWO input files.

# eval ffmpeg $INPUTFILES $COPYPARMS -ab 192k -ab 192k \
#       -vb 1028k -vb 1028k "$OUTFILE" $NEWPARMS \
#      2> "$OUTLIST"


eval ffmpeg $INPUTFILES $COPYPARMS \
     -f $FILETYPOUT "$OUTFILE" $NEWPARMS \
     2> "$OUTLIST"

## FOR TESTING:
# set -


####################################################
## Show the ffmpeg err-messages file, if non-empty.
####################################################

. $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
. $DIR_NautilusScripts/.set_VIEWERvars.shi

if test -s "$OUTLIST"
then
   $TXTVIEWER "$OUTLIST" &
fi


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
