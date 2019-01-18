#!/bin/sh
##
## Nautilus
## SCRIPT: 00_anyfile4Dir_start_Xterminal_here_xterm.sh
##
## PURPOSE: This script opens an X-terminal with the shell environment
##          'positioned' in the current directory.
##
## METHOD:  Uses 'exec' to startup 'xterm'.
##
## HOW TO USE: In the Nautilus file manager, right-click on ANY file
##             (or directory) in a desired 'here' directory.
##             Then select this script to run (name above).
##
## Created: 2010apr03
## Changed: 2010may19 Added a title to the terminal to show the curdir.
## Changed: 2012feb29 Changed the script name in the comment above.
##                    Commented out the 'cd' command.
##                    Added the parent directory name to the title.

#####################################################
## Get the current directory, to set the title below.
#####################################################

CURDIR="`pwd`"

#############################################
## 'cd' to the current directory. NOT NEEDED.
## Nautilus will start this script 'there'.
############################################

## OLD: (We should try to avoid using NAUTILUS_SCRIPT vars,
##       so that these scripts might be used in non-Nautilus
##       environments.)
# cd $NAUTILUS_SCRIPT_CURRENT_URI

# cd "$CURDIR"


#############################################################
## When starting up 'xterm',
## set the title at the top of the 'xterm' window to
## the 'basename' and parent 'dirname' of the current directory.
#############################################################

## OLD:
# exec xterm -fg white -bg black

CURDIR_BASENAME=`basename "$CURDIR"`
CURDIR_DIRNAME=`dirname  "$CURDIR"`

exec xterm -fg white -bg black \
   -geometry 115x34+100+100 \
   -title "STARTED at subdir $CURDIR_BASENAME of dir $CURDIR_DIRNAME"
