#!/bin/sh
##
## Nautilus
## SCRIPT: 02a_1movieFile_PLAY_xterm-ffplay-stats.sh
##
## PURPOSE: PLAY a movie file (any format) with 'ffmplay -stats'.
##
## METHOD: There is no prompt for parameters.
##
##         The 'ffplay -stats' command is applied to the selected
##         file --- and is run in an 'xterm'.
##
## HOW TO USE: In Nautilus, select a movie file.
##             Then right-click and choose this script to run (name above).
##
###########################################################################
## Started: 2010oct27
## Changed: 2011jun13 Added '-geometry' parm to xterm.
## Changed: 2012may22 Changed script name in comments above and touched up
##                    the comments. Changed some indenting below.
###########################################################################

## FOR TESTING: (show statements as they execute)
#  set -x

###########################################
## Get the filename of the selected file.
###########################################

# FILENAME="$@"
  FILENAME="$1"
# FILENAMES="$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS"


###########################
## Show the movie file.
###########################

MOVIEPLAYER="/usr/bin/ffplay -stats"

xterm -fg white -bg black -hold -geometry 90x24+100+100 -e \
      $MOVIEPLAYER "$FILENAME"
