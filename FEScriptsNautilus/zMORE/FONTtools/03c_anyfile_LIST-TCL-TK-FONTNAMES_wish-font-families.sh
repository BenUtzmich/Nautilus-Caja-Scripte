#!/bin/sh
##
## NAUTILUS
## SCRIPT: 03c_anyfile_LIST-TCL-TK-FONTNAMES_wish-font-families.sh
##
## PURPOSE: List names of fonts known to Tcl-Tk.
##
## METHOD:  A '.tk' script gets the font 'families' and puts them in a list
##          file.
##
##          The list file is shown in a text-viewer of the user's choice.
##
## HOW TO USE: In Nautilus, select ANY file in ANY directory.
##             Then right-click and choose this script to run (name above).
##
###########################################################################
## Script
## Created: 2010jun01
## Changed: 2010aug26 Get directory of auxiliary script '.list_fonts_TclTk.tk'
##                    by using "dirname $0".
## Changed: 2011may02 Added $USER to a temp filename.
## Changed: 2011may11 Get 'nautilus-scripts' directory via an include script
##                    --- to specify the text-viewer.
## Changed: 2012apr18 Changed script name in comments above and touched up
##                    the comments. Changed some indenting below.
#######################################################################

## FOR TESTING: (show statements as they execute)
#  set -x


###############################################################
## Prep a temporary filename, to hold the list of font names.
##      We put the outlist file in /tmp, in case the user
##      does not have write-permission in the current directory,
##      and because the output does not, usually, have anything
##      to do with the current directory.
###############################################################

OUTLIST="${USER}_list_fonts_TclTk.lis"

OUTLIST="/tmp/$OUTLIST"
 
if test -f "$OUTLIST"
then
   rm -f "$OUTLIST"
fi


#########################
## Make HEADER for list.
#########################

echo "\
Fonts known to Tcl-Tk:
#####################
" > "$OUTLIST"


######################################
## Execute a wish script that runs the
## 'font families' tcl-tk command.
######################################

# $HOME/.gnome2/nautilus-scripts/zMORE/FONTtools/.list_fonts_TclTk.tk \
#    >> "$OUTLIST"

THISDIR=`dirname $0`

## FOR TESTING:
#   zenity --info --text "THISDIR: `dirname $0`"

$THISDIR/.list_fonts_TclTk.tk >> "$OUTLIST"


###################################
## Show the list of font names.
###################################

## . $HOME/.gnome2/nautilus-scripts/.set_VIEWERvars.shi

. $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
. $DIR_NautilusScripts/.set_VIEWERvars.shi

$TXTVIEWER  "$OUTLIST"
