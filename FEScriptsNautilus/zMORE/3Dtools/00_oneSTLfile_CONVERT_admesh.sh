#!/bin/sh
##
## Nautilus
## SCRIPT: 00_oneSTLfile_CONVERT_admesh.sh
##
## PURPOSE: Convert a 3D STL file (ascii or binary) to another format,
##          using the 'admesh' program (which is available via the
##          Synaptic package manager).
##
## METHOD:  Uses 'zenity' to prompt for the 'TO' file format
##          and extension, such as
##              stlb, stla, vrml, dxf, off
##
##          Shows the new converted file in an appropriate viewer:
##                - glc_player '.stl', '.stlb'
##                - varicad-view for dxf
##                - ivview for VRML1 files or whitedune for VRML2 files
##
##          Some info on installing these 3D viewers is available at
##   http://www.subdude-site.com/WebPages_Local/RefInfo/Computer/Linux/LinuxGuidesByBlaze/apps3Dtools/3D_viewers-converters/3DviewersANDconverters_intro.htm
##
## HOW TO USE: In Nautilus, navigate to a 3D STL file that you want to
##             convert, right-click the file, and select this
##             script to run from your menu of Nautilus scripts.
##
## HERE IS HELP from 'admesh':
##
## $ admesh --help
##  
##  ADMesh version 0.95
##  Copyright (C) 1995, 1996  Anthony D. Martin
##  Usage: admesh [OPTION]... file
##  
##       --x-rotate=angle     Rotate CCW about x-axis by angle degrees
##       --y-rotate=angle     Rotate CCW about y-axis by angle degrees
##       --z-rotate=angle     Rotate CCW about z-axis by angle degrees
##       --xy-mirror          Mirror about the xy plane
##       --yz-mirror          Mirror about the yz plane
##       --xz-mirror          Mirror about the xz plane
##       --scale=factor       Scale the file by factor (multiply by factor)
##       --translate=x,y,z    Translate the file to x, y, and z
##       --merge=name         Merge file called name with input file
##   -e, --exact              Only check for perfectly matched edges
##   -n, --nearby             Find and connect nearby facets. Correct bad facets
##   -t, --tolerance=tol      Initial tolerance to use for nearby check = tol
##   -i, --iterations=i       Number of iterations for nearby check = i
##   -m, --increment=inc      Amount to increment tolerance after iteration=inc
##   -u, --remove-unconnected Remove facets that have 0 neighbors
##   -f, --fill-holes         Add facets to fill holes
##   -d, --normal-directions  Check and fix direction of normals(ie cw, ccw)
##       --reverse-all        Reverse the directions of all facets and normals
##   -v, --normal-values      Check and fix normal values
##   -c, --no-check           Don't do any check on input file
##   -b, --write-binary-stl=name   Output a binary STL file called name
##   -a, --write-ascii-stl=name    Output an ascii STL file called name
##       --write-off=name     Output a Geomview OFF format file called name
##       --write-dxf=name     Output a DXF format file called name
##       --write-vrml=name    Output a VRML format file called name
##       --help               Display this help and exit
##       --version            Output version information and exit
##  
##  The functions are executed in the same order as the options shown here.
##  So check here to find what happens if, for example, --translate and --merge
##  options are specified together.  The order of the options specified on the
##  command line is not important.
##  
##  
########################################################################
## Script
## Started: 2011jan11
## Changed: 2011may23 Put '.admesh.exe' in the feNautilusScripts 3Dtools dir.
## Changed: 2012dec18 Put '.admesh.exe' in the feNautilusScripts 
##                    zMORE/3Dtools dir.
## Changed: 2013feb24 Added a 'zenity --info' popup to provide usage
##                    info on 'admesh'.
########################################################################

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
## A zenity 'info' window(s) to show 'admesh' usage info.
###########################################################

zenity --info --title "'admesh' Usage Info, Page 2" \
   --no-wrap \
   --text  "\
'admesh' Usage Info (page 2 of 2):

ADMesh supports the following options, grouped by type.

*Mesh Checking and Repairing Options*
 -e, --exact              Only check for perfectly matched edges
 -n, --nearby             Find and connect nearby facets. Correct bad facets
 -t, --tolerance=tol      Initial tolerance to use for nearby check = tol
 -i, --iterations=i       Number of iterations for nearby check = i
 -m, --increment=inc      Amount to increment tolerance after iteration=inc
 -u, --remove-unconnected Remove facets that have 0 neighbors
 -f, --fill-holes         Add facets to fill holes
 -d, --normal-directions  Check and fix direction of normals(ie cw, ccw)
     --reverse-all        Reverse the directions of all facets and normals
 -v, --normal-values      Check and fix normal values
 -c, --no-check           Don't do any check on input file

*Mesh Transformation and Manipulation Options*
     --x-rotate=angle     Rotate CCW about x-axis by angle degrees
     --y-rotate=angle     Rotate CCW about y-axis by angle degrees
     --z-rotate=angle     Rotate CCW about z-axis by angle degrees
     --xy-mirror          Mirror about the xy plane
     --yz-mirror          Mirror about the yz plane
     --xz-mirror          Mirror about the xz plane
     --scale=factor       Scale the file by factor (multiply by factor)
     --translate=x,y,z    Translate the file to x, y, and z
     --merge=name         Merge file called name with input file

*File Output Options*
 -b, --write-binary-stl=name   Output a binary STL file called name
 -a, --write-ascii-stl=name    Output an ascii STL file called name
     --write-off=name     Output a Geomview OFF format file called name
     --write-dxf=name     Output a DXF format file called name
     --write-vrml=name    Output a VRML format file called name

This script is meant to implement the 'write' options." &

## Assure that page 1 covers page 2 of this info.
sleep 1

zenity --info --title "'admesh' Usage Info, Page 1" \
   --no-wrap \
   --text  "\
'admesh' Usage Info (page 1 of 2):

This script is intended to use the 'admesh' program to convert
an STL (stereolithography) file --- ASCII or binary --- to a
different format: STLB (STL binary), STLA (STL ASCII), VRML1,
DXF, or OFF.

This script tries to put the output file in the same directory
as the input file.

Following is some info on the ADMESH program by Anthony D. Martin.

ADMesh is a program for processing triangulated solid meshes. ADMesh
only reads the STL file format that is used for rapid prototyping
applications, although it can write STL, VRML, OFF, and DXF files.

By default, ADMesh performs all of the mesh-checking and repairing-options
on the input file.  This means that it does the following kinds of checks:
'exact', 'nearby', 'remove-unconnected', 'fill-holes', 'normal-directions',
and 'normal-values'.

The file type (ASCII or binary) is automatically detected.

The default value for tolerance is the length of the shortest edge of the
mesh.  The default number of iterations is 2, and the default increment is
0.01% of the diameter of a sphere that encloses the entire mesh.

For command-line options of ADMesh, besides the following 2 basic
options, see page 2
     --help               Display options help and exit
     --version            Output version information and exit.
" &


## Give the user a second or two to start reading the info.
sleep 2


#############################################################################
## Prompt for the 'TO' format of the new 3D file.
##
## Examples: stlb, stla, vrml, dxf, off
#############################################################################

NEWFMT=""

NEWFMT=$(zenity --entry \
   --title "SUFFIX (FORMAT) of the new 3D file." \
   --text "\
Enter an indicator of the suffix (format) of the new, output
3D file. Main Output Options: stlb, stla, vrml, dxf, off" \
   --entry-text "off")

if test "$NEWFMT" = ""
then
   exit
fi


###############################
## Prepare the output filename.
###############################

FILENAMECROP=`echo "$FILENAME" | cut -d\. -f1`

FILEOUT="${FILENAMECROP}_NEW.$NEWFMT"

if test -f "$FILEOUT"
then
   rm -f "$FILEOUT"
fi


####################################################
## Prepare the output option indicator for 'admesh'.
####################################################

if test "$NEWFMT" = "stlb"
then
   OUTOPT="--write-binary-stl="
fi

if test "$NEWFMT" = "stlb"
then
   OUTOPT="--write-ascii-stl="
fi

if test "$NEWFMT" = "vrml"
then
   OUTOPT="--write-vrml="
fi

if test "$NEWFMT" = "dxf"
then
   OUTOPT="--write-dxf="
fi

if test "$NEWFMT" = "off"
then
   OUTOPT="--write-off="
fi


###################################################################
## Use 'admesh' to make the new 3D file.
###################################################################

. $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi

## FOR TEST: (show statements as they execute)
#   set -x

xterm -hold -fg white -bg black -geometry 80x30+25+25  -e \
   $DIR_NautilusScripts/zMORE/3Dtools/.admesh.exe $OUTOPT"$FILEOUT" "$FILENAME"

## FOR TEST: (turn off display of statements)
#   set -


##################################
## Show the new 3D file.
##################################

if test ! -f "$FILEOUT"
then
   exit
fi

if test "$NEWFMT" = "stlb"
then
   glc_player "$FILEOUT"
fi

if test "$NEWFMT" = "stla"
then
   glc_player "$FILEOUT"
fi

if test "$NEWFMT" = "dxf"
then
   ## NOTE: 'varicad-view' seems to work on 2D DXF files,
   ##       BUT NOT on 3D DXF files.
   varicad-view "$FILEOUT"
fi

if test "$NEWFMT" = "vrml"
then
   ivview "$FILEOUT"
#  whitedune "$FILEOUT"
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
