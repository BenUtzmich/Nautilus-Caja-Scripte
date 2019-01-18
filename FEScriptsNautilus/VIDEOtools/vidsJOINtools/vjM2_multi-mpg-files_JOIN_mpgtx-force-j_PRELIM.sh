#!/bin/sh
##
## Nautilus
## SCRIPT: vjM2_multi-mpg-files_JOIN_mpgtx-force-j_PRELIM.sh
##
## PURPOSE: Uses 'mpgtx' to merge multiple '.mpg' movie files.
##
## METHOD:  In a 'for' loop, puts the selected movie filenames in a string
##          --- space-separated and each filename in double-quotes.
##
##          Passes the string of movie filenames to the command
##          'eval mpgtx --force -j'.
##
##          Puts the messages from 'mpgtx' into a text file and shows
##          the text file with a text-file viewer of the user's choice.
##
##          Shows the merged file in a movie player.
##
## REFERENCEs:
##         http://ubuntuforums.org/archive/index.php/t-85718.html
##         shows an example using 'mpgtx':
##
##         mpgtx -j file01.mpg file02.mpg -o output_name.mpg
##
## Alternatively,
##        do a web search on keywords such as
##              'mpgtx mpg multiple files (join|merge)'
##
##
## HOW TO USE: In Nautilus, select one or more '.mpg' movie files (of the same
##             video-audio encoding. (Can use the Ctl or Shift
##             keys to select multiple files.)
##             Then right-click and choose this VIDEOtools script to run
##             (name above).
##
###########################################################################
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
## END OF 'for FILENAME' loop.


###############################################################
## Prepare the output movie filename --- in the /tmp directory.
## Use $FILEEXT1 as the extension for the output movie file.
##############################################################

OUTFILE="/tmp/${USER}_mpgtx-MERGED_${FILEEXT1}_files.$FILEEXT1"

if test -f "$OUTFILE"
then
   rm -f "$OUTFILE"
fi


############################################################
## Prepare the 'mpgtx' err-messages filename.
############################################################

OUTLIST="/tmp/${USER}_mpgtx-MERGED_${FILEEXT1}_files_err-msgs.lis"

if test -f "$OUTLIST"
then
   rm -f "$OUTLIST"
fi


###########################################
## MERGE the files with 'mpgtx'.
###########################################

## FOR TESTING:
# set -x

eval mpgtx --force -j $INPUTFILES -o "$OUTFILE" 2> "$OUTLIST"

## FOR TESTING:
# set -


####################################################
## Show the 'mpgtx' err-messages file, if non-empty.
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
