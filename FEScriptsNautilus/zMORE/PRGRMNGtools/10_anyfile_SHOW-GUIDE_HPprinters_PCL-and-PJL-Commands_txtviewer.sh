#!/bin/sh
##
## Nautilus
## SCRIPT: 10_anyfile_SHOW-GUIDE_HPprinters_PCL-and-PJL-Commands_txtviewer.sh
##
## PURPOSE: This script shows a text file that lists HP printer
##          PCL (Printer Command Language) and PJL (Printer Job Language)
##          printer command codes.
##
##          Although these codes might vary occasionally for particular
##          HP printer models, in the 1995-2010 time frame, these codes
##          probably worked on at least 90% of HP printer models.
##
## METHOD: This script shows the text file with a text-viewer of the
##         user's choice.
##
## HOW TO USE: In Nautilus, select ANY file in ANY directory.
##             Then right-click and choose this script to run (name above).
##
############################################################################
## Created: 2010aug26
## Changed: 2011may11 Get 'nautilus-scripts' directory via an include script.
## Changed: 2012may11 Changed script name in comments above and touched up
##                    the comments. Changed some indenting below.
###########################################################################

## FOR TESTING: (show statements as they execute)
#  set -x

######################################################
## Get the dir of this script, because the .helps
## directory is under that directory.
######################################################

THISDIR=`dirname $0`

## FOR TESTING:
#   zenity -info -text "THISDIR = $THISDIR"


############################
## Show the help file.
############################

OUTFILE="$THISDIR/.helps/hp_pcl_pjl_cmds.txt"

## . $HOME/.gnome2/nautilus-scripts/.set_VIEWERvars.shi

. $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
. $DIR_NautilusScripts/.set_VIEWERvars.shi

$TXTVIEWER "$OUTFILE"

##########################################################################
## The following statement keeps this script from completing,
## so that the script can be tested --- with output to stdout and
## stderr showing in a terminal --- when using Nautilus
## 'Open > Run in a Terminal'. NOTE: Since xpg runs as a 'background'
## process, the terminal window would, without the statement below,
## immediately close after xpg shows the file. (Also could use 'xpg -f'.)
##
## Comment this line, to deactivate it.
#########################################################################
#   read ANY_KEY_to_exit
