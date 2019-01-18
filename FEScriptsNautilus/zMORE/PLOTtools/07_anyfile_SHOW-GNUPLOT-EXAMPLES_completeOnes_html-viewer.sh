#!/bin/sh
##
## Nautilus
## SCRIPT: 07_anyfile_SHOW_GNUPLOT_EXAMPLES_completeOnes_html-viewer.sh
##
## PURPOSE: Show a gnuplot guide --- consisting of complete examples of
##          gnuplot commands --- a locally stored HTML page.
##
## METHOD: Shows the HTML file using an html-viewer of the user's choice.
##
## HOW TO USE: In Nautilus, select ANY file in ANY directory.
##             Then right-click and choose this script  to run (name above).
##
###########################################################################
## Created: 2011jun20
## Changed: 2011jul14 Changed the help file from a text file to an HTML file.
## Changed: 2012may11 Changed script name in comments above and touched up
##                    the comments. Changed some indenting below.
##########################################################################

## FOR TESTING: (show statements as they execute)
# set -x


##########################################################
## Get the name of the directory in which this script lies,
## because the html file is in a subdirectory
## of that directory.
#######################################################

THISDIR=`dirname $0`

## FOR TESTING:
#   zenity -info -text "THISDIR = $THISDIR"


#################################
## Set the html filename.
#################################

HTMLfile="$THISDIR/.examples/gnuplot_examples_TableOfTextareas_textareasDownPage.htm"


#######################################
## Show the gnuplot-examples HTML file.
#######################################

## . $HOME/.gnome2/nautilus-scripts/.set_VIEWERvars.shi

. $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
. $DIR_NautilusScripts/.set_VIEWERvars.shi

$HTMLVIEWER "$HTMLfile"
