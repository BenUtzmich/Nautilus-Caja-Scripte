#!/bin/sh
##
## Nautilus
## SCRIPT: tile02_1-jpgORpngORgif-file_MAKEpreSmudgeTILE_via4quads_convert-5times.sh
##
## PURPOSE: Quarters a selected image file ('.jpg' or '.png' or '.gif')
##          and rearranges the quarters into a file suitable for
##          'smudging' the new internal boundaries to make a 'seamless tile'
##          file.
##
## METHOD:  There is no prompt for a parameter.
##
##          Uses ImageMagick 'convert' 4 times with '-crop' and '+repage'
##          options --- to make the 4 quadrants.
##
##          Then uses 'convert' with '+append' and '-append' to put the
##          4 quadrants back together in a different configuration.
##
##          NOTE: The boundaries (perimeter) of the initial image file must be
##                suitable to smudging into each other without
##                distracting patterns or edges showing up.
##
##          Shows the new image file in an image viewer (or editor) of
##          the user's choice.
##
## References:
##     For using 'convert' with '-crop' to make four quadrant files,
##     SEE  http://www.imagemagick.org/Usage/crop/#crop_repage
##
##     For using 'convert' with 'append' to make the 'pre-tile' file from
##     the four quadrant files,
##     SEE http://www.imagemagick.org/Usage/layers/#append
##
## HOW TO USE: In Nautilus, select an image file.
##             Then right-click and choose this script to run (name above).
##
##############################################################################
## Created: 2010mar18
## Changed: 2011may11 Get 'nautilus-scripts' directory via an include script.
## Changed: 2012feb02 Changed the name of the script.
## Changed: 2012may14 Changed script name in comments above and touched up
##                    the comments. Changed some indenting below.
###########################################################################

## FOR TESTING: (show statements as they execute)
#  set -x

#########################################
## Get the filename of the selected file.
#########################################

   FILENAME="$1"
#  FILENAMES="$NAUTILUS_SCRIPT_SELECTED_URIS"
#  FILENAMES="$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS"


####################################################################
## Get and check that the file extension is 'jpg' or 'png' or 'gif'.
## Assumes one period (.) in filename, at the extension.
####################################################################

FILEEXT=`echo "$FILENAME" | cut -d\. -f2`
 
if test "$FILEEXT" != "jpg" -a "$FILEEXT" != "png" -a "$FILEEXT" != "gif"
then
   continue
   # exit
fi


#############################################################################
## Use the FILENAME to get the 'stub' to use to name the new 'pre-tile' file.
#############################################################################

#  FILENAMECROP=`echo "$FILENAME" | sed 's|\..*$||'`
   FILENAMECROP=`echo "$FILENAME" | cut -d\. -f1`


###########################################
## Get the filesize, x and y, in pixels.
###########################################

SIZEXY=`identify "$FILENAME" | head -1 | awk '{print $3}'`
SIZEX=`echo "$SIZEXY" | cut -dx -f1`
SIZEY=`echo "$SIZEXY" | cut -dx -f2`


################################################################
## Set variables for leftwidth rightwidth topheight bottomheight
## of the quadrants.
################################################################

X1=`expr $SIZEX / 2`
X2=`expr $SIZEX - $X1`
Y1=`expr $SIZEY / 2`
Y2=`expr $SIZEY - $Y1`


############################################################
## Use 'convert' with '-crop' to make four quadrant files.
## SEE: http://www.imagemagick.org/Usage/crop/#crop_repage
############################################################

convert "$FILENAME" -crop ${X1}x${Y1}+0+0 +repage ${FILENAMECROP}_0.$FILEEXT
convert "$FILENAME" -crop ${X2}x${Y1}+${X1}+0 +repage ${FILENAMECROP}_1.$FILEEXT
convert "$FILENAME" -crop ${X1}x${Y2}+0+$Y1 +repage ${FILENAMECROP}_2.$FILEEXT
convert "$FILENAME" -crop ${X2}x${Y2}+${X1}+$Y1 +repage ${FILENAMECROP}_3.$FILEEXT

## The 4 output filenames are of the form:
##     name_0.$FILEEXT for top-left quad
##     name_1.$FILEEXT for top-right quad
##     name_2.$FILEEXT for bottom-left quad
##     name_3.$FILEEXT for bottom-right quad


##################################################################
## Use 'convert' with 'append' to make the 'pre-tile' file from 
## the four quadrant files.
## SEE: http://www.imagemagick.org/Usage/layers/#append
##
## NOTE: +append appends vertically, -append appends horizontally.
##################################################################

FILEOUT="${FILENAMECROP}_preSmudgeTile.$FILEEXT"

convert \( ${FILENAMECROP}_3.$FILEEXT ${FILENAMECROP}_2.$FILEEXT  +append \) \
        \( ${FILENAMECROP}_1.$FILEEXT ${FILENAMECROP}_0.$FILEEXT  +append \) \
             -background none -append   "$FILEOUT"


#######################################################
## Show the output file. (4 quadrants merged into one)
#######################################################

## . $HOME/.gnome2/nautilus-scripts/.set_VIEWERvars.shi

. $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
. $DIR_NautilusScripts/.set_VIEWERvars.shi

# $IMGVIEWER "$FILEOUT" &

$IMGEDITOR "$FILEOUT" &
