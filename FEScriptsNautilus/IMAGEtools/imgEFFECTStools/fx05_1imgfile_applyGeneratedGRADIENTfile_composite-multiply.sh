#!/bin/sh
##
## NAUTILUS
## SCRIPT: 05_1imgfile_applyGeneratedGRADIENTfile_composite-multiply.sh
##
## PURPOSE: For a selected image file --- '.jpg', '.png', '.gif' or whatever,
##          offers the user a choice of gray-scale gradient types to 'apply'
##          to the image file in a '-compose Multiply' operation with the
##          ImageMagick 'composite' command.
##
## METHOD:  The gray-scale gradient files is generated via a 
##          'convert -size ... gradient: ...' command, using the size of
##          the selected mage file.
##
##          The main steps of this script:
##
##          1. Uses ImageMagick 'identify' to get the width-height (in pixels)
##             of the selected image file.
##
##          2. Uses 'zenity' to prompt the user for the gradient TYPE to use
##             --- radial, linear (various types of linear), etc.
##
##          3. Uses a 'convert -size ... gradient: ...' command to generate
##             a temporary gradient file, in /tmp, of the same size (pixel
##             width-height) as the selected image file.
##
##          4. Uses ImageMagick 'composite' with '-compose Multiply' to merge
##             the temporary gradient file with the image file.
##
##          This script makes the output image file of the same type (suffix)
##          as the selected input image file.
##
##          This script shows the new image file in an image viewer of the
##          user's choice.
##
## References: http://www.imagemagick.org/Usage/canvas/#gradient
##             http://www.imagemagick.org/Usage/compose/#multiply
##
## Quote on 'Multiply' (paraphrased): 
##     "Multiply (make white transparent) is one of the more useful, but
##      under-rated, compose methods ...
##
##      If one of the images is pure white, the result will be the other
##      image. On the other hand, if one image is black, the result
##      will be black. Between these extremes one image will darken
##      the destination image by the amount given.
##
##      Note that 'Multiply' will only darken an image, it will never
##      brighten it. That is, it 'attenuates' an image toward black, which
##      makes this compose method a 'Burn' or 'Char' style of composition.
##
##      This method works very well in a lot of situations, but is
##      especially good when one of the images has black (or greyscale)
##      lines on a mostly white background, such as text images.
##
##      If both images contain regions of color, then you may get unusual
##      results.
##
##      This technique is perfect for overlaying images with black-on-white text
##      or with diagrams --- line drawings with a white or very light colored
##      background.
##
##      Given a grey scale image mask, multiply is a good way to erase
##      parts of an image to black based on the grayscale mask. It does this
##      linearly, so the mask can be a greyscale image rather than a
##      purely Boolean on/off image."
##
##
## HOW TO USE: In Nautilus, select an image file.
##             Then right-click and choose this script to run (name above).
##
###########################################################################
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
   --title "GRADIENT TYPE?" \
   --height 400 \
   --text "\
Choose a gradient type to apply to the selected image file:
   $FILENAME

(This will generate a temporary gradient file, in /tmp.)

CW = CenterWhite gradient ; TB = TopBottom gradient ;
LR = LeftRight gradient" \
   --column "" --column "GradientType" \
      TRUE  gradientCW_radial_whiteCenter_blackOuter \
      FALSE gradientCW_rectangle_whiteCenter_blackOuter \
      FALSE gradientTB_whiteCenter_blackTopAndBottom \
      FALSE gradientTB_whiteTop_blackBottom \
      FALSE gradientTB_whiteBottom_blackTop \
      FALSE gradientLR_whiteCenter_blackLeftANDright \
      FALSE gradientTB_4ripplesBlackWhite_TopDown \
      FALSE gradientTB_swirl_whiteTop_blackBottom`

if test "$GRADIENT_TYPE" = ""
then
   exit
fi

# if test "$GRADIENT_TYPE" = "gradientCW_radial_whiteCenter_blackOuter"
# then
   GRADIENT_PARM="radial-gradient:"
# fi

if test "$GRADIENT_TYPE" = "gradientCW_rectangle_whiteCenter_blackOuter"
then
   GRADIENT_PARM="xc: -channel G -fx '(1-(2*i/w-1)^4)*(1-(2*j/h-1)^4)' -separate"
   ## REFERENCE: http://www.imagemagick.org/Usage/canvas/#gradient_fx
fi

if test "$GRADIENT_TYPE" = "gradientTB_whiteCenter_blackTopAndBottom"
then
   GRADIENT_PARM="gradient: -function Polynomial -4,4,0"
fi

if test "$GRADIENT_TYPE" = "gradientTB_whiteTop_blackBottom"
then
   GRADIENT_PARM="gradient:"
   # GRADIENT_PARM="gradient: -sigmoidal-contrast 6,50%"
   # GRADIENT_PARM="gradient: -evaluate cos 0.5 -negate"
fi

if test "$GRADIENT_TYPE" = "gradientTB_whiteBottom_blackTop"
then
   GRADIENT_PARM="gradient: -rotate 180"
fi


if test "$GRADIENT_TYPE" = "gradientLR_whiteCenter_blackLeftANDright"
then
   GRADIENT_PARM="gradient: -function Polynomial -4,4,0 -rotate 90"
   XSIZE=`echo $FILESIZE | cut -dx -f1`
   YSIZE=`echo $FILESIZE | cut -dx -f2`
   FILESIZE="${YSIZE}x$XSIZE"
fi

if test "$GRADIENT_TYPE" = "gradientTB_4ripplesBlackWhite_TopDown"
then
   GRADIENT_PARM="gradient: -function sinusoid 4,-90"
fi

if test "$GRADIENT_TYPE" = "gradientTB_swirl_whiteTop_blackBottom"
then
   GRADIENT_PARM="gradient: -swirl 180"
fi


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

eval convert -size $FILESIZE  $GRADIENT_PARM  "$TEMPGRADIENTFILE"


##################################################################
## Make full filename for the output file --- using the
## name of the selected image file.
##
## If the user has write-permission on the
## current directory, put the file in the pwd.
## Otherwise, put the file in /tmp.
##################################################################

CURDIR="`pwd`"

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
## Call 'composite' with the gradient and image filenames
## passed on the command line.
########################################################

composite -compose Multiply  "$TEMPGRADIENTFILE" "$FILENAME" "$OUTFILE"

# composite -compose Multiply -gravity Center \
#          "$TEMPGRADIENTFILE"  "$FILENAME" -alpha Set "$OUTFILE"


##########################
## Show the new image file.
##########################

## . $HOME/.gnome2/nautilus-scripts/.set_VIEWERvars.shi

 . $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
 . $DIR_NautilusScripts/.set_VIEWERvars.shi

$IMGVIEWER "$OUTFILE" &

# $IMGEDITOR "$OUTFILE" &
