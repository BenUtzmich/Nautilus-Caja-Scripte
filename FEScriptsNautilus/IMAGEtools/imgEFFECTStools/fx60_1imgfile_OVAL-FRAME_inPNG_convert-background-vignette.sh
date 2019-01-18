#!/bin/sh
##
## NAUTILUS
## SCRIPT: fx60_1imgfile_OVAL-FRAME_inPNG_convert-background-vignette.sh
##
## PURPOSE: Makes a 'vignette' image file from a selected image file.
##          That is, it makes a more or less blurred OVAL of the
##          image file --- with a colored or transparent background.
##
## METHOD:  Uses 'zenity --entry' to prompt the user for
##          the '-background'  color (or transparent) parameter.
##
##          Uses 'zenity --entry' to prompt the user for
##          the vignette parameter --- {radius}x{fuzziness}.
##
##          Uses ImageMagick 'convert' with the '-background' and
##          '-vignette' options.
##
##          This script shows the new image file in an image viewer (or editor)
##          of the user's choice.
##
## References: http://www.imagemagick.org/Usage/transform/#vignette
##             http://www.imagemagick.org/Usage/thumbnails/#soft_edges
##
## HOW TO USE: In Nautilus, select an image file.
##             Then right-click and choose this script to run (name above).
##
#############################################################################
## Created: 2012jan23
## Changed: 2012may14 Touched up the comments above. Changed some indenting below.
###########################################################################


## FOR TESTING: (show statements as they execute)
#  set -x

########################################
## Get the filename of the selected file.
########################################

   FILENAME="$1"
#  FILENAMES="$NAUTILUS_SCRIPT_SELECTED_URIS"
#  FILENAMES="$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS"


####################################################################
## Get the file extension.
##     Assumes one period (.) in filename, at the extension.
##  COMMENTED, for now.
####################################################################

# FILEEXT=`echo "$FILENAME" | cut -d\. -f2`


####################################################################
## Check that the file extension is 'jpg' or 'png' or 'gif'.
##     Assumes one period (.) in filename, at the extension.
## COMMENTED, for now.
####################################################################
 
# if test "$FILEEXT" != "jpg" -a "$FILEEXT" != "png" -a "$FILEEXT" != "gif"
# then
#    exit
# fi


##########################################################
## Get the 'midname' of the input file, to use to name the
## new output file.
##     Assumes just one period (.) in the filename,
##     at the suffix.
######################################################

FILEMIDNAME=`echo "$FILENAME" | cut -d'.' -f1`


#######################################################
## Prompt for the '-background' parameter.
#######################################################

BKGNDPARM=""

BKGNDPARM=$(zenity --entry \
   --title "Enter the BACKGROUND color/transparent parameter." \
   --text "\
Enter a BACKGROUND parameter --- a color or the word 'none', for a
transparent background.

Examples:
#000000  OR  black  OR  rgb(0,0,0)
#ffffff  OR  white  OR  rgb(255,255,255)
#0000ff  OR  blue   OR  rgb(0,0,255)
none (= transparent)" \
   --entry-text "none")

if test "$BKGNDPARM" = ""
then
   exit
fi

if test "$BKGNDPARM" = "none"
then
   BKGNDSTRING="-alpha set -background none"
   # BKGNDSTRING="-matte -background none"
else 
   BKGNDSTRING="-background $BKGNDPARM"
fi



#######################################################
## Prompt for the '-vignette' parameter.
#######################################################

VIGNETTEPARM=""

VIGNETTEPARM=$(zenity --entry \
   --title "Enter the VIGNETTE parameter." \
   --text "\
Enter a VIGNETTE parameter --- {radius}x{fuzziness}.

Examples:

0x5   - for a soft-edged oval
0x0   - for a hard-edged oval
5x65000 - for a linear, rather than gaussian, blur of the oval" \
   --entry-text "0x3")

if test "$VIGNETTEPARM" = ""
then
   exit
fi



##################################################################
## Make full filename for the output file --- using the
## name of the input file.
##
## If the user has write-permission on the
## current directory, put the file in the pwd.
## Otherwise, put the file in /tmp.
##################################################################

CURDIR="`pwd`"

OUTFILE="${FILEMIDNAME}_OVAL${VIGNETTEPARM}_BKGND${BKGNDPARM}.png"

if test ! -w "$CURDIR"
then
   OUTFILE="/tmp/$OUTFILE"
fi

if test -f "$OUTFILE"
then
   rm -f "$OUTFILE"
fi


###########################################
## Use 'convert' to make the new image file.
###########################################

## FOR TESTING: (show statements as they execute)
#      set -x

convert "$FILENAME" $BKGNDSTRING \
        -vignette $VIGNETTEPARM  "$OUTFILE"

## FOR TESTING: (turn off display of statements)
#      set -


##########################
## Show the new image file.
##########################

## . $HOME/.gnome2/nautilus-scripts/.set_VIEWERvars.shi

. $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
. $DIR_NautilusScripts/.set_VIEWERvars.shi

$IMGVIEWER "$OUTFILE" &

# $IMGEDITOR "$OUTFILE" &
