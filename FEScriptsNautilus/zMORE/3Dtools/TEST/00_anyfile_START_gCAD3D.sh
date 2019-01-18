#!/bin/sh
##
## Nautilus
## SCRIPT: 00_anyfile_START_gCAD3D.sh
##
## PURPOSE: Starts the 'gCAD3D' program --- specifically
##          gCAD3D-1.54-Linux-x86.
##
## METHOD: We run 'gCAD3D' in an 'xterm' so that we can
##         see error messages to stdout, if any.
##
## HOW TO USE: In Nautilus, navigate to ANY file,
##             right-click the file, and select this
##             script to run from your menu of Nautilus scripts.
##
##########################################################################
## Started: 2011jan11
## Changed: 2012apr18 Changed script name in comments above and touched up
##                    the comments. Changed some indenting below.
## Changed: 2013feb26 Added logic to set a 'central' or 'local' version of
##                   'gCAD3D' to use.
##########################################################################

## FOR TESTING: (display the executed statements)
# set -x

##############################################
## Get the filename of the selected file.
##############################################

#  FILENAME="$1"
## FILENAMES="$@"
## FILENAMES="$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS"

##################################################################
## Get the extension (suffix) of the input file.
##  (Assumes just one dot [.] in the filename, at the extension.)
##################################################################

#  FILEEXT=`echo "$FILENAME" | cut -d\. -f2`

###################################################################
## Check that the selected file is a '.xxx' or '.xxx' or 'xxxx' or
## '.xxx' file --- or some other CAD file viewable by gCAD3D.
## (Other suffixes may be added.)
###################################################################

# if test "$FILEEXT" != "wrl" -a "$FILEEXT" != "gz"
# then
# 
#    CURDIRFOLDED=`echo "$CURDIR" | fold -55`
# 
#    zenity  --question --title "Warning: May be unsupported by 'gCAD3D'." \
#            --text  "
# The file you selected may not be viewable in 'gCAD3D'.
# The selected file is 
# 
#     $FILENAME
# 
# in directory
# 
#     $CURDIRFOLDED
# 
# 'gCAD3D' reads '.wrl' (VRML2) files --- and '.wrl.gz'.
# Continue or Cancel?"

#    if test $? != 0
#    then
#       exit
#    fi
# 
# fi


###################################################################
## Set a 'central' or 'local' version of 'gCAD3D' to use.
###################################################################
## NOTE: The 'local' version of 'gCAD3D' uses 'dynamic loading'
## of shared libraries and may not run if the shared libraries
## on this machine are not compatible with 'the build'.
## One may be able to work around incompatible 'shared objects'
## by use of a LD_LIBRARY_PATH environment variable in this script
## and by finding compatible shared objects and pointing to their
## location with a LD_LIBRARY_PATH variable.
###################################################################

if test -f "/usr/bin/gCAD3D-1.54-Linux-x86"
then
   VIEWER3D="/usr/bin/gCAD3D-1.54-Linux-x86"
else
   . $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
   VIEWER3D="$DIR_NautilusScripts/zMORE/3Dtools/.gCAD3D-1.54-Linux-x86"
fi


###################################################################
## Start up gCAD3D --- in an xterm.
###################################################################

## FOR TEST: (show statements as they execute)
#   set -x

xterm -hold -fg white -bg black -geometry 80x30+25+25 -e \
   $VIEWER3D

## FOR TEST: (turn off display of statements)
#    set -
