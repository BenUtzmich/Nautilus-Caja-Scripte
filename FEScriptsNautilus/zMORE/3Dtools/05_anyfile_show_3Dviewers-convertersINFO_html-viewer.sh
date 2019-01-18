#!/bin/sh
##
## Nautilus
## SCRIPT: 05_anyfile_show_3Dviewers-convertersINFO_html-viewer.sh
##
## PURPOSE: Show some 3D viewers & converters help, via a web page.
##
## HOW TO USE: In Nautilus, select ANY file in ANY directory,
##             right-click and choose this script (name above).
##
##########################################################################
## Created: 2011may23
## Changed: 2012apr18 Changed script name in comments above and touched up
##                    the comments. Changed some indenting below.
##########################################################################


## FOR TESTING: (show statements as they execute)
# set -x


######################################################
## Show some 3Dviewers-converters help, via a web page.
######################################################

## . $HOME/.gnome2/nautilus-scripts/.set_VIEWERvars.shi

. $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
. $DIR_NautilusScripts/.set_VIEWERvars.shi

$HTMLVIEWER "http://www.subdude-site.com/WebPages_Local/RefInfo/Computer/Linux/LinuxGuidesByBlaze/apps3Dtools/3D_viewers-converters/3DviewersANDconverters_intro.htm"
