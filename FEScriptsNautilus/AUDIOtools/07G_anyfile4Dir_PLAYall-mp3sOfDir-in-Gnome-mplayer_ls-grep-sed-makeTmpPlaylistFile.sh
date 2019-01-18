#!/bin/sh
##
## Nautilus
## SCRIPT: 07G_anyfile4Dir_PLAYall-mp3sOfDir-in-Gnome-mplayer_ls-grep-sed-makeTmpPlaylistFile.sh
##
## PURPOSE: Plays all the mp3 files in the current directory,
##          sequentially using 'gnome-mplayer'.
##
## METHOD:  Uses the  'ls' and 'grep' commands to make a '.pls'
##          playlist file (in /tmp).
##
##          Plays the files by passing the playlist file to 'gnome-mplayer'.
##
##          The mp3's are played sequentially, from 'first' to 'last',
##          according to the 'ls' sorting algorithm.
##
## HOW TO USE: In Nautilus, navigate to a directory of mp3 files,
##             right-click on any file in the directory, then
##             choose this Nautilus script to run.
##
###########################################################################
## Created: 2011jun13
## Changed: 2011jul07 Changed '-playlist' to '--playlist'.
## Changed: 2012feb28 Changed the scriptname, in the comment above.
##                    Added a comment on the sort/play order.
## Changed: 2012feb29 Reorged the 'METHOD' comment section above. 
## Changed: 2012oct01 Changed script name from '_Gnome-mplayer' to
##                    '-in-Gnome-mplayer' --- and added
##                    '_ls-grep-sed-makeTmpPlaylistFile'.
## Changed: 2013apr10 Added check for the player executable. 
###########################################################################

## FOR TESTING: (show statments as they execute)
#  set -x

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


#########################################################
## Prepare a 'play list' file to hold the audio filenames.
#########################################################

TEMPFILE="/tmp/${USER}_gnome-mplayer.pls"
rm -f $TEMPFILE

#########################################################
## Generate the 'play list' file.
##
## We use 'ls' with 'grep', but we could use a file loop
## to have greater control on filtering the files.
##
## NOTE: mplayer seems to need the string 'file://'
##       prefixed on (fully-qualified) filenames.
#########################################################

# CURDIR="`pwd`"

ls  | grep '\.mp3$' | eval "sed 's|^|file://$CURDIR|' > $TEMPFILE"

# /usr/bin/gnome-mplayer --loop 0 --playlist $TEMPFILE

# /usr/bin/gnome-mplayer --showplaylist --playlist $TEMPFILE

$EXE_FULLNAME --showplaylist --playlist $TEMPFILE

## We could add a zenity prompt to 'shuffle' the files.
# /usr/bin/gnome-mplayer -loop 0 --random -playlist $TEMPFILE

exit
###################################
## This exit is to avoid executing
## the following, alternative code.
###################################


#####################################################
## BELOW IS AN ALTERNATE VERSION :
##   gnome-mplayer invoked once for each music file.
##
## But it is difficult to break in and cancel
## the loop. Could use a 'kill' command on this
## script or Gnome System Monitor.
#####################################################

FILENAMES=`ls`

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

  # /usr/bin/gnome-mplayer "$FILENAME"

  $EXE_FULLNAME "$FILENAME"

done
