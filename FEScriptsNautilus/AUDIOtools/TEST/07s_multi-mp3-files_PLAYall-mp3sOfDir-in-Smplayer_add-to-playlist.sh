#!/bin/sh
##
## Nautilus
## SCRIPT: 07s_multi-mp3-files_PLAYall_mp3sOfDir_Smplayer-add-to-playlist.sh
##
## PURPOSE: Plays the mp3 files in the current directory, after
##          feeding the filenames to smplayer with the
##          '-add-to-playlist' parm.
##
##          Plays the files with 'smplayer'.
##
##          !!!! DOES NOT WORK as intended, YET.
##          Seems to only play the first file,
##          although the other files appear in the playlist.
##
##          The user may have to interactively specify that all the
##          files in the playlist are to be played.
##
##          NOTE: This method is not really needed because we have a script
##          that plays ALL the mp3s in a directory, with 'smplayer'.
##          It works by building a 'playlist' file. But there may
##          be an alternative use of this '-add-to-playlist' option of
##          'smplayer'. We might alter this script to re-purpose it for
##          such an alternative use.
##
## METHOD:  In a for-loop on the filenames, calls 'smplayer -add-to-playlist'
##          (in the background, with '&') once for each filename.
##
## HOW TO USE: In Nautilus, navigate to a directory of mp3 files
##             and select a set of mp3 files in the directory.
##             Then right-click and then choose this Nautilus script
##             to run (name above).
##
#########################################################################
## Created: 2011jul08 Based on the 2010dec05 '-playlist' version.
## Changed: 2012feb29 Changed the script name in the comment above.
##                    Added the METHOD comments section above.
## Changed: 2013apr10 Added check for the player executable. 
########################################################################

## FOR TESTING: (show statements as they execute)
  set -x

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


####################################
## START THE LOOP on the filenames.
####################################

for FILENAME
do

  ####################################################################
  ## Get and check that the file extension is 'mp3'.
  ##     Assumes one period (.) in filename, at the extension.
  ####################################################################
    FILEEXT=`echo "$FILENAME" | cut -d\. -f2`
 
    if test ! "$FILEEXT" = "mp3"
    then
       continue
       # exit
    fi

  ###########################################
  ## Add the file to the smplayer playlist.
  ###########################################

  ## FOR TESTING:
  #  xterm -fg white -bg black -hold -e \

  # /usr/bin/smplayer -add-to-playlist "$FILENAME" &

  $EXE_FULLNAME -add-to-playlist "$FILENAME" &

  sleep 1

done
## END OF LOOP: for FILENAME

##########################################################
## We could add a zenity prompt to 'shuffle' the files.
## But smplayer does not accept a command parm like
## '-shuffle' or '-random'. Might have to use a different
## method. Doesn't seem to accept a '-loop' parm either.
## Would be nice to do:
##    /usr/bin/smplayer -loop 0 -shuffle $MP3NAMES
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

  # /usr/bin/smplayer "$FILENAME"

   $EXE_FULLNAME "$FILENAME"

done
