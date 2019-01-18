#!/bin/sh
##
## Nautilus
## SCRIPT: 08G_multi-mp3-files_PLAY-in-Gnome-mplayer-ShuffleOpt_for-loop-makeTmpPlaylistFile.sh
##
## PURPOSE: Plays user-selected mp3 files in the current directory
##          using 'gnome-mplayer'.
##
## METHOD:  Uses a for-loop to build a playlist file (in /tmp) from
##          the user-selected filenames.
##
##          Uses a zenity prompt to determine whether to 'shuffle' the files.
##
##          Plays the files by passing the playlist file to 'gnome-mplayer'.
##
## HOW TO USE: In Nautilus, navigate to a directory of mp3 files,
##             select the files to play (can use the Ctl key or
##             the Shift key),
##             right-click on the selected files in the directory,
##             then choose this Nautilus script to run.
##
###############################################################################
## Created: 2011jun13
## Changed: 2011jul07 Removed use of a NAUTILUS_SCRIPT var. In its place,
##                    we use a 'for' loop, WITHOUT the 'in' phrase, to handle
##                    filenames with embedded spaces.  Ref: man bash
## Changed: 2012feb29 Changed the scriptname, in the comment above.
##                    Reorged the 'METHOD' comment section above.
## Changed: 2012oct01 Changed script name from '_Gnome-mplayer' to
##                    '-in-Gnome-mplayer' --- and added
##                    '_for-loop-makeTmpPlaylistFile'.
## Changed: 2013apr10 Added check for the player executable. 
###########################################################################

## FOR TESTING: (show statements as they execute)
# set -x

#########################################################
## Check if the player executable exists.
#########################################################

EXE_FULLNAME="/usr/bin/gnome-mplayer"

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


############################################
## Prepare a playlist file for gnome-mplayer.
############################################

TEMPFILE="/tmp/${USER}_Gnome-mplayer.pls"
rm -f "$TEMPFILE"

###########################################
## Put the filenames in the playlist file.
##
## We use 'echo' and 'grep' to filter out
## the non-mp3 files selected and put the
## filtered names into the playlist file.
##
## NOTE: These filenames may be fully
## qualified with 'file://' prefixed
## to each full filename.
#####################################################################
## Rather than using a NAUTILUS_SCRIPT var to make the playlist file,
## we use a 'for FILENAME' loop technique --- so that this script
## may be usable with other file managers.
## So we avoid this:
#   echo "$NAUTILUS_SCRIPT_SELECTED_URIS" | grep '\.mp3$' > "$TEMPFILE"
######################################################################

# CURDIR="`pwd`"

for FILENAME
do
   FILECHK=`echo "$FILENAME" | grep '\.mp3$'`
   if test ! "$FILECHK" = ""
   then
      echo "file://$FILENAME" >>  "$TEMPFILE"
   fi
done


#############################################
## A zenity OK/Cancel prompt for 'Shuffle?'.
#############################################

zenity  --question --title "Shuffle?" \
   --text  "\
Shuffle (randomize) the songs?
         Cancel = No."

if test $? = 0
then
   ANS="Yes"
else
   ANS="No"
fi

## An ALTERNATE zenity prompt (radiolist for Yes/No to 'Shuffle?').
##
#  ANS=$(zenity --list --radiolist \
#               --title "Shuffle?" --text "Shuffle (randomize) the songs?" \
#               --column "Cancel" --column "= Yes" \
#              TRUE Yes FALSE No)
#
#  if test "$ANS" = ""
#  then
#     ANS="Yes"
#  fi


#############################################
## Play the playlist, with 'gnome-mplayer'.
#############################################

if test "$ANS" = "Yes"
then
   # /usr/bin/gnome-mplayer --random --playlist "$TEMPFILE"
   $EXE_FULLNAME --random --playlist "$TEMPFILE"
else
   # /usr/bin/gnome-mplayer --playlist "$TEMPFILE"
   $EXE_FULLNAME --playlist "$TEMPFILE"
fi

exit 
###################################
## This exit is to avoid executing
## the following, alternative code.
###################################


#################################################
## BELOW IS AN ALTERNATE VERSION :
##     gnome-mplayer invoked once for each music file.
##
## But it is difficult to break in and cancel
## the loop. Could use a 'kill' command on this
## script or use Gnome System Monitor.
#################################################

   FILENAMES_GET="$@"
#  FILENAMES_GET="$NAUTILUS_SCRIPT_SELECTED_URIS"
#  FILENAMES_GET="$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS"

###########################################
## Shuffle the filenames.
##
## NOTE:
## 'sed' is used to change a 'space' separator between
## the filenames into line-feeds --- because 'shuf' wants
## separate lines to shuffle, not words in a string.
##     This assumes no embedded blanks in the filenames.
##
## NOTE: Could try the '-shuffle' option of mplayer, below.
#########################################

FILENAMES=`echo "$FILENAMES_GET" | sed 's| |\n|g' | shuf`

###########################################
## START THE LOOP on the filenames.
###########################################

for FILENAME in "$FILENAMES"
do

   #######################################
   ## Get and check that file extension is 'mp3'. 
   ## Assumes one '.' in filename, at the extension.
   #######################################

   FILEEXT=`echo "$FILENAME" | cut -d\. -f2`

   if test "$FILEEXT" != "mp3" 
   then
      continue
      # exit
   fi

   #######################################
   ## Play the file.
   #######################################

   # /usr/bin/gnome-mplayer --random "$FILENAME"

   # /usr/bin/gnome-mplayer "$FILENAME"

   $EXE_FULLNAME  "$FILENAME"
done
