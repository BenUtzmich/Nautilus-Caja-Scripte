#!/bin/sh
##
## Nautilus
## SCRIPT: 08s_multi-mp3-files_PLAY-in-Smplayer-ShuffleOpt_for-loop-makeTmpPlaylistFile.sh
##
## PURPOSE: Plays user-selected mp3 files in the current directory
##          using 'smplayer'.
##
## METHOD:  Uses a for-loop to build a playlist file (in /tmp) from
##          the user-selected filenames.
##
##          Uses a zenity prompt to determine whether to 'shuffle' the files.
##
##          Uses a 'zenity --info' prompt to show some info on smplayer usage
##          --- in particular, how to randomize the playing of the files.
##
##          Plays the files by passing the playlist file to 'smplayer'.
##
## HOW TO USE: In Nautilus, navigate to a directory of mp3 files,
##             select the files to play (can use the Ctl key or
##             the Shift key),
##             right-click on the selected files in the directory,
##             then choose this Nautilus script to run.
##
##########################################################################
## Created: 2010dec05
## Changed: 2012feb29 Changed the scriptname, in the comment above.
##                    Reorged the 'METHOD' comment section above. 
## Changed: 2012oct01 Changed script name from '_Smplayer' to
##                    '-in-Smplayer' --- and added
##                    '_for-loop-makeTmpPlaylistFile'.
## Changed: 2013apr10 Added check for the player executable.
##########################################################################

## FOR TESTING: (show statements as they execute)
# set -x

#########################################################
## Check if the player executable exists.
#########################################################

EXE_FULLNAME="/usr/bin/smplayer"

if test ! -f "$EXE_FULLNAME"
then
   zenity  --info --title "Player NOT FOUND." \
   --no-wrap \
   --text  "\
The player executable
   $EXE_FULLNAME
was not found. Exiting."
   exit
fi


#############################################################
## Prepare a 'play list' filename to hold the audio filenames.
#############################################################

TEMPFILE="/tmp/${USER}_Smplayer.pls"
rm -f $TEMPFILE

######################################################
## Put the selected filenames in the 'play list' file.
##
## We use 'echo' and 'grep' to filter out
## the non-mp3 files selected and put the
## filtered names into the playlist file.
##
## NOTE1: Smplayer seems to need the string 'file://'
##        prefixed on fully-qualified filenames.
##
## We could build the MP3NAMES list of filenames
## with a 'for' loop, like in the script
##   07t_multiplay_mp3s_allOfDir_Totem.sh
######################################################

CURDIR="`pwd`"

for FILENAME
do
   FILECHK=`echo "$FILENAME" | grep '\.mp3$'`
   if test ! "$FILECHK" = ""
   then
      echo "file://${CURDIR}/$FILENAME" >> "$TEMPFILE"
   fi
done

###################################################################
## A zenity info display on how to shuffle the files in 'smplayer'.
###################################################################

zenity --info --title "How to Shuffle Files." \
   --text  "\
In Smplayer, use 'Options > Playlist' show the selected
files in a list window. At the bottom of that list window are
icons for various actions.

Click on the dice icon to randomize the playing of the selected
mp3 files." &


#############################################
## Play the playlist, with 'smplayer'.
#############################################

## FOR TESTING:
# xterm -fg white -bg black -hold -e \

# /usr/bin/smplayer -playlist "$TEMPFILE"

$EXE_FULLNAME -playlist "$TEMPFILE"

exit 
###################################
## This exit is to avoid executing
## the following, alternative code.
###################################


#################################################
## BELOW IS AN ALTERNATE VERSION :
##     smplayer invoked once for each music file.
##
## But it is difficult to break in and cancel
## the loop. Could use a 'kill' command on this
## script or use Gnome System Monitor.
#################################################

   FILENAMES_GET="$@"
#  FILENAMES_GET="$NAUTILUS_SCRIPT_SELECTED_URIS"
#  FILENAMES_GET="$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS"

##########################################################
## Shuffle the filenames.
##
## NOTE:
## 'sed' is used to change a 'space' separator between
## the filenames into line-feeds --- because 'shuf' wants
## separate lines to shuffle, not words in a string.
##     This assumes no embedded blanks in the filenames.
##
## NOTE: Could try the '-shuffle' option of mplayer, below.
##########################################################

FILENAMES=`echo "$FILENAMES_GET" | sed 's| |\n|g' | shuf`

###########################################
## START THE LOOP on the filenames.
###########################################

for FILENAME in "$FILENAMES"
do

  ####################################################
  ## Get and check that file extension is 'mp3'. 
  ##   Assumes one '.' in filename, at the extension.
  ####################################################

  FILEEXT=`echo "$FILENAME" | cut -d\. -f2`

  if test "$FILEEXT" != "mp3" 
  then
     continue
     # exit
  fi

  #######################################
  ## Play the file.
  #######################################

  # usr/bin/smplayer "$FILENAME"

   $EXE_FULLNAME  "$FILENAME"
done
