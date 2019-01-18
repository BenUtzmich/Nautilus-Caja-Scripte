#!/bin/sh
##
## Nautilus
## SCRIPT: 00_multiFiles_SHOW_with_XPG_for-loop.sh
##
## PURPOSE: Shows selected file(s) [in a directory] using the
##          FE system 'xpg' Tcl-Tk text-browser utility.
##
## METHOD:  In a for-loop, passes each filename to an instance of 'xpg'. 
##
## HOW TO USE: In Nautilus, navigate to a file(s), select it/them,
##             right-click and choose this Nautilus script to run.
##
## Created: 2010apr11
## Changed: 2010aug27 Chgd pathname of xpg script to "$HOME/apps/feXpg/scripts/xpg".
## Changed: 2011may23 Chgd pathname of xpg script to "$HOME/apps/bin/xpg".
## Changed: 2011jul07 Changed to handle filenames with embedded spaces.
##                    (Removed use of FILENAMES var and use a 'for' loop
##                     WITHOUT the 'in' phrase.  Ref: man bash )
## Changed: 2012feb29 Changed the script name in the comment above.

## FOR TESTING: (show statements as they execute)
# set -x

#################################################
## Multiple ways of specifying the path to 'xpg':
##
## XPG="$HOME/apps/feXpg_yyyymmmdd/scripts/xpg"
## XPG="$HOME/apps/bin/xpg"
################################################

XPG="$HOME/apps/bin/xpg"


################################################
## START THE LOOP on the filenames.
##
## NOTE: The xpg wrapper script is written to
##       show up to 8 files.
################################################

for FILENAME
do

  $XPG  "$FILENAME"

  ## Allow some time between displays, to make sure
  ## the user knows there are multiple windows.
  sleep 1

done
