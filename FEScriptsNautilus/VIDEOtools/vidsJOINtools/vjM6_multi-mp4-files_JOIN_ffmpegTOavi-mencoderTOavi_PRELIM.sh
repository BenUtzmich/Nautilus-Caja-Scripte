#!/bin/sh
##
## Nautilus
## SCRIPT: vjM6_multi-mp4-files_JOIN_ffmpegTOavi-mencoderTOavi_PRELIM.sh
##
## PURPOSE: Uses 'ffmpeg' to convert the user-selected '.mp4' files to
##          '.avi' files. Then uses 'mencoder' to merge multiple '.avi'
##          movie files.
##
##          NOTE: You end up with an AVI file, NOT an MP4 file.
##
## METHOD: In a 'for' loop, puts the selected movie filenames in a string
##          --- with nothing in front of the first name and '-cat'
##          in front of the other filenames --- and '-out' in front
##          of the output filename.
##
##          Passes the filenames string to 'mencoder' to create the
##          'final' '.mp4' file.
##
##          Shows the merged file in a movie player.
##
## REFERENCES: http://superuser.com/questions/173300/how-can-i-merge-or-concatenate-two-or-more-mp4-files-creating-another-mp4-file?lq=1
##
##             That page claims that the following works (for 15 files):
## -------------------------------
##    #!/bin/bash
##
##   for i in `seq 1 15`;
##   do
##      if [ $i -lt 10 ]; then
##          j="0$i"
##      else
##          j="$i"
##      fi
##   
##      ffmpeg -i $j.mp4 $j.avi
##   
##      z="$z $j.avi"
##   done 
##   
##   mencoder -oac copy -ovc copy $z -o all.avi
## ----------------------------------------------
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

FILEOUT="/tmp/${USER}_merged_MP4files.avi"

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

   ####################################################
   ## Convert the MP4 file to an AVI file, with 'ffmpeg'.
   ####################################################

   FILEPREF=`echo "$FILENAME" | cut -d\. -f1`

   ffmpeg -i "$FILENAME" "$FILEPREF.avi"


   ################################################
   ## Build the string of AVI filenames for input
   ## to 'mencoder'.
   ################################################

   if test $CNT = 1
   then
      INPUTFILES="\"$FILEPREF.avi\""
      CNT=`expr $CNT + 1`
   else
      INPUTFILES="$INPUTFILES  \"$FILEPREF.avi\""
   fi

done


########################################
## MERGE the AVI files with 'mencoder'.
## (Need a parameter to specify the audio
##  format to handle all cases??)
########################################

eval mencoder -ovc copy -oac copy "$INPUTFILES" \
              -o "$FILEOUT"


##################################
## Show the merged AVI movie file.
##################################

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
