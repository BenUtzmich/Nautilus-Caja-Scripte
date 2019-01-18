#!/bin/sh
##
## NAUTILUS
## SCRIPT: fx70_3imgfiles_toCUBE_inPNG_convert-shear-3-times.sh
##
## PURPOSE: For 3 selected image files (JPEG, PNG, GIF, whatever) makes 
##          cube with each of the 3 images on sides of the cube.
##
## METHOD:  Uses 'zenity --entry' to prompt the user for a size factor
##          (percent) that determines the size of the cube image.
##
##          Uses a transparent background color for the perimeter of the cube,
##          but we COULD use 'zenity --entry' to prompt for a color
##          to use to fill in the background on the perimeter of the cube.
##
##          Uses 'convert' with '-resize' to re-size the 3 images
##          to squares, before they are 'sheared' to put them on the cube.
##          (Best to start with 3 square or nearly-square images.)
##          (We use 256x256 for now, but could prompt for the size if we
##           ever make final cubes that are much larger than 500 pixels high.)
##
##          Uses ImageMagick 'convert' with the '-shear' option (and other
##          options), 3 times --- to make the 3 sheared faces of the cube.
##
##          Uses ImageMagick 'convert' with '+append' and '-layer' and
##          '-repage' options to make the final cube image.
##
##          Shows the new image file in an image viewer (or editor)
##          of the user's choice.
##
## Reference: http://www.imagemagick.org/Usage/warping/#sheared_cube
##
## HOW TO USE: In Nautilus, select 3 image files.
##             Then right-click and choose this script to run (name above).
##
#############################################################################
## Created: 2012feb01
## Changed: 2012feb09 Add a prompt for a SIZE_FACTOR. Also, make the six temp
##                    files in the /tmp directory, instead of in the curdir.
## Changed: 2012may14 Touched up the comments above. Changed some indenting below.
###########################################################################

## FOR TESTING: (show statements as they execute)
#  set -x

#############################################
## Get the filenames of the 3 selected files.
#############################################

FILENAME1="$1"
FILENAME2="$2"
FILENAME3="$3"


######################################################
## If less than 3 files are selected, pop an error msg
## and exit.
######################################################

if test "$FILENAME2" = "" -o "$FILENAME3" = ""
then
   zenity --info --title "Not enough files selected.  EXITING." \
           --text "\
Less than 3 files were selected.
FILE1: $FILENAME1
FILE2: $FILENAME2
FILE3: $FILENAME3

EXITING.
"
   exit
fi


#########################################################################
## Get the file extensions of the 3 input files, to make output filenames.
##     Assumes one period (.) in filename, at the extension.
#########################################################################

FILE1EXT=`echo "$FILENAME1" | cut -d\. -f2`
FILE2EXT=`echo "$FILENAME2" | cut -d\. -f2`
FILE3EXT=`echo "$FILENAME3" | cut -d\. -f2`


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
## new output file(s).
##     Assumes just one period (.) in the filename,
##     at the suffix.
######################################################

FILE1MIDNAME=`echo "$FILENAME1" | cut -d'.' -f1`
FILE2MIDNAME=`echo "$FILENAME2" | cut -d'.' -f1`
FILE3MIDNAME=`echo "$FILENAME3" | cut -d'.' -f1`


###############################################################
## Prompt for the PIXELS, to resize the 3 input files.
##    DEACTIVATED for now.
##    (We use 256, for now, like in the example at reference:
##     http://www.imagemagick.org/Usage/warping/#sheared_cube
##     It might be good to automatically set PIXELS according to
##     the average or max or min size of the 3 selected images.)
###############################################################

if test 1 = 0
then

PIXELS=""

PIXELS=$(zenity --entry \
   --title "Enter PIXELS." \
   --text "\
Enter NUMBER OF PIXELS to resize the 3 input files.

NOTE: This will determine the width and height of the square to which
each of the 3 images are re-sized." \
   --entry-text "512")

if test "$PIXELS" = ""
then
   exit
fi

fi
## END OF  if test 1 = 0



#######################################################
## Prompt for a size factor for the final 'cube' output.
#######################################################

SIZE_FACTOR=""

SIZE_FACTOR=$(zenity --entry \
   --title "SIZE FACTOR for the final 'cube'." \
   --text "\
Enter a size factor for the final 'cube' output.
Examples: 33   OR   50   OR   100
NOTE:
 100 gives a final 'cube' image height of about 600 pixels,
   50 gives a final 'cube' image height of about 300 pixels,
   33 gives a final 'cube' image height of about 200 pixels." \
   --entry-text "50")

if test "$SIZE_FACTOR" = ""
then
   exit
fi


##############################################################
## Resize the 3 input files to 256x256 JPEGs, using 'convert'.
##############################################################

FILETOP="/tmp/top.jpg"
FILELEFT="/tmp/left.jpg"
FILERIGHT="/tmp/right.jpg"

if test -f "$FILETOP"
then
  rm -f "$FILETOP"
fi

if test -f "$FILELEFT"
then
  rm -f "$FILELEFT"
fi

if test -f "$FILERIGHT"
then
  rm -f "$FILERIGHT"
fi

convert  "$FILENAME1" -resize 256x256 "$FILETOP"
convert  "$FILENAME2" -resize 256x256 "$FILELEFT"
convert  "$FILENAME3" -resize 256x256 "$FILERIGHT"


##################################################################
## Make 3 'sheared' PNG image files from the 3 resized input files.
##################################################################

FILETOPSHEAR="/tmp/top_shear.png"
FILELEFTSHEAR="/tmp/left_shear.png"
FILERIGHTSHEAR="/tmp/right_shear.png"

if test -f "$FILETOPSHEAR"
then
  rm -f "$FILETOPSHEAR"
fi

if test -f "$FILELEFTSHEAR"
then
  rm -f "$FILELEFTSHEAR"
fi

if test -f "$FILERIGHTSHEAR"
then
  rm -f "$FILERIGHTSHEAR"
fi

# top image shear.
convert "$FILETOP" -resize  260x301! -matte -background none \
          -shear 0x30 -rotate -60 -gravity center -crop 520x301+0+0 \
          "$FILETOPSHEAR"

# left image shear
convert "$FILELEFT"  -resize  260x301! -matte -background none \
          -shear 0x30  "$FILELEFTSHEAR"

# right image shear
convert "$FILERIGHT"  -resize  260x301! -matte -background none \
          -shear 0x-30 "$FILERIGHTSHEAR"


##################################################################
## Make full filename for the PNG output file --- using the
## name of the 3 input files.
##
## If the user has write-permission on the
## current directory, put the file in the pwd.
## Otherwise, put the file in /tmp.
##################################################################

CURDIR="`pwd`"

OUTFILE="${FILE1MIDNAME}_${FILE2MIDNAME}_${FILE3MIDNAME}_CUBE${SIZE_FACTOR}.png"

if test ! -w "$CURDIR"
then
  OUTFILE="/tmp/$OUTFILE"
fi

if test -f "$OUTFILE"
then
  rm -f "$OUTFILE"
fi


#################################################################
## Use 'convert' to make the new image file ---
## by combining the 3 sheared PNG files.
#################################################################

## FOR TESTING:
#      set -x

convert "$FILELEFTSHEAR" "$FILERIGHTSHEAR" +append \
          \( "$FILETOPSHEAR" -repage +0-149 \) \
          -background none -layers merge +repage \
          -resize ${SIZE_FACTOR}% \
          "$OUTFILE"

## ${SIZE_FACTOR} was 30 in the example at
## Reference: http://www.imagemagick.org/Usage/warping/#sheared_cube

## FOR TESTING:
#      set -


#################################################################
## REMOVE the temporary files --- six.
#################################################################

rm "$FILELEFT" "$FILERIGHT" "$FILETOP"
rm "$FILELEFTSHEAR" "$FILERIGHTSHEAR" "$FILETOPSHEAR"


##########################
## Show the new image file.
##########################

## . $HOME/.gnome2/nautilus-scripts/.set_VIEWERvars.shi

. $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
. $DIR_NautilusScripts/.set_VIEWERvars.shi

$IMGVIEWER "$OUTFILE" &

# $IMGEDITOR "$OUTFILE" &
