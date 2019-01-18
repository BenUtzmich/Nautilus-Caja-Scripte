#!/bin/sh
##
## Nautilus
## SCRIPT: 02b_multi-png-files_TRANSPpngTOgif_convert-ordered-dither.sh
##
## PURPOSE: Converts a selected set of TRANSPARENT '.png' files
##          to TRANSPARENT '.gif' files by dithering the semi-transparent
##          parts of the '.png' files.
##
## METHOD:  Uses 'zenity --list --radiolist' to prompt for the dither type.
##
##          Uses ImageMagick 'convert' with '-channel Alpha' and
##          '-ordered-dither ...' options.
##
##          We let 'convert' determine a palette size for the GIF file.
##
##             [OR we could  use 'zenity' to ask user for 'palette-size'
##              and use '-colors' on 'convert' to set the palette size of
##              the '.gif' output file(s).  Someday?]
##
## References: http://www.imagemagick.org/Usage/formats/#dither
##
## HOW TO USE: In Nautilus, select one or more '.png' files.
##             Then right-click and choose this script to run (name above).
##
###########################################################################
## Created: 2012jan22
## Changed: 2012feb11 Changed script name.
## Changed: 2012may14 Changed script name in comments above and touched up
##                    the comments. Changed some indenting below.
## Changed: 2015feb07 Added code to show the last new image file.
###########################################################################

## FOR TESTING: (show statements as they execute)
# set -x

###################################################
## Get the dither type for the output GIF files.
###################################################

DITHER_TYPE=""

DITHER_TYPE=`zenity --list --radiolist \
   --title "DITHER TYPE?" \
   --text "\
Choose a dither type to apply to the selected PNG file.
" \
   --column "" --column "DitherType" \
      TRUE  ordered_2x2 \
      FALSE ordered_3x3 \
      FALSE ordered_4x4 \
      FALSE halftone_2 \
      FALSE halftone_4 \
      FALSE halftone_6 \
      FALSE halftone_8`

if test "$DITHER_TYPE" = ""
then
   exit
fi

# if test "$DITHER_TYPE" = "ordered_2x2"
# then
   DITHER_PARM="o2x2"
# fi

if test "$DITHER_TYPE" = "ordered_3x3"
then
   DITHER_PARM="o3x3"
fi

if test "$DITHER_TYPE" = "ordered_4x4"
then
   DITHER_PARM="o4x4"
fi

if test "$DITHER_TYPE" = "halftone_2"
then
   DITHER_PARM="checks"
fi

if test "$DITHER_TYPE" = "halftone_4"
then
   DITHER_PARM="h4x4a"
fi

if test "$DITHER_TYPE" = "halftone_6"
then
   DITHER_PARM="h6x6a"
fi

if test "$DITHER_TYPE" = "halftone_8"
then
   DITHER_PARM="h8x8a"
fi

###################################################
## Get the 'palette size' for the output GIF files.
##   COMMENTED, for now.
###################################################

# PALSIZE=""

# PALSIZE=$(zenity --entry --title "Enter the GIF palette size (2-256)." \
#    --text "\
# Enter the GIF palette size (2-256).
#       Typically use 2 for monochrome (2 color) images ---
#       8 or more if they are anti-aliased images.
# 
# Typical values:
# 256, 128, 64, 32, 16, 8, 4, 2
# 
# Enter 0 to let ImageMagick 'convert' determine a minimum palette." \
#         --entry-text "256")

# if test "$PALSIZE" = ""
# then
#    exit
# fi

# PALPARM="-colors $PALSIZE"

# if test "$PSIZE" = "0"
# then
#    PALPARM=""
# fi

PALPARM=""

####################################
## START THE LOOP on the filenames.
####################################

for FILENAME
do

   ###########################################################
   ## Get and check that the file extension is 'png' or 'jpg'.
   ## Assumes one dot (.) in the filename, at the extension.
   ###########################################################

   FILEEXT=`echo "$FILENAME" | cut -d\. -f2`
 
   if test "$FILEEXT" != "png"
   then
      continue 
      #  exit
   fi

   ###########################################################
   ## Get the 'midname' of the filename --- by stripping
   ## the '.png' or '.jpg' suffix.
   ###########################################################

   FILENAMECROP=`echo "$FILENAME" | sed 's|\.png$||'`

   #####################################################
   ## Make the output filename with '.gif' suffix ---
   ## and delete the filename if it exists.
   #####################################################

   OUTFILE="${FILENAMECROP}_wasPNG_DITHER${DITHER_PARM}.gif"

   if test -f "$OUTFILE"
   then
      rm -f "$OUTFILE"
   fi


   ###########################################
   ## Use 'convert' to make the 'gif' file.
   ###########################################

   convert "$FILENAME" -channel Alpha -ordered-dither $DITHER_PARM \
         $PALPARM "$OUTFILE"

done
## END OF 'for FILENAME' loop

#############################################################
## Show the LAST new image file.
## NOTE: The viewer may be able to go back through the other
##       image files if multiple image files were resized.
#############################################################

## . $HOME/.gnome2/nautilus-scripts/.set_VIEWERvars.shi

. $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
. $DIR_NautilusScripts/.set_VIEWERvars.shi

$IMGVIEWER "$OUTFILE" &

# $IMGEDITOR "$OUTFILE" &
