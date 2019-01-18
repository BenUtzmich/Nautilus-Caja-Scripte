#!/bin/sh
##
## Nautilus
## SCRIPT: vjM5_multi-mp4-files_JOIN_mencoder_PRELIM.sh
##
## PURPOSE: Uses 'mencoder' to merge multiple '.mp4' movie files.
##
## METHOD: In a 'for' loop, puts the selected movie filenames in a string.
##
##          Passes the filenames string to 'mencoder' to create the
##          'final' '.mp4' file.
##
##          Shows the merged file in a movie player.
##
## REFERENCES: http://www.ehow.com/how_7453393_merge-mp4s-linux.html
##             'How to Merge MP$s in Linux'
##             That page claims that the following works:
##
##     mencoder input1.mp4 input2.mp4 -ovc copy -oac copy \
##                                    -of lavf format=mp4 -o output.mp4
##
## Alternatively,
##     do a web search on keywords such as
##              '(concatenate|join|merge) mp4 movie file (linux|ubuntu)'
##
## HOW TO USE: In Nautilus, select one or more '.mp4' movie files (of the same
##             video-audio encoding. (Can use the Ctl or Shift
##             keys to select multiple files.)
##             Then right-click and choose this VIDEOtools script to run
##             (name above).
##
############################################################################
## Started: 2011oct13
## Changed: 2012
############################################################################

## FOR TESTING: (display statements that execute)
# set -x


###############################
## Prepare the output filename.
###############################

FILEOUT="/tmp/${USER}_merged_MP4files.mp4"

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
   ## Check that the extension is '.mp4' ---
   ## at least for the first file.
   ##
   ##  Assumes that there is only one period
   ##  in the filename --- and no embedded blanks.
   ##############################################

   FILEEXT=`echo "$FILENAME" | cut -d\. -f2`

   if test "$FILEEXT" != "mp4"
   then
      zenity --info \
           --title "NOT A '.mp4' FILE.  EXITING ..." \
           --text "\
File $FILENAME
is not a '.mp4' suffix file.

Exiting ..."
      exit
   fi

   ################################################
   ## Build the string of input filenames --- with
   ## a '-cat' in front of each filename except the
   ## first.
   ################################################

   if test $CNT = 1
   then
      INPUTFILES="\"$FILENAME\""
      CNT=`expr $CNT + 1`
   else
      INPUTFILES="$INPUTFILES  \"$FILENAME\""
   fi

done


########################################
## MERGE the files with 'MP4Box'.
########################################

eval mencoder "$INPUTFILES" -ovc copy -oac copy \
                            -of lavf format=mp4 -o "$FILEOUT"


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
