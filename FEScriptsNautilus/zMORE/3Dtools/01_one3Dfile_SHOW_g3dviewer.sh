#!/bin/sh
##
## Nautilus
## SCRIPT: 00_one3Dfile_SHOW_g3dviewer.sh
##
## PURPOSE: Show a 3D file using the 'g3dviewer' program.
##          'g3dviewer' is said to read the many 3D file formats
##          supported by the LibG3D library.
##          The formats handled by LibG3D include '.3ds', '.lwo',
##          '.obj', '.dxf', '.md2', '.md3', '.wrl', '.vrml',
##          '.dae' (COLLADA), '.ase' (ASCII Scene Exporter), '.ac' (AC3D)
##
## METHOD:  Uses 'zenity' to warn if the file format may
##          not be supported by 'g3dviewer'.
##
##          We run 'g3dviewer' in an 'xterm' so that we can
##          see error messages to stdout, if any.
##
##          Some info on installing 3D viewers, like g3dviewer, is available at
##   http://www.subdude-site.com/WebPages_Local/RefInfo/Computer/Linux/LinuxGuidesByBlaze/apps3Dtools/3D_viewers-converters/3DviewersANDconverters_intro.htm
##
## HOW TO USE: In Nautilus, navigate to a 3D file that you want to
##             view, right-click the file, and select this
##             script to run from your menu of Nautilus scripts.
##
##########################################################################
## MAINTENANCE HISTORY:
## Started: 2013feb25 
## Changed: 2013
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
## A zenity 'info' window to show 'g3dviewer' usage info.
###########################################################

zenity --info --title "'g3dviewer' Usage Info" \
   --no-wrap \
   --text  "\
'g3dviewer' Usage Info:

'g3dviewer' is said to read the many 3D file formats supported by
the LibG3D library.

The formats handled by LibG3D include
   - 3D Studio Max '3ds' files
   - Wavefront 'obj' files
   - Lightwave 'lwo' files
   - AutoCAD 'dxf' files
   - VRML2 'wrl' files
   - VRML1 'vrml' files
   - Quake 'md2' and 'md3' files
   - Collada 'dae' files 
   - ASCII Scene Exporter 'ase' files
   - AC3D 'ac' files" &


## Give the user a second or two to start reading the info.
sleep 2


###################################################################
## Check that the selected file is a '.3ds' or '.obj' or 'lwo' or
## '.dxf' file --- or some other 3D file viewable by 'g3dviewer'.
## (Other suffixes may be added.)
###################################################################

if test "$FILEEXT" != "3ds" -a "$FILEEXT" != "obj" -a "$FILEEXT" != "lwo" -a \
        "$FILEEXT" != "dxf" -a "$FILEEXT" != "wrl" -a "$FILEEXT" != "vrml" -a \
        "$FILEEXT" != "md2" -a "$FILEEXT" != "md3" -a "$FILEEXT" != "dae" -a \
        "$FILEEXT" != "ase" -a "$FILEEXT" != "ac"
then

   CURDIRFOLDED=`echo "$CURDIR" | fold -55`

   zenity  --question --title "Warning: May be unsupported by 'g3dviewer'." \
           --text  "
The file you selected may not be viewable in 'g3dviewer'.
The selected file is 

    $FILENAME

in directory

    $CURDIRFOLDED

'g3dviewer' is said to read 3DS, OBJ, LWO, DXF, WRL (VRML2), VRML (VRML1),
Quake MD2, QuakeMD3, ASCII Scene Exporter ASE, AC3D AC, and Collada DAE files.
Continue or Cancel?"

   if test $? != 0
   then
      exit
   fi

fi


###################################################################
## Set a 'central' or 'local' version of 'g3dviewer' to use.
###################################################################
## NOTE: The 'local' version of 'g3dviewer' uses 'dynamic loading'
## of shared libraries and may not run if the shared libraries
## on this machine are not compatible with 'the build'.
## One may be able to work around incompatible 'shared objects'
## by use of a LD_LIBRARY_PATH environment variable in this script
## and by finding compatible shared objects and pointing to their
## location with a LD_LIBRARY_PATH variable.
###################################################################

if test -f /usr/bin/g3dviewer
then
   VIEWER3D="/usr/bin/g3dviewer"
else
   . $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
   VIEWER3D="$DIR_NautilusScripts/zMORE/3Dtools/.g3dviewer"
fi


###################################################################
## Show the selected 3D file with 'g3dviewer' --- in an xterm.
###################################################################

## FOR TEST: (show statements as they execute)
#   set -x

xterm -hold -fg white -bg black -geometry 80x30+25+25 -e \
   $VIEWER3D "$FILENAME"

## FOR TEST: (turn off display of statements)
#   set -
