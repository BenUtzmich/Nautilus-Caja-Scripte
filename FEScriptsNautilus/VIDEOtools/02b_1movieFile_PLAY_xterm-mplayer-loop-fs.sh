#!/bin/sh
##
## Nautilus
## SCRIPT: 02c_1movieFile_PLAY_xterm-mplayer-loop-fs.sh
##
## PURPOSE: PLAY a movie file (any format) repeatedly with
##          'mplayer -loop 0 -fs'.
##
## METHOD: There is no prompt for parameters.
##
##         The 'mplayer -loop 0 -fs' command is applied to the selected
##         file --- and is run in an 'xterm'.
##
## HOW TO USE: In Nautilus, select a movie file.
##             Then right-click and choose this script to run (name above).
##
###########################################################################
## Started: 2012dec09
## Changed: 2013apr10 Added check for the mplayer executable. 
###########################################################################

## FOR TESTING: (show statements as they execute)
#  set -x

#########################################################
## Check if the mplayer executable exists.
#########################################################

EXE_FULLNAME="/usr/bin/mplayer"

if test ! -f "$EXE_FULLNAME"
then
   zenity  --info --title "Executable NOT FOUND." \
   --no-wrap \
   --text  "\
The mplayer executable
   $EXE_FULLNAME
was not found. Exiting.

If the executable is in another location,
you can edit this script to change the filename.
OR, install the 'mplayer' package."
   exit
fi


###########################################
## Get the filename of the selected file.
###########################################

# FILENAME="$@"
  FILENAME="$1"
# FILENAMES="$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS"


###########################
## Show the movie file.
###########################

# MOVIEPLAYER="/usr/bin/mplayer -loop 0 -fs"

MOVIEPLAYER="$EXE_FULLNAME -loop 0 -fs"

xterm -fg white -bg black -hold -geometry 90x24+100+100 -e \
      $MOVIEPLAYER "$FILENAME"
