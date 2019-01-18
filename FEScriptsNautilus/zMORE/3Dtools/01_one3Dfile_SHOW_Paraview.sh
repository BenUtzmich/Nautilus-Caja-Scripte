#!/bin/sh
##
## Nautilus
## SCRIPT: 00_one3Dfile_SHOW_Paraview.sh
##
## PURPOSE: Show a 3D file (like '.ply', '.vtk', or some other
##          '.vt*' format), using the Paraview program.
##
## METHOD:  Uses 'zenity' to warn if the file format may
##          not be supported by Paraview.
##
##          We run 'paraview' in an 'xterm' so that we can
##          see error messages to stdout, if any.
##
##          Some info on installing 3D viewers, like Paraview, is available at
##   http://www.subdude-site.com/WebPages_Local/RefInfo/Computer/Linux/LinuxGuidesByBlaze/apps3Dtools/3D_viewers-converters/3DviewersANDconverters_intro.htm
##
## HOW TO USE: In Nautilus, navigate to a 3D file that you want to
##             view, right-click the file, and select this
##             script to run from your menu of Nautilus scripts.
##
##########################################################################
## MAINTENANCE HISTORY:
## Started: 2011jan11 
## Changed: 2012apr18 Changed script name in comments above and touched up
##                    the comments. Changed some indenting below.
## Changed: 2013feb25 Added a 'zenity --info' popup to provide usage
##                    info on Paraview. Added logic to set $VIEWER3D from
##                    a 'central' or 'local' version of Paraview.
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
## A zenity 'info' window to show Paraview usage info.
###########################################################

zenity --info --title "Paraview Usage Info" \
   --no-wrap \
   --text  "\
Paraview Usage Info:

'paraview' reads '.stl' and '.ply' files and various VTK format files
--- '.vtk', '.vtu', etc. It has a rather sophisticated viewing interface,
probably due to the fact that the program has been developed to run on
parallel processing machines --- hence the 'para' prefix. 
" &


## Give the user a second or two to start reading the info.
sleep 2


###################################################################
## Check that the selected file is a '.ply' or '.stl' or 'stlb' or
## '.vtk' file --- or some other 3D file viewable by Paraview.
## (Other suffixes may be added.)
###################################################################

if test "$FILEEXT" != "ply" -a "$FILEEXT" != "stl" -a "$FILEEXT" != "stlb" -a \
        "$FILEEXT" != "vtk" -a "$FILEEXT" != "vtu"

then

   CURDIRFOLDED=`echo "$CURDIR" | fold -55`

   zenity  --question --title "Warning: May be unsupported by Paraview." \
           --text  "
The file you selected may not be viewable in Paraview.
The selected file is 

    $FILENAME

in directory

    $CURDIRFOLDED

Paraview reads Ply, STL (ascii or binary), and various VTK files.
Continue or Cancel?"

   if test $? != 0
   then
      exit
   fi

fi


###################################################################
## Set a 'central' or 'local' version of paraview to use.
###################################################################
## NOTE: The 'local' version of 'paraview' uses 'dynamic loading'
## of shared libraries and may not run if the shared libraries
## on this machine are not compatible with 'the build'.
## One may be able to work around incompatible 'shared objects'
## by use of a LD_LIBRARY_PATH environment variable in this script
## and by finding compatible shared objects and pointing to their
## location with a LD_LIBRARY_PATH variable.
###################################################################

if test -f /usr/bin/paraview
then
   VIEWER3D="/usr/bin/paraview"
else
   . $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
   VIEWER3D="$DIR_NautilusScripts/zMORE/3Dtools/.paraview"
fi


###################################################################
## Show the selected 3D file with Paraview --- in an xterm.
###################################################################

## FOR TEST: (show statements as they execute)
#   set -x

xterm -hold -fg white -bg black -geometry 80x30+25+25 -e \
   $VIEWER3D --data="$FILENAME"

## FOR TEST: (turn off display of statements)
#   set -
