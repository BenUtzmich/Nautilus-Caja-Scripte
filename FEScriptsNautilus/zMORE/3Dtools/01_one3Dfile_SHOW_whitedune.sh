#!/bin/sh
##
## Nautilus
## SCRIPT: 00_one3Dfile_SHOW_whitedune.sh
##
## PURPOSE: Show a 3D file ( '.wrl' VRML2 = VRML97 )
##          using the 'whitedune' program.
##
## METHOD:  Uses 'zenity' to warn if the file format may
##          not be supported by whitedune.
##
##          We run 'whitdune' in an 'xterm' so that we can
##          see error messages to stdout, if any.
##
## HOW TO USE: In Nautilus, navigate to a 3D file that you want to
##             view, right-click the file, and select this
##             script to run from your menu of Nautilus scripts.
##
##          Some info on installing 3D viewers, like whitedune, is available at
##   http://www.subdude-site.com/WebPages_Local/RefInfo/Computer/Linux/LinuxGuidesByBlaze/apps3Dtools/3D_viewers-converters/3DviewersANDconverters_intro.htm
##
##########################################################################
## Started: 2011 Jan 11
## Changed: 2012apr18 Changed script name in comments above and touched up
##                    the comments. Changed some indenting below.
## Changed: 2013feb25 Added a 'zenity --info' popup to provide usage
##                    info on 'whitedune'. Added logic to set $VIEWER3D from
##                    a 'central' or 'local' version of 'whitedune'.
##########################################################################

## FOR TESTING: (display the executed statements)
# set -x

##############################################
## Get the filename of the selected file.
##############################################

  FILENAME="$1"
# FILENAMES="$@"
# FILENAMES="$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS"

##################################################################
## Get the extension (suffix) of the input file.
##  (Assumes just one dot [.] in the filename, at the extension.)
##################################################################

FILEEXT=`echo "$FILENAME" | cut -d\. -f2`


###########################################################
## A zenity 'info' window to show 'whitedune' usage info.
###########################################################

zenity --info --title "'whitedune' Usage Info" \
   --no-wrap \
   --text  "\
'whitedune' Usage Info:

'whitedune' reads newer VRML files ('VRML2' also known as 'VRML97')
and, supposedly, some very specific 'X3D' files, which are basically
VRML2 wrapped in XML) --- suffix typically '.wrl' or '.x3d'. 

'whitedune' is actually a VRML2 *EDITOR*, which makes its interface
much more complicated than pure viewers like 'glc_player', 'g3dviewer',
'ivview' and 'paraview'.
" &


## Give the user a second or two to start reading the info.
sleep 2



###################################################################
## Check that the selected file is a '.wrl' or '.wrl.gz'
## --- or some other 3D file viewable by 'whitedune'.
## (Other suffixes may be added.)
###################################################################

if test "$FILEEXT" != "wrl" -a "$FILEEXT" != "gz"
then

   CURDIRFOLDED=`echo "$CURDIR" | fold -55`

   zenity  --question --title "Warning: May be unsupported by 'whitedune'." \
           --text  "
The file you selected may not be viewable in 'whitedune'.
The selected file is 

    $FILENAME

in directory

    $CURDIRFOLDED

'whitedune' reads '.wrl' (VRML2) files --- and '.wrl.gz'.
Continue or Cancel?"

   if test $? != 0
   then
      exit
   fi

fi


###################################################################
## Set a 'central' or 'local' version of 'whitedune' to use.
###################################################################
## NOTE: The 'local' version of 'whitedune' uses 'dynamic loading'
## of shared libraries and may not run if the shared libraries
## on this machine are not compatible with 'the build'.
## One may be able to work around incompatible 'shared objects'
## by use of a LD_LIBRARY_PATH environment variable in this script
## and by finding compatible shared objects and pointing to their
## location with a LD_LIBRARY_PATH variable.
###################################################################

if test -f /usr/bin/whitedune
then
   VIEWER3D="/usr/bin/whitedune"
else
   . $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
   VIEWER3D="$DIR_NautilusScripts/zMORE/3Dtools/.whitedune"
fi


###################################################################
## Show the selected 3D file with 'whitedune' --- in an xterm.
###################################################################

## FOR TEST: (show statements as they execute)
#   set -x

xterm -hold -fg white -bg black -geometry 80x30+25+25 -e \
      $VIEWER3D "$FILENAME"

## FOR TEST: (turn off display of statements)
#   set -
