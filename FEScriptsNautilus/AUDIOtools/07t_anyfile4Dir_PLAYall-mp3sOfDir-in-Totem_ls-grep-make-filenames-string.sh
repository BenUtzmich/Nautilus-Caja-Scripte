#!/bin/sh
##
## Nautilus
## SCRIPT: 07t_anyfile4Dir_PLAYall-mp3sOfDir-in-Totem_ls-grep-make-filenames-string.sh
##
## PURPOSE: Plays the mp3 files in the current directory,
##          sequentially using 'totem'.
##
## METHOD: 'totem' does not seem to take a playlist file
##          (according to 'man totem'), so we build a string of
##          filenames (quoted to handle filenames with spaces),
##          by using 'ls' and a for-loop with 'grep'.
##
##          Plays the files by passing the string of filenames
##          to the 'totem' command.
##
##          The mp3's are played sequentially, from 'first' to 'last',
##          according to the 'ls' sorting algorithm.
##
## HOW TO USE: In Nautilus, navigate to a directory of mp3 files,
##             right-click on any file in the directory, then
##             choose this Nautilus script to run.
##
#######################################################################
## Created: 2010dec05
## Changed: 2011may02 Added $USER to a temp filename.
## Changed: 2011jul08 To handle filenames with spaces in the names.
## Changed: 2012feb29 Changed the scriptname, in the comment above.
##                    Reorged the 'METHOD' comment section above.
## Changed: 2012oct01 Changed script name from '_Totem' to
##                    '-in-Totem' --- and added
##                    '_ls-grep-make-filenames-string'.
## Changed: 2013apr10 Added check for the player executable.
###########################################################################

## FOR TESTING: (show statements as they execute)
#  set -x

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


#########################################################
## Prepare a 'play list' file to hold the audio filenames.
## NOTE: 'totem' does not seem to accept a playlist file,
## although you can '--enqueue' filenames into its playlist.
## Ref: man totem
#########################################################

#  TEMPFILE="/tmp/${USER}_totem.pls"
#  rm -f $TEMPFILE

#############################################################
## Generate a string of '.mp3' filenames.
#############################################################

## This does not work for filenames with embedded spaces.
#  MP3NAMES=`ls  | grep '\.mp3$' | sed 's|$| |'`

FILENAMES=`ls`
 
HOLD_IFS="$IFS"
## We put a single line-feed in IFS.
IFS='
'

## It would be nice to avoid changing IFS, but I have not
## found a way, yet, to make the 'in' reader
## of the 'for' loop recognize the separate filenames
## when filenames contain spaces.
##   (Perhaps we could use 'sed' to put a quote at the
##    beginning and end of each line in $FILENAMES.)

MP3NAMES=""

for FILENAME in $FILENAMES
do
   FILECHK=`echo "$FILENAME" | grep '\.mp3$'`
   if test ! "$FILECHK" = ""
   then
      MP3NAMES="$MP3NAMES \"$FILENAME\""
   fi
done

IFS="$HOLD_IFS"


###########################################################
## A zenity 'info' window to show Totem keyboard controls.
###########################################################

zenity --info --title "Totem Keyboard Controls" \
   --no-wrap \
   --text  "\
Totem keyboard controls:
       i	    toggle interlacing on and off
       a	    cycle between aspect ratios
       p	    toggle between play and pause
       Esc	    exit full screen mode
       f	    toggle full screen
       h	    toggle display of on-screen controls
       0	    resize window to 50% original size
       1	    resize window to 100% original size
       2	    resize window to 200% original size
       r	    zoom in the video
       t	    zoom out the video
       d	    start and stop the telestrator (drawing) mode
       e	    erase the drawing
       Left-arrow	 skip back 15 seconds
       Right-arrow	 skip forward 60 seconds
       Shift+Left-arrow  skip back 5 seconds
       Shift+Right-arrow skip forward 15 seconds
       Ctrl+Left-arrow	 skip back 3 minutes
       Ctrl+Right arrow  skip forward 10 minutes
       Up-arrow     increase volume by 8%
       Down-arrow   decrease volume by 8%
       b	    jump back to previous chapter/movie in playlist
       n	    jump to next chapter/movie in playlist
       q	    quit
       Ctrl+E	       eject the playing optical media
       Ctrl+O	    open a new file
       Ctrl+L	    open a new URI
       F9	    toggle display of the playlist
       m	    show the DVD menu
       c	    show the DVD chapter menu
" &

## Give the user a second or two to see the help window.
sleep 2

###########################################################
## Play the audio files with 'totem'.
###########################################################
## totem does not have command line options like '-shuffle'
## or '-random' to randomize the playing of the files.
##
## totem does not have a command line option like '-loop'
## to call for repeating the playing N times or indefinitely.
##
## But if such techniques are available, by some other means,
## we could use zenity to prompt for those actions to be triggered.
###########################################################

## FOR TESTING:
#  set -x

# eval /usr/bin/totem "$MP3NAMES"

eval $EXE_FULLNAME "$MP3NAMES"

exit
###################################
## This exit is to avoid executing
## the following, alternative code.
###################################


#############################################
## BELOW IS AN ALTERNATE VERSION :
##   totem invoked once for each music file.
##
## But it is difficult to break in and cancel
## the loop. Would have to use a 'kill' command or
## Gnome System Monitor.
#############################################

   FILENAMES=`ls`
#  FILENAMES="$@"
#  FILENAMES="$NAUTILUS_SCRIPT_SELECTED_URIS"
#  FILENAMES="$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS"

###################################
## START THE LOOP on the filenames.
###################################

for FILENAME in $FILENAMES
do

  #################################################
  ## Get and check that file extension is 'mp3'. 
  ## THIS ASSUMES one '.' in filename, at the extension.
  #################################################

  FILEEXT=`echo "$FILENAME" | cut -d\. -f2`

  if test "$FILEEXT" != "mp3" 
  then
     continue
     # exit
  fi

  #############################
  ## Play the file.
  #############################

  # /usr/bin/totem "$FILENAME"

  $EXE_FULLNAME "$FILENAME"
done
