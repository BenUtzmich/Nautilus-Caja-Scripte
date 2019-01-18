#!/bin/sh
##
## Nautilus
## SCRIPT: 08v_multi-mp3-files_PLAY-in-VLC-ShuffleOpt_make-filenames-string.sh
##
## PURPOSE: Plays user-selected mp3 files in the current directory
##          using 'vlc'.
##
## METHOD:  It would be nice to use a 'playlist' file
##          to feed the filenames to ONE call of 'vlc',
##          but after much web searching, I have not
##          found an example of doing that.
##
##          Furthermore,
##          'vlc' does not seem to take a playlist file
##          (according to 'man vlc'), so we build a string of
##          filenames (quoted to handle filenames with spaces),
##          and feed that string to the 'totem' command.
##
##          Uses a zenity prompt to determine whether to 'shuffle' the files.
##
##          Plays the files by passing the string of filenames to 'vlc'.
##
##         NOTE:
##         I am concerned about passing all the filenames
##         on the VLC command line. There is a limit of around 2KB
##         (maybe much more nowadays) on the length of a command line.
##         An alternate implementation could call 'vlc' once for
##         each file --- or use 'xargs'.
##
## HOW TO USE: In Nautilus, navigate to a directory of mp3 files,
##             select the files to play (can use Ctl key or
##             the Shift key),
##             right-click on the selected files in the directory,
##             then choose this Nautilus script to run.
##
######################################################################
## Started: 2010mar11
## Changed: 2010apr11 Touched up the comment statements.
## Changed: 2011may02 Added $USER to a temp filename.
## Changed: 2011jul08 To handle filenames with spaces in the names.
## Changed: 2012feb29 Changed the scriptname, in the comment above.
##                    Reorged the 'METHOD' comment section above.
## Changed: 2012oct01 Changed script name from '_VLC' to
##                    '-in-VLC' --- and added '_make-filenames-string'.
## Changed: 2013apr10 Added check for the player executable.
###########################################################################

## FOR TESTING: (show statements as they execute)
# set -x

#########################################################
## Check if the player executable exists.
#########################################################

EXE_FULLNAME="/usr/bin/vlc"

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
##
## NOTE: 'vlc' does not seem to accept a playlist file,
## although you can '--playlist-enqueue' filenames into
## its playlist when in '--one-instance' mode.
## Ref: vlc -H
##
## So the following playlist-file creation is commented.
## It may be activated if it ever becomes known that
## VLC supports input via a playlist file.
#############################################################

#  TEMPFILE="/tmp/${USER}_vlc.pls"
#  rm -f $TEMPFILE


#############################################################
## Generate a string of '.mp3' filenames from the
## selected filenames.
#############################################################

MP3NAMES=""

for FILENAME
do
   FILECHK=`echo "$FILENAME" | grep '\.mp3$'`
   if test ! "$FILECHK" = ""
   then
      MP3NAMES="$MP3NAMES \"$FILENAME\""
   fi
done


############################################
## A zenity OK/Cancel prompt for 'Shuffle?'.
##
## vlc has command line option '--random' to
## randomize the playing of the files.
############################################

zenity --question --title "Shuffle?" \
   --text "\
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


#######################################
## Play the selected files, with vlc --
## with shuffle or without.
###############################################################
## We could use '--loop' to repeat-play the files, indefinitely.
## But if there is a problem, VLC tends to get in a loop and
## it is a bit of a pain to kill VLC (especially for a newbie).
## We could add a zenity prompt whether to loop.
###############################################################
## A possible alternative is to quit after one play-through,
## instead of looping indefinitely:
## Use '--play-and-exit' instead of '--loop'.
############################################################
## Another option:  '--qt-start-minimized'
############################################################

if test "$ANS" = "Yes"
then
   # eval /usr/bin/vlc --random --no-http-album-art --album-art 0 \

   eval $EXE_FULLNAME --random --no-http-album-art --album-art 0 \
                  --no-http-forward-cookies --playlist-tree \
                  --one-instance --playlist-enqueue \
                  "$MP3NAMES"
else
   # eval /usr/bin/vlc --no-http-album-art --album-art 0 \

   eval $EXE_FULLNAME  --no-http-album-art --album-art 0 \
                  --no-http-forward-cookies --playlist-tree \
                  --one-instance --playlist-enqueue \
                  "$MP3NAMES"
 
fi

exit
###################################
## This exit is to avoid executing
## the following, alternative code.
###################################

############################################################
## ORIGINAL VERSION --- using a loop through the filenames.
## Initiates VLC over and over, instead of calling VLC once.
##
## NOTE: It is difficult to break in and cancel
## the loop. Was using a 'kill' command or
## Gnome System Monitor.
############################################################

##############################################
## Get the selected filenames.
##
## NOTE: If there is a problem with blanks in
## filenames, we may have to get the filenames
## with a NAUTILUS_SCRIPT var.
##############################################

   FILENAMES_GET="$@"
#  FILENAMES_GET="$NAUTILUS_SCRIPT_SELECTED_URIS"
#  FILENAMES_GET="$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS"

############################################################
## Code to shuffle the filenames, when using $@
## to get the selected filenames.
##
## NOTE:
## 'sed' is used to change a 'space' separator between
## the filenames into line-feeds --- because 'shuf' wants
## separate lines to shuffle, not words in a string.
##     This assumes no embedded blanks in the filenames.
##
## NOTE: Could try the '--random' option of vlc, below ---
##       if we find out how to submit an arbitrarily long
##       playlist --- say, in a playlist file.
############################################################

#   FILENAMES=`echo "$FILENAMES_GET" | sed 's| |\n|g' | shuf`
## No file shuffling, for now.
## Could add a zenity prompt, above -- for Yes or No.

######################################
## START THE LOOP on the filenames.
######################################

for FILENAME in "$FILENAMES"
do

   ##################################################
   ## Get and check that file extension is 'mp3'. 
   ##   Assumes one '.' in filename, at the extension.
   ##################################################

   FILEEXT=`echo "$FILENAME" | cut -d\. -f2`

   if test "$FILEEXT" != "mp3" 
   then
      continue
      # exit
   fi

   #########################
   ## Play the file with vlc.
   #########################

   # /usr/bin/vlc --no-http-album-art --album-art 0 --play-and-exit \

   $EXE_FULLNAME --no-http-album-art --album-art 0 --play-and-exit \
               --qt-start-minimized "$FILENAME"

done
