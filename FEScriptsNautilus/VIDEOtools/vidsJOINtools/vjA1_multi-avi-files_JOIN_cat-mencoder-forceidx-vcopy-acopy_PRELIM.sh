#!/bin/sh
##
## Nautilus
## SCRIPT: vjA1_multi-avi-files_JOIN_cat-mencoder-forceidx-vcopy-acopy_PRELIM.sh
##
## PURPOSE: Uses 'cat' and 'mencoder' to merge multiple '.avi' movie files.
##
## METHOD:  In a 'for' loop, puts the selected movie filenames in a string
##          --- space-separated and each filename in double-quotes.
##
##          Uses 'eval cat' to concatenate the selected '.avi' files into
##          one temporary '.avi' file.
##
##          Applies 'mencoder' to the concatenated '.avi' file, using
##          the parms '-forceidx -ovc copy -oac copy' to create the
##          'final' '.avi' file.
##
##          Puts the messages from 'mencoder' into a text file and shows
##          the text file with a text-file viewer of the user's choice.
##
##          Shows the final '.avi' file in a movie player.
##
## REFERENCES: 
##     http://dtbaker.com.au/random-bits/join-multiple-avi-files.html
##     shows an example using 'cat' and 'mencoder':
##
##     cat file1.avi file2.avi file3.avi > video_draft.avi
##
##     After appending the data together using cat above,
##     you need to re-index the draft movie like this:
##
##     mencoder video_draft.avi -o video_final.avi -forceidx -ovc copy -oac copy
##
## Alternatively,
##     do a web search on keywords such as
##              'mencoder cat avi ovc oac copy forceidx'
##
##
## HOW TO USE: In Nautilus, select one or more '.avi' movie files (of the same
##             video-audio encoding. (Can use the Ctl or Shift
##             keys to select multiple files.)
##             Then right-click and choose this VIDEOtools script to run
##             (name above).
##
############################################################################
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
## We also check that the files have the same suffix
## (.avi), i.e. are (probably) the same movie type
## and are probably an AVI type which can be joined
## with 'cat'.
##################################################

INPUTFILES=""
CNT=1
FILEEXT1="avi"

for FILENAME
do

   ######################################################
   ## Get the extension of each selected movie file.
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

OUTFILE="/tmp/${USER}_cat-mencoder-MERGED_${FILEEXT1}_files.$FILEEXT1"

if test -f "$OUTFILE"
then
   rm -f "$OUTFILE"
fi

OUTFILETEMP="/tmp/${USER}_cat-mencoder-MERGED_${FILEEXT1}_files_TEMP.$FILEEXT1"

if test -f "$OUTFILETEMP"
then
   rm -f "$OUTFILETEMP"
fi


############################################################
## Prepare the err-messages filename.
############################################################

OUTLIST="/tmp/${USER}_cat-mencoder-MERGED_${FILEEXT1}_files_err-msgs.lis"

if test -f "$OUTLIST"
then
   rm -f "$OUTLIST"
fi


##############################################
## MERGE the files with 'cat' and 'mencoder'.
##############################################

## FOR TESTING:
# set -x

eval cat $INPUTFILES > "$OUTFILETEMP"

mencoder "$OUTFILETEMP" -o "$OUTFILE" -forceidx -ovc copy -oac copy \
         2> "$OUTLIST"

## FOR TESTING:
# set -


#############################################
## Show the  err-messages file, if non-empty.
#############################################

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
