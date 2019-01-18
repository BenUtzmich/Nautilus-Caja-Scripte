#!/bin/sh
##
## Nautilus
## SCRIPT: vjK1_multi-mkv-files_JOIN_mkvmerge_PRELIM.sh
##
## PURPOSE: Uses 'mkvmerge' to merge multiple '.mkv' (Matroska container)
##          movie files.
##
## METHOD: In a 'for' loop, puts the selected movie filenames in a string
##          --- space-separated and each filename in double-quotes ---
##          with a plus-sign in front of each filename.
##
##          Passes the filenames string to 'eval mkvmerge' to create the
##          'final' '.mkv' file.
##
##          Shows the merged file in a movie player.
##
## REFERENCES: http://ubuntuforums.org/archive/index.php/t-1392026.html
##             "HOWTO: Proper Screencasting on Linux"
##
## Alternatively,
##     do a web search on keywords such as
##              'mkvmerge mkv (join|merge)'
##
##
## HOW TO USE: In Nautilus, select one or more '.mkv' movie files (of the same
##             video-audio encoding. (Can use the Ctl or Shift
##             keys to select multiple files.)
##             Then right-click and choose this VIDEOtools script to run
##             (name above).
##
############################################################################
## Started: 2011may02
## Changed: 2011jul07 Changed to handle filenames with embedded spaces.
##                    (Removed use of FILENAMES var and we use a 'for' loop
##                     WITHOUT the 'in' phrase.  Ref: man bash )
## Changed: 2012may24 Changed script name in comments above and touched up
##                    the comments. Changed some indenting below.
############################################################################

## FOR TESTING: (display statements that execute)
# set -x


###############################
## Prepare the output filename.
###############################

FILEOUT="/tmp/${USER}_merged_MKVfiles.mkv"

if test -f "$FILEOUT"
then
   rm -f "$FILEOUT"
fi


########################################
## START a LOOP on the filenames, to
## put them in a string and to
## add a plus sign in front of each
## filename, except the first one.
##   (Quote the filenames, in case they
##    contain embedded spaces.)
########################################

INPUTFILES=""
CNT=1

for FILENAME
do

   ##############################################
   ## Check that the extension is '.mkv' ---
   ## at least for the first file.
   ##
   ##  Assumes that there is only one period
   ##  in the filename --- and no embedded blanks.
   ##############################################

   FILEEXT=`echo "$FILENAME" | cut -d\. -f2`

   if test "$FILEEXT" != "mkv"
   then
      zenity --info \
           --title "NOT A '.mkv' FILE.  EXITING ..." \
           --text "\
File $FILENAME
is not a '.mkv' suffix file.

Exiting ..."
      exit
   fi

   ################################################
   ## Build the string of input filenames --- with
   ## a plus sign in front of each filename.
   ################################################

   if test $CNT = 1
   then
      INPUTFILES="$FILENAME"
      CNT=`expr $CNT + 1`
   else
      INPUTFILES="$INPUTFILES +\"$FILENAME\""
   fi

done


########################################
## MERGE the files with 'mkvmerge'.
########################################

eval mkvmerge -o "$FILEOUT" "$INPUTFILES"


##############################
## Show the merged movie file.
##############################

if test ! -f "$FILEOUT"
then
   exit
fi

# MOVIEPLAYER="/usr/bin/vlc"
# MOVIEPLAYER="/usr/bin/gnome-mplayer"
# MOVIEPLAYER="/usr/bin/gmplayer -vo xv"
# MOVIEPLAYER="/usr/bin/totem"

MOVIEPLAYER="/usr/bin/ffplay -stats"

xterm -fg white -bg black -hold -geometry 90x24+100+100 -e \
      $MOVIEPLAYER "$FILEOUT"


#########################################################
## Use a user-specified MOVIEPLAYER.  Someday?
#########################################################

# . $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
# . $DIR_NautilusScripts/.set_VIEWERvars.shi

# $MOVIEPLAYER "$FILEOUT" &
