#!/bin/sh
##
## Nautilus
## SCRIPT: 00_one3Dfile_SHOW_glc_player.sh
##
## PURPOSE: Show a 3D file (like '.3ds', '.obj', '.stl', '.off',
##          3Dxml, and Collada '.dae'), using the 'glc_player' program.
##
## METHOD:  Uses 'zenity' to warn if the file format may
##          not be supported by 'glc_player'.
##
##          We run 'glc_player' in an 'xterm' so that we can
##          see error messages to stdout, if any.
##
##          Some info on installing 3D viewers, like glc_player, is available at
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
## A zenity 'info' window to show glc_player usage info.
###########################################################

zenity --info --title "'glc_player' Usage Info" \
   --no-wrap \
   --text  "\
'glc_player' Usage Info:

'glc_player' is said to read
   - 3D Studio Max '3ds' files
   - Wavefront 'obj' files
   - Stereolithography 'stl' files
   - '3dxml' files
   - Collada 'dae' files 
" &


## Give the user a second or two to start reading the info.
sleep 2


###################################################################
## Check that the selected file is a '.3ds' or '.obj' or 'stl' or
## '.stlb' file --- or some other 3D file viewable by 'glc_player'.
## (Other suffixes may be added.)
###################################################################

if test "$FILEEXT" != "3ds" -a "$FILEEXT" != "obj" -a "$FILEEXT" != "stl" -a \
        "$FILEEXT" != "stlb" -a "$FILEEXT" != "dae"

then

   CURDIRFOLDED=`echo "$CURDIR" | fold -55`

   zenity  --question --title "Warning: May be unsupported by 'glc_player'." \
           --text  "
The file you selected may not be viewable in 'glc_player'.
The selected file is 

    $FILENAME

in directory

    $CURDIRFOLDED

'glc_player' reads 3DS, OBJ, STL, and Collada DAE files.
Continue or Cancel?"

   if test $? != 0
   then
      exit
   fi

fi


###################################################################
## Set a 'central' or 'local' version of glc_player to use.
###################################################################
## NOTE: The 'local' version of 'glc_player' uses 'dynamic loading'
## of shared libraries and may not run if the shared libraries
## on this machine are not compatible with 'the build'.
## One may be able to work around incompatible 'shared objects'
## by use of a LD_LIBRARY_PATH environment variable in this script
## and by finding compatible shared objects and pointing to their
## location with a LD_LIBRARY_PATH variable.
###################################################################

if test -f /usr/bin/glc_player
then
   VIEWER3D="/usr/bin/glc_player"
else
   . $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
   VIEWER3D="$DIR_NautilusScripts/zMORE/3Dtools/.glc_player"
fi


###################################################################
## Show the selected 3D file with 'glc_player' --- in an xterm.
###################################################################

## FOR TEST: (show statements as they execute)
#   set -x

xterm -hold -fg white -bg black -geometry 80x30+25+25 -e \
   $VIEWER3D "$FILENAME"

## FOR TEST: (turn off display of statements)
#   set -
