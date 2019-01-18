#!/bin/sh
##
## Nautilus
## SCRIPT: 07s_anyfile4Dir_PLAYall-mp3sOfDir-in-Smplayer_ls-grep-sed-makeTmpPlaylistFile.sh
##
## PURPOSE: Plays the mp3 files in the current directory,
##          sequentially using 'smplayer'.
##
## METHOD:  Uses the  'ls' and 'grep' commands to make a '.pls'
##          playlist file (in /tmp).
##
##          Plays the files by passing the playlist file to 'smplayer'.
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
## Changed: 2011may02 Add $USER to a temp filename.
## Changed: 2012feb29 Changed the scriptname, in the comment above.
##                    Reorged the 'METHOD' comment section above. 
## Changed: 2012oct01 Changed script name from '_Smplayer' to
##                    '-in-Smplayer' --- and added
##                    '_ls-grep-sed-makeTmpPlaylistFile'.
## Changed: 2013apr10 Added check for the player executable. 
###########################################################################

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


#########################################################
## Prepare a 'play list' file to hold the audio filenames.
#########################################################

TEMPFILE="/tmp/${USER}_Smplayer.pls"
rm -f $TEMPFILE

######################################################################
## Generate the 'play list' file.
##
## We use 'ls' with 'grep' to generate the list.
##
## We could use a 'for' loop to have more complex control over
## the file filtering process.
##
## NOTE1: Smplayer seems to need the string 'file://'
##        prefixed on fully-qualified filenames.
##
#####################################################################

CURDIR="`pwd`"

eval "ls  | grep '\.mp3$' | sed 's|^|file://$CURDIR/|' > $TEMPFILE"


#########################################################
## Play the audio files with smplayer.
#########################################################

## FOR TESTING:
# xterm -fg white -bg black -hold -e \

# /usr/bin/smplayer -playlist "$TEMPFILE"

$EXE_FULLNAME -playlist "$TEMPFILE"

#########################################################
## We could add a zenity prompt to 'shuffle' the files.
## But smplayer does not accept a command parm like
## '-shuffle' or '-random'. Might have to use a different
## method. Doesn't seem to accept a '-loop' parm either.
## Would be nice to simply be able to do:
##   /usr/bin/smplayer -loop 0 -shuffle $MP3NAMES
## like with mplayer.
#########################################################

exit
###################################
## This exit is to avoid executing
## the following, alternative code.
###################################


#############################################
## BELOW IS AN ALTERNATE VERSION :
##   smplayer invoked once for each music file.
##
## But it is difficult to break in and cancel
## the loop. Could use a 'kill' command for this
## script or use Gnome System Monitor.
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

   /usr/bin/smplayer "$FILENAME"

   $EXE_FULLNAME "$FILENAME"
done
