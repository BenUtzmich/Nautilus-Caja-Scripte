#!/bin/sh
##
## Nautilus
## SCRIPT: 00_one3Dfile_CONVERT_ivread_2002.sh
##
## PURPOSE: Convert a 3D file to another format, using
##          John Burkhardt's 'ivread' Fortran program, the 2002 version.
##
## METHOD:  Uses 'zenity' to prompt for the 'TO' file format
##          and extension, such as
##               dxf , iv , obj , off , pov, stl , wrl
##
##          Shows the new converted file in an appropriate viewer:
##                - ivview for '.iv' Inventor files
##                - glc_player  '.dxf, '.obj', '.stl'
##                - whitedune for VRML2 '.wrl'
##
##          Some info on installing these 3D viewers is available at
##   http://www.subdude-site.com/WebPages_Local/RefInfo/Computer/Linux/LinuxGuidesByBlaze/apps3Dtools/3D_viewers-converters/3DviewersANDconverters_intro.htm
##
## HOW TO USE: In Nautilus, navigate to a 3D file that you want to
##             convert, right-click the file, and select this
##             script to run from your menu of Nautilus scripts.
##
## MESSAGE FROM IVREAD, when it is started interactively:
##
##  Hello:  This is IVRead,
##    a program which can convert some files from
##    some 3D graphics format to some others:
##   
##      ".ase"  3D Studio Max ASCII export;
##      ".byu"  Movie.BYU surface geometry;
##      ".dxf"  AutoCAD DXF;
##      ".hrc"  SoftImage hierarchy;
##      ".iv"   SGI Open Inventor;
##      ".obj"  WaveFront Advanced Visualizer;
##      ".off"  Geomview OFF file;
##      ".oogl" OOGL file (input only);
##      ".pov"  Persistence of Vision (output only);
##      ".ps"   PostScript (output only)(NOT READY);
##      ".smf"  Michael Garland's format;
##      ".stl"  ASCII StereoLithography;
##      ".stla" ASCII StereoLithography;
##      ".tec"  TECPLOT (output only);
##      ".tri"  [Greg Hood triangles, ASCII];
##      ".tria" [Greg Hood triangles, ASCII];
##      ".ts"   Mathematica ThreeScript (output only);
##      ".3s"   Mathematica ThreeScript (output only);
##      ".txt"  Text (output only);
##      ".ucd"  AVS unstructured cell data (output only);
##      ".vla"  VLA; (points and lines);
##      ".wrl"  VRML;
##      ".xgl"  XGL (output only) (DEVELOPMENT)
##      ".xyz"  XYZ (points and lines);
##   
##    Current limits:
##   
##     50000 points;
##     50000 line items;
##     50000 faces.
##   
##         6 vertices per face;
##      1000 points to display;
##       200 materials;
##        10 textures.
##   
##    Last modified: 04 June 2002.
##   
##    By burkardt@iastate.edu.
##
#######################################################################
## Script
## Started: 2011jan11
## Changed: 2011may23 Put '.ivread_2002.exe' in the feNautilusScripts 3Dtools dir.
## Changed: 2012apr18 Changed script name in comments above and touched up
##                    the comments. Changed some indenting below.
## Changed: 2011dec18 Fixed directory - put '.ivread_2002.exe' in the
##                    feNautilusScripts zMORE/3Dtools dir.
## Changed: 2013feb24 Added a 'zenity --info' popup to provide usage
##                    info on IVREAD.
#######################################################################

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

#  FILEEXT=`echo "$FILENAME" | cut -d\. -f2`

###################################################################
## Check that the selected file is a 'iv' or 'obj' or 'ply' file
## --- or some other 3D file, suffix to be added.
###################################################################

#  if test "$FILEEXT" != "iv"  -a "$FILEEXT" != "obj" -a \
#          "$FILEEXT" != "ply" -a "$FILEEXT" != "stl"
#  then
#     exit
#  fi


###########################################################
## A zenity 'info' window(s) to show IVREAD usage info.
###########################################################

zenity --info --title "IVREAD Usage Info, Page 2" \
   --no-wrap \
   --text  "\
IVREAD Usage Info (page 2 of 2):

NOTE: Among these formats, '.ase', '.dxf', '.iv', VRML1, '.obj',
'.off', and '.stl'/'.stla' are relatively commonly found
formats. This script utility is mainly meant to support
conversions among these formats.

OUTPUT ONLY:

   '.pov'  Persistence of Vision (output only);
   '.ps'   PostScript (output only)(NOT READY);
   '.tec'  TECPLOT (output only);
   '.ts'   Mathematica ThreeScript (output only);
   '.3s'   Mathematica ThreeScript (output only);
   '.txt'  Text (output only);
   '.ucd'  AVS unstructured cell data (output only);
   '.xgl'  XGL (output only) (DEVELOPMENT)

 Current limits:
   50,000 points;  50,000 faces;  50,000 line items.
   6 vertices per face; 200 materials; 10 textures.

 Last modified: 04 June 2002 by burkardt@iastate.edu.
 Reference: http://people.sc.fsu.edu/~jburkardt/
" &


zenity --info --title "IVREAD Usage Info, Page 1" \
   --no-wrap \
   --text  "\
IVREAD Usage Info (page 1 of 2):

This script tries to put the output file in the same directory
as the input file.

IVREAD is a compiled FORTRAN90 program which can convert some files from
some 3D graphics format to some others.

The following file types can be used for input, and (unless otherwise
indicated) can be used for output.

   '.ase'  3D Studio Max ASCII export
   '.byu'  Movie.BYU surface geometry
   '.dxf'  AutoCAD DXF
   '.hrc'  SoftImage hierarchy
   '.iv'   SGI Open Inventor
            NOTE: VRML1 is a subset of Inventor. If you edit
                  a VRML1 file and change its header from
                  '#VRML' to '#Inventor', IVREAD may be able to
                  convert the VRML1 file to '.obj', '.off', etc.
   '.obj'  WaveFront Advanced Visualizer
   '.off'  Geomview OFF file
   '.oogl' OOGL file (input only)
   '.smf'  Michael Garland's format
   '.stl'  ASCII StereoLithography
   '.stla' ASCII StereoLithography
   '.tri'  [Greg Hood triangles, ASCII]
   '.tria' [Greg Hood triangles, ASCII]
   '.vla'  VLA (points and lines)
   '.wrl'  VRML
            NOTE: This is the VRML2 (a.k.a. VRML97) format which
            is not compatible with the VRML1 format. That is, the
            VRML1 spec is not a subset of the VRML2 spec.
   '.xyz'  XYZ (points and lines)

See page 2 of this info." &


## Give the user a second or two to start reading the help info.
sleep 2


#############################################################################
## Prompt for the 'TO' format of the new 3D file.
##
## Examples: dxf , iv , obj , off , pov, stl , wrl
#############################################################################

NEWFMT=""

NEWFMT=$(zenity --entry \
   --title "SUFFIX (FORMAT) of the new 3D file." \
   --text "\
Enter an indicator of the suffix (format) of the new, output.
3D file. Main Output Options: dxf , iv , obj , off , pov, stl , wrl" \
   --entry-text "off")

if test "$NEWFMT" = ""
then
   exit
fi


###############################
## Prepare the output filename.
###############################

FILENAMECROP=`echo "$FILENAME" | cut -d\. -f1`

FILEOUT="${FILENAMECROP}_new.$NEWFMT"

if test -f "$FILEOUT"
then
   rm -f "$FILEOUT"
fi

###################################################################
## Use 'ivread' to make the new 3D file.
###################################################################

. $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi

## FOR TEST: (show statements as they execute)
#   set -x

xterm -hold -fg white -bg black \
      -geometry 80x30+25+25 -e \
      $DIR_NautilusScripts/zMORE/3Dtools/.ivread_2002.exe "$FILENAME" "$FILEOUT"

## FOR TEST: (turn off display of statements)
#   set -


##################################
## Show the new 3D file.
##################################

if test ! -f "$FILEOUT"
then
   exit
fi

if test "$NEWFMT" = "dxf"
then

   zenity --info \
          --title "No DXF Viewer." \
          --text "\
We do not try to start a DXF Viewer at this time.
You could try converting the DXF file to another format
--- say with the 'ivcon' program --- and view that file."

fi

if test "$NEWFMT" = "iv"
then
   ivview "$FILEOUT"
fi

if test "$NEWFMT" = "obj"
then
   glc_player "$FILEOUT"
fi

if test "$NEWFMT" = "off"
then

   zenity --info \
          --title "No OFF Viewer." \
          --text "\
We do not try to start an OFF Viewer, like geomview, at this time.
You could try converting the OFF file to another format
--- say with the 'ivcon' program --- and view that file."

fi

if test "$NEWFMT" = "pov"
then

   zenity --info \
          --title "No POV Viewer." \
          --text "\
We do not try to start a POV Viewer at this time.
You could try converting the POV file to another format
--- say with the 'ivcon' program --- and view that file."

fi

if test "$NEWFMT" = "stl"
then
   glc_player "$FILEOUT"
fi

if test "$NEWFMT" = "wrl"
then
   whitedune "$FILEOUT"
fi
