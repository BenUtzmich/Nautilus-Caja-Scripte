#!/bin/sh
##
## NAUTILUS
## SCRIPT: fx04_1imgfile_applyGRADIENTlibfile_composite-multiply.sh
##
## PURPOSE: For a selected image file --- '.jpg', '.png', '.gif' or whatever,
##          offers the user a choice of gray-scale gradient files to 'apply'
##          to the image file in a '-compose Multiply' operation with the
##          ImageMagick 'composite' command.
##
## METHOD:  The gray-scale gradient files are in a '.gradients' subdirectory
##          of the directory in which this script lies.
##
##          The main steps of this script:
##
##          1. Uses ImageMagick 'identify' to get the width-height (in pixels)
##             of the selected image file.
##
##          2. Uses 'zenity' to prompt the user for the gradient file to use
##             --- radial, linear (various types of linear), etc.
##
##          3. Uses ImageMagick 'convert' with '-resize' to make a temporary
##             grayscale gradient file, in /tmp, of the same size as the
##             selected image file.
##
##          4. Uses ImageMagick 'composite' with '-compose Multiply' to merge
##             the re-sized temporary gradient file with the image file.
##
##          This script makes the output image file of the same type (suffix)
##          as the selected input image file.
##
##          This script shows the new image file in an image viewer of the
##          user's choice.
##
## Reference: http://www.imagemagick.org/Usage/compose/#multiply
##
## Quote (paraphrased): 
##     "Multiply (make white transparent) is one of the more useful, but
##      under-rated, compose methods ...
##
##      If one of the images is pure white, the result will be the other
##      image. On the other hand, if one image is black, the result
##      will be black. Between these extremes one image will darken
##      the destination image by the amount given.
##
##      Note that 'Multiply' will only darken an image, it will neve
##      brighten it. That is, it 'attenuates' an image toward black, which
##      makes this compose method a 'Burn' or 'Char' style of composition.
##
##      This method works very well in a lot of situations, but is
##      especially good when one of the images images has black (or greyscale)
##      lines on a mostly white background, such as text images.
##
##      If both images contain regions of color, then you may get unusual
##      results.
##
##      This technique is perfect for overlaying images with black-on-white text
##      or with diagrams --- line drawings with a white or very light colored
##      background.
##
##      Given two grey scale image masks, multiply is also a good way to 
##      erase parts of an image to black based on some mask. It does this
##      linearly, so the mask can be a greyscale image rather than a
##      purely Boolean on/off image."
##
##
## HOW TO USE: In Nautilus, select an image file.
##             Then right-click and choose this script to run (name above).
##
############################################################################
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
## Get the file extension of the selected image file.
##     Assumes one period (.) in filename, at the extension.
####################################################################

FILEEXT=`echo "$FILENAME" | cut -d\. -f2`


####################################################################
## Check that the file extension is 'jpg' or 'png' or 'gif'.
##     Assumes one period (.) in filename, at the extension.
## COMMENTED, for now.
####################################################################
 
# if test "$FILEEXT" != "jpg" -a "$FILEEXT" != "png" -a "$FILEEXT" != "gif"
# then
#    exit
# fi


########################################################
## Strip off suffix --- like '.jpg' or '.gif' or '.png'.
##     Assumes one period (.) in filename, at the extension.
########################################################

FILEMIDNAME=`echo "$FILENAME" | sed 's|\..*$||'`


###########################
## Get filesize (XXXxYYY).
###########################

FILESIZE=`identify "$FILENAME" | head -1 | awk '{print $3}'`


#######################################################
## Prompt for the gradient type.
#######################################################

GRADIENT_TYPE=""

GRADIENT_TYPE=`zenity --list --radiolist \
   --title "GRADIENT-FILE TYPE?" \
   --height 400 \
   --text "\
Choose a gradient file-type to apply to the selected image file:
   $FILENAME

CW = CenterWhite gradient ; LR = LeftRight gradient ; TB = TopBottom gradient
" \
   --column "" --column "GradientFileType" \
      TRUE  gradientCW_radial_whiteCenter_blackOuter \
      FALSE gradientCW_rectangle_whiteCenter_black4OuterEdges \
      FALSE gradientLR_whiteAcrossCenter_blackLeftANDright \
      FALSE gradientLR_whiteLeft_blackRight \
      FALSE gradientLR_whiteRight_blackLeft \
      FALSE gradientTB_whiteAcrossCenter_blackTopANDbottom \
      FALSE gradientTB_whiteBottom_blackTop \
      FALSE gradientTB_whiteTop_blackBottom`

if test "$GRADIENT_TYPE" = ""
then
   exit
fi

# if test "$GRADIENT_TYPE" = "gradientCW_radial_whiteCenter_blackOuter"
# then
   GRADIENT_FILE="gradientCW_radial_whiteCenter_blackOuter_512x512.jpg"
# fi

if test "$GRADIENT_TYPE" = "gradientCW_rectangle_whiteCenter_black4OuterEdges"
then
   GRADIENT_FILE="gradientCW_rectangle_whiteCenter_black4OuterEdges_400x400.jpg"
fi

if test "$GRADIENT_TYPE" = "gradientLR_whiteAcrossCenter_blackLeftANDright"
then
   GRADIENT_FILE="gradientLR_whiteAcrossCenter_blackLeftANDright_512x512.jpg"
fi

if test "$GRADIENT_TYPE" = "gradientLR_whiteLeft_blackRight"
then
   GRADIENT_FILE="gradientLR_whiteLeft_blackRight_512x512.jpg"
fi

if test "$GRADIENT_TYPE" = "gradientLR_whiteRight_blackLeft"
then
   GRADIENT_FILE="gradientLR_whiteRight_blackLeft_512x512.jpg"
fi

if test "$GRADIENT_TYPE" = "gradientTB_whiteAcrossCenter_blackTopANDbottom"
then
   GRADIENT_FILE="gradientTB_whiteAcrossCenter_blackTopANDbottom_512x512.jpg"
fi

if test "$GRADIENT_TYPE" = "gradientTB_whiteBottom_blackTop"
then
   GRADIENT_FILE="gradientTB_whiteBottom_blackTop_512x512.jpg"
fi

if test "$GRADIENT_TYPE" = "gradientTB_whiteTop_blackBottom"
then
   GRADIENT_FILE="gradientTB_whiteTop_blackBottom_512x512.jpg"
fi

#######################################################
## Set the directory of the GRADIENT_FILE.
#######################################################

DIR_SCRIPT=`dirname $0`

DIR_GRADIENTFILE="${DIR_SCRIPT}/.gradients"


#######################################################
## Make a name for the temporary gradient file.
#######################################################

TEMPGRADIENTFILE="/tmp/${USER}_temp_GRADIENT.jpg"

if test -f "$TEMPGRADIENTFILE"
then
   rm -f  "$TEMPGRADIENTFILE"
fi


#######################################################
## Make the temporary gradient file.
#######################################################

convert -resize ${FILESIZE}\!  "${DIR_GRADIENTFILE}/$GRADIENT_FILE" \
        "$TEMPGRADIENTFILE"


##################################################################
## Make full filename for the output file --- using the
## name of the selected image file.
##
## If the user has write-permission on the
## current directory, put the file in the pwd.
## Otherwise, put the file in /tmp.
##################################################################

CURDIR="`pwd`"

# OUTFILE="${FILEMIDNAME}_multiplyByGRADIENTfile.$FILEEXT"
OUTFILE="${FILEMIDNAME}_multiplyBy_${GRADIENT_TYPE}.$FILEEXT"

if test ! -w "$CURDIR"
then
  OUTFILE="/tmp/$OUTFILE"
fi

if test -f "$OUTFILE"
then
  rm -f "$OUTFILE"
fi


########################################################
## Call 'composite' with the temp-gradient-filename and
## the selected image filename passed on the command line.
########################################################

composite -compose Multiply "$TEMPGRADIENTFILE"  "$FILENAME" "$OUTFILE"

# composite -compose Multiply -gravity Center \
#         "$TEMPGRADIENTFILE"  "$FILENAME" -alpha Set "$OUTFILE"


##########################
## Show the new image file.
##########################

## . $HOME/.gnome2/nautilus-scripts/.set_VIEWERvars.shi

. $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
. $DIR_NautilusScripts/.set_VIEWERvars.shi

$IMGVIEWER "$OUTFILE" &

# $IMGEDITOR "$OUTFILE" &
