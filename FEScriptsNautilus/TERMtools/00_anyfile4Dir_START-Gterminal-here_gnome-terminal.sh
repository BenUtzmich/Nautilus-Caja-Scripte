#!/bin/sh
##
## Nautilus
## SCRIPT: 00_anyfile4Dir_start_Gterminal_here_gnome-terminal.sh
##
## PURPOSE: This script opens a 'gnome-terminal' with the shell environment
##          'positioned' in the 'current' directory.
##
## METHOD:  Uses 'exec' to startup 'gnome-terminal'.
##
## HOW TO USE: In the Nautilus file manager, right-click on ANY file
##             (or directory) in a desired 'here' directory.
##             Then select this script to run (name above).
##
###########################################################################
## Created: 2010mar21
## Changed: 2010may19 Added title line to terminal, to indicate the curdir.
## Changed: 2012feb29 Changed the script name in the comment above.
##                    Commented out the 'cd' command.
##                    Added the parent directory name to the title.
## Changed: 2013apr10 Changed the title of the window ; moved 'sudir'.
###########################################################################

#####################################################
## Get the current directory, to set the title below.
#####################################################

CURDIR="`pwd`"

#############################################
## 'cd' to the current directory. NOT NEEDED.
## Nautilus will start this script 'there'.
############################################

## OLD:
# cd $NAUTILUS_SCRIPT_CURRENT_URI

# cd "$CURDIR"


#############################################################
## When starting up 'gnome-terminal',
## set the title at the top of the 'gnome-terminal' window to
## the 'basename' and parent 'dirname' of the current directory.
#############################################################

## OLD:
# exec gnome-terminal

CURDIR_BASENAME=`basename "$CURDIR"`
CURDIR_DIRNAME=`dirname  "$CURDIR"`

exec gnome-terminal -t "$CURDIR_BASENAME subdir of dir $CURDIR_DIRNAME"
