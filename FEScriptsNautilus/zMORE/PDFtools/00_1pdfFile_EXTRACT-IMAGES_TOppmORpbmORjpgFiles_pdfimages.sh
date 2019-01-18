#!/bin/sh
##
## Nautilus
## SCRIPT: 00_1pdfFile_EXTRACT-IMAGES_TOppmORpbmORjpg_pdfimages.sh
##
## PURPOSE: Runs the 'pdfimages' command to extract images from
##          a user-selected PDF file.
##
## METHOD:  The user is put in view mode on the first image file, using
##          an image viewer of the user's choice.
##
## HOW TO USE: In Nautilus, navigate to a PDF file, select it,
##             right-click and choose this Nautilus script to run.
##
## WARNING: If the PDF file images are composed of small 'chunks',
##          'pdfimages' may generate several hundred image files.
##          If that proves to be a problem often, we can make a
##          temporary directory in which to put the images ---
##          so that we do not junk-up the current directory.
##
##########################################################################
## Created: 2010may12
## Changed: 2011may02 Added $USER to a temp filename.
## Changed: 2012may11 Changed script name in comments above and touched up
##                    the comments. Changed some indenting below.
##########################################################################

## FOR TESTING: (show statements as they execute)
#  set -x

#######################################
## Get the filename.
#######################################

#  FILENAMES="$NAUTILUS_SCRIPT_SELECTED_URIS"
#  FILENAMES="$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS"

# FILENAME="$@"
FILENAME="$1"

#  CURDIR="$NAUTILUS_SCRIPT_CURRENT_URI"
CURDIR="`pwd`"


#######################################################
## Check that the selected file is a PDF file.
#######################################################

FILECHECK=`file "$FILENAME" | grep 'PDF'`
 
if test "$FILECHECK" = ""
then
   exit
fi


##########################################
## Initialize the directory for the output
## image files.
##
## If the user has write-permission on the
## current directory, put the directory
## in the pwd.
## Otherwise, put the directory in /tmp.
##########################################

# OUTDIR="${USER}_temp_pdf_images_dir"
# if test ! -w "$CURDIR"
# then
#   OUTDIR="/tmp/$OUTDIR"
# fi

# if test ! -f "$OUTDIR"
# then
#    mkdir "$OUTDIR"
# fi


###########################################
## Extract the images from the PDF file.
###########################################

EXECHECK=`which pdfimages`

if test -f "$EXECHECK"
then
   IMAGE_ROOT="${USER}_temp_pdf_image"
   pdfimages "$FILENAME" "$IMAGE_ROOT"
else
   zenity --info \
   --title "'pdfimages' not found. EXITING." \
   --text "\
It appears that the executable
'pdfimages' is not installed.

Exiting."
   exit
fi


#################################################
## Show the first image file with an image viewer.
#################################################

## . $HOME/.gnome2/nautilus-scripts/.set_VIEWERvars.shi

. $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
. $DIR_NautilusScripts/.set_VIEWERvars.shi

# $IMGVIEWER  "$CURDIR/${IMAGE_ROOT}-000.*" &
## NOTE:
## mtpaint cannot open a '.ppm' file (2010).

   eval eog   "$CURDIR/${IMAGE_ROOT}-000.*" &

#  eval mirage  "$CURDIR/${IMAGE_ROOT}-000.*" &
