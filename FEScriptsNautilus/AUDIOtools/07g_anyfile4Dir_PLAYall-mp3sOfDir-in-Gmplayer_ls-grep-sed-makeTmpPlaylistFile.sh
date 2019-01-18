#!/bin/sh
##
## Nautilus
## SCRIPT: 07g_anyfile4Dir_PLAYall_mp3sOfDir-in-Gmplayer_ls-grep-sed-makeTmpPlaylistFile.sh
##
## PURPOSE: Plays the mp3 files in the current directory,
##          sequentially using 'gmplayer'.
##
## METHOD:  Uses the  'ls' and 'grep' commands to make a '.pls'
##          playlist file (in /tmp).
##
##          Plays the files by passing the playlist file to 'gmplayer'.
##
##          The mp3's are played sequentially, from 'first' to 'last',
##          according to the 'ls' sorting algorithm.
##
## HOW TO USE: In Nautilus, navigate to a directory of mp3 files,
##             right-click on any file in the directory, then
##             choose this Nautilus script to run.
##
#########################################################################
## Created: 2010mar11
## Changed: 2010apr11 Touched up the comment statements.
## Changed: 2011may02 Added $USER to a temp filename.
## Changed: 2012feb29 Changed the scriptname, in the comment above.
##                    Reorged the 'METHOD' comment section above.
## Changed: 2012oct01 Changed script name from '_Gmplayer' to
##                    '-in-Gmplayer' --- and added
##                    '_ls-grep-sed-makeTmpPlaylistFile'.
## Changed: 2013apr10 Added check for the player executable.
########################################################################

## FOR TESTING: (show statments as they execute)
# set -x

#########################################################
## Check if the player executable exists.
#########################################################

EXE_FULLNAME="/usr/bin/gmplayer"

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

TEMPFILE="/tmp/${USER}_Gmplayer.pls"
rm -f $TEMPFILE

###############################################################
## Generate the 'play list' file.
##
## We use 'ls' with 'grep', but we could use a loop on
## filenames to have more control on the file filtering process.
##
## NOTE: mplayer seems to need the string 'file://'
##       prefixed on (fully-qualified) filenames.
##############################################################

CURDIR="`pwd`"

ls  | grep '\.mp3$' | eval "sed 's|^|file://${CURDIR}/|' > $TEMPFILE"

# /usr/bin/gmplayer -loop 0 -playlist "$TEMPFILE" 
## '-loop' does not seem to work with playlist.
## Only works on movies? or with 'mplayer'?

# /usr/bin/gmplayer -playlist "$TEMPFILE"

$EXE_FULLNAME -playlist "$TEMPFILE"

## We could add a zenity prompt to 'shuffle' the files,
## if the '-shuffle' mplayer parm works with gmplayer.
# /usr/bin/gmplayer -loop 0 -shuffle -playlist "$TEMPFILE"

exit
###################################
## This exit is to avoid executing
## the following, alternative code.
###################################


#############################################
## BELOW IS AN ALTERNATE VERSION :
##   gmplayer invoked once for each music file.
##
## But it is difficult to break in and cancel
## the loop. Could use a 'kill' command on this
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

  # /usr/bin/gmplayer "$FILENAME"

  $EXE_FULLNAME "$FILENAME"

done
