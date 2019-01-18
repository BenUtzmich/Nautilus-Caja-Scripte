#!/bin/sh
##
## Nautilus
## SCRIPT: 00_one3Dfile_CONVERT_ivcon_2004.sh
##
## PURPOSE: Convert a 3D file to another format, using
##          John Burkhardt's 'ivcon' program, the 2004 version.
##
## METHOD:  Uses 'zenity' to prompt for the 'TO' file format
##          and extension, such as
##              3ds, dxf, iv, obj, off, pov, stl, stlb, wrl
##
##          Shows the new converted file in an appropriate viewer:
##                - ivview for '.iv' Inventor files
##                - glc_player for '.3ds', '.obj', '.stl', '.stlb'
##                - whitedune for VRML2 '.wrl'
##
##          Some info on installing these 3D viewers is available at
##   http://www.subdude-site.com/WebPages_Local/RefInfo/Computer/Linux/LinuxGuidesByBlaze/apps3Dtools/3D_viewers-converters/3DviewersANDconverters_intro.htm
##
## HOW TO USE: In Nautilus, navigate to a 3D file that you want to
##             convert, right-click the file, and select this
##             script to run from your menu of Nautilus scripts.
##
## MESSAGE FROM IVCON, when it is run interactively:
##
##  Hello:  This is IVCON,
##    for 3D graphics file conversion.
##  
##      ".3ds"   3D Studio Max binary;
##      ".ase"   3D Studio Max ASCII export;
##      ".byu"   Movie.BYU surface geometry;
##      ".dxf"   DXF;
##      ".gmod"  Golgotha model;
##      ".hrc"   SoftImage hierarchy;
##      ".iv"    SGI Open Inventor;
##      ".obj"   WaveFront Advanced Visualizer;
##      ".off"   GEOMVIEW Object File Format;
##      ".pov"   Persistence of Vision (output only);
##      ".smf"   Michael Garland's format;
##      ".stl"   ASCII StereoLithography;
##      ".stla"  ASCII StereoLithography;
##      ".stlb"  Binary StereoLithography;
##      ".tec"   TECPLOT (output only);
##      ".tri"   [Greg Hood ASCII triangle format];
##      ".tria"  [Greg Hood ASCII triangle format];
##      ".trib"  [Greg Hood binary triangle format];
##      ".txt"   Text (output only);
##      ".ucd"   AVS UCD file(output only);
##      ".vla"   VLA;
##      ".wrl"   VRML (Virtual Reality Modeling Language) (output only).
##      ".xgl"   XML/OpenGL format (output only);
##  
##    Current limits include:
##      200000 faces.
##      100000 line items.
##      200000 points.
##      10 face order.
##      100 materials.
##      100 textures.
##  
##    Last modification: 04 September 2003.
##
#######################################################################
## Script
## Started: 2011jan11
## Changed: 2011may23 Put '.ivcon_2004.exe' in the feNautilusScripts 3Dtools dir.
## Changed: 2012apr18 Changed script name in comments above and touched up
##                    the comments. Changed some indenting below.
## Changed: 2012dec18 Fixed directory - put'.ivcon_2004.exe' in the
##                    feNautilusScripts zMORE/3Dtools dir.
## Changed: 2013feb24 Added a 'zenity --info' popup to provide usage
##                    info on IVCON.
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
## A zenity 'info' window(s) to show IVCON usage info.
###########################################################

zenity --info --title "IVCON Usage Info, Page 2" \
   --no-wrap \
   --text  "\
IVCON Usage Info (page 2 of 2):

OUTPUT ONLY:

   '.pov'   Persistence of Vision (output only)
   '.tec'   TECPLOT (output only)
   '.txt'   Text (output only)
   '.ucd'   AVS UCD file (output only)
   '.wrl'   VRML (Virtual Reality Modeling Language) (output only).
            NOTE: This is the VRML2 (a.k.a. VRML97) format which
            is not compatible with the VRML1 format. That is, the
            VRML1 spec is not a subset of the VRML2 spec.
   '.xgl'   XML/OpenGL format (output only)

 Current limits include:
   200,000 faces, 200,000 points, 100,000 line items.
   100 materials, 100 textures, 10 face order.
  
 Last modification of IVCON: 04 September 2003
 Reference: http://people.sc.fsu.edu/~jburkardt/
" &

zenity --info --title "IVCON Usage Info, Page 1" \
   --no-wrap \
   --text  "\
IVCON Usage Info (page 1 of 2):

This script tries to put the output file in the same directory
as the input file.

IVCON is a compiled C++ program useful for 3D graphics file conversion.

The following file types can be used for input, and (unless otherwise
indicated) can be used for output.

   '.3ds'   3D Studio Max binary
   '.ase'   3D Studio Max ASCII export
   '.byu'   Movie.BYU surface geometry
   '.dxf'   DXF
   '.gmod'  Golgotha model
   '.hrc'   SoftImage hierarchy
   '.iv'    SGI Open Inventor
            NOTE: VRML1 is a subset of Inventor. If you edit
                  a VRML1 file and change its header from
                  '#VRML' to '#Inventor', IVCON may be able to
                  convert the VRML1 file to '.obj', '.off', etc.
   '.obj'   WaveFront Advanced Visualizer
   '.off'   GEOMVIEW Object File Format
   '.smf'   Michael Garland's format
   '.stl'   ASCII StereoLithography
   '.stla'  ASCII StereoLithography
   '.stlb'  Binary StereoLithography
   '.tri'   [Greg Hood ASCII triangle format]
   '.tria'  [Greg Hood ASCII triangle format]
   '.trib'  [Greg Hood binary triangle format]
   '.vla'   VLA

NOTE: Among these formats, '.3ds', '.dxf', '.iv', VRML1, '.obj',
'.off', and '.stl'/'.stla' are relatively commonly found
formats. This script utility is mainly meant to support
conversions among these formats." &


## Give the user a second or two to start reading the info.
sleep 2


#############################################################################
## Prompt for the 'TO' format of the new 3D file.
##
## Examples: 3ds, dxf, iv, obj, off, pov, stl, stlb, wrl
#############################################################################

NEWFMT=""

NEWFMT=$(zenity --entry \
   --title "SUFFIX (FORMAT) of the new 3D file." \
   --text "\
Enter an indicator of the suffix (format) of the new, output.
3D file. Main Output Options: 3ds, dxf, iv, obj, off, pov, stl, stlb, wrl" \
   --entry-text "obj")

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
## Use 'ivcon' to make the new 3D file.
###################################################################

. $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi

## FOR TEST: (show statements as they execute)
#   set -x

xterm -hold -fg white -bg black \
      -geometry 80x30+25+25   -e \
      $DIR_NautilusScripts/zMORE/3Dtools/.ivcon_2004.exe "$FILENAME" "$FILEOUT"

## FOR TEST: (turn off display of statements)
#   set -


##################################
## Show the new 3D file.
##################################

if test ! -f "$FILEOUT"
then
   exit
fi

if test "$NEWFMT" = "3ds"
then
   glc_player "$FILEOUT"
fi

if test "$NEWFMT" = "dxf"
then

   zenity --info \
          --title "No DXF Viewer." \
          --text "\
We do not have a DXF Viewer at this time.
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
We do not try to start an OFF Viewer at this time.
You could try converting the OFF file to another format
--- say with the 'ivcon' program --- and view that file."

fi

if test "$NEWFMT" = "stl"
then
   glc_player "$FILEOUT"
fi

if test "$NEWFMT" = "vrml"
then
  ivview "$FILEOUT"
fi

if test "$NEWFMT" = "wrl"
then
   whitedune "$FILEOUT"
fi
