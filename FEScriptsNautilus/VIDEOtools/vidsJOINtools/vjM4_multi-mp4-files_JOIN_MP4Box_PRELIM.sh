#!/bin/sh
##
## Nautilus
## SCRIPT: vjM4_multi-mp4-files_JOIN_MP4Box_PRELIM.sh
##
## PURPOSE: Uses 'MP4Box' to merge multiple '.mp4' movie files.
##
##          You can install 'MP4Box' with the command:
##              sudo apt-get install gpac
##
## METHOD: In a 'for' loop, puts the selected movie filenames in a string
##          --- with nothing in front of the first name and '-cat'
##          in front of the other filenames.
##
##          Passes the filenames string to 'MP4Box' to create the
##          'final' '.mp4' file.  Uses '-out' in front
##          of the output filename.
##
##          Shows the merged file in a movie player.
##
## REFERENCES: http://ubuntuforums.org/showthread.php?t=2059506&page=2
##             [SOLVED] Merge 2 MP4 files - page 2
##             That page showed that the following worked:
##     MP4Box 001a.mp4 -cat 002a.mp4 -cat 003a.mp4 -out combinedfile.mp4
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
      INPUTFILES="$INPUTFILES -cat \"$FILENAME\""
   fi

done


########################################
## MERGE the files with 'MP4Box'.
########################################

eval MP4Box "$INPUTFILES" -out "$FILEOUT"


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
