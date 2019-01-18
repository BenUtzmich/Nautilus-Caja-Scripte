#!/bin/sh
##
## Nautilus
## SCRIPT: 08t_multi-mp3-files_PLAY-in-Totem-ShuffleOpt_make-filenames-string.sh
##
## PURPOSE: Plays user-selected mp3 files in the current directory
##          using 'totem'.
##
## METHOD:  'totem' does not seem to take a playlist file
##          (according to 'man totem'), so we build a string of
##          filenames (quoted to handle filenames with spaces),
##          by using a for-loop with 'grep'.
##
##          Uses a 'zenity --info' window to show info on how to
##          'shuffle' the files.
##
##          Plays the files by passing the string of filenames
##          to the 'totem' command.
##
## HOW TO USE: In Nautilus, navigate to a directory of mp3 files,
##             select the files to play (can use the Ctl key or
##             the Shift key),
##             right-click on the selected files in the directory,
##             then choose this Nautilus script to run.
##
#######################################################################
## Created: 2010dec05
## Changed: 2011may02 Added $USER to a temp filename.
## Changed: 2011jul08 To handle filenames with spaces in the names.
## Changed: 2012feb29 Changed the scriptname, in the comment above.
##                    Reorged the 'METHOD' comment section above.
## Changed: 2012oct01 Changed script name from '_Totem' to
##                    '-in-Totem' --- and added '_make-filenames-string'.
## Changed: 2013apr10 Added check for the player executable.
###########################################################################

## FOR TESTING: (show statements as they execute)
# set -x

#########################################################
## Check if the player executable exists.
#########################################################

EXE_FULLNAME="/usr/bin/totem"

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


##############################################################
## Prepare a playlist filename for Totem.
##   NOTE: 'totem' does not seem to accept a playlist file,
##   although you can '--enqueue' filenames into its playlist.
##   Ref: man totem
## COMMENTED, until we find if Totem does accept a playlist.
##############################################################

#  TEMPFILE="/tmp/${USER}_totem.pls"
#  rm -f "$TEMPFILE"

#########################################
## Generate a string of '.mp3' filenames
## from the selected filenames.
##
## We use 'echo' and 'grep' to filter out
## the non-mp3 files selected and put the
## filtered names into the string.
##
## NOTE: These filenames may be fully
## qualified with 'file://' prefixed
## to each full filename.
#########################################

# MP3NAMES=`echo "$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS" | grep '\.mp3$'`

for FILENAME
do
   FILECHK=`echo "$FILENAME" | grep '\.mp3$'`
   if test ! "$FILECHK" = ""
   then
      MP3NAMES="$MP3NAMES \"$FILENAME\""
   fi
done


#############################################################
## A zenity info display on how to shuffle the files in Totem
## --- and how to see the 'Playlist'.
#############################################################

zenity --info --title "How to Shuffle Files, etc." \
   --text  "\
In 'Totem', use 'Edit > Shuffle Mode' to randomize
the playing of the selected mp3 files.

Use 'Edit > Repeat Mode' to turn on/off the repeated
playing of the selected mp3 files.

Also, instead of 'Properties', you can see the
list of selected files by clicking on 'Playlist'
at the top of the selector in the right sidebar
--- or instead of 'Playlist', click 'Properties'.

Close this window to startup 'Totem'."


#############################################
## Play the files, with 'totem'.
##################################################################
## 'totem' does not have command line options like '-shuffle'
## or '-random' to randomize the playing of the files.
##
## totem does not have a command line option like '-loop'
## to call for repeating the playing N times or indefinitely.
##
## But if such techniques are available, by some other means,
## we could use zenity to prompt for those actions to be triggered.
##################################################################

## FOR TESTING:
#  set -x

# eval /usr/bin/totem "$MP3NAMES"

eval $EXE_FULLNAME  "$MP3NAMES"

exit 
###################################
## This exit is to avoid executing
## the following, alternative code.
###################################


#################################################
## BELOW IS AN ALTERNATE VERSION :
##     totem invoked once for each music file.
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

   #####################################################
   ## Get and check that file extension is 'mp3'. 
   ##    Assumes one '.' in filename, at the extension.
   #####################################################

   FILEEXT=`echo "$FILENAME" | cut -d\. -f2`

   if test "$FILEEXT" != "mp3" 
   then
      continue
      # exit
   fi

   #######################################
   ## Play the file with Totem.
   #######################################

   # /usr/bin/totem "$FILENAME"

   $EXE_FULLNAME  "$FILENAME"
done
