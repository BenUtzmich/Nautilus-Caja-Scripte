#!/bin/sh
##
## Nautilus
## SCRIPT: 00_multi-png-files_TRANSPpngTOgif_convert-channel-alpha-threshold.sh
##
## PURPOSE: Converts a selected set of TRANSPARENT '.png' files
##          to TRANSPARENT '.gif' files.
##
## METHOD:  Uses 'zenity --entry' to prompt for threshold percent.
##
##          Uses ImageMagick 'convert' with '-channel Alpha' and '-threshold'
##          options.
##
##          (80% threshold was used in reference below. 20% seems better in
##           a test on a PNG image file. So we prompt for the threshold percent.)
##
##          We can let 'convert' determine a palette size for the GIF file.
##
##             [OR we could  use 'zenity' to ask user for 'palette-size'
##              and use '-colors' on 'convert' to set the palette size of
##              the '.gif' output file(s).  Someday?]
##
##          We put the new '.gif' files in the directory with the selected
##          '.png' files.
##
## References:
##    http://ehertlein.blogspot.com/2006/06/imagemagick-to-convert-png-to-gif.html
##
## HOW TO USE: In Nautilus, select one or more '.png' files.
##             Then right-click and choose this script to run (name above).
##
#################################################################################
## Created: 2011oct19 Based on '00_multiCONVERT_pngORjpgFiles_TOgif.sh'.
## Changed: 2012jan21 Changed a zenity prompt for palette size for the
##                    GIF file to a prompt for transparency percent.
##                    Also added 'convert-channel-alpha-threshold' to the
##                    name of the script.
## Changed: 2012feb11 Changed script name.
## Changed: 2012may14 Changed script name in comments above and touched up
##                    the comments. Changed some indenting below.
## Changed: 2015feb07 Added code to show the last new image file.
###########################################################################

## FOR TESTING: (show statements as they execute)
# set -x

###################################################
## Get the 'transparency percent' for the -'threshold'
## parameter --- to make the output GIF files.
###################################################

TRANSP_PERCENT=""

TRANSP_PERCENT=$(zenity --entry \
   --title "Enter 'TRANSPARENCY-PERCENT'." \
   --text "\
Enter a 'THRESHOLD' PERCENT value to determine the transparent parts of
the ouput GIF file(s), from the Alpha channel of the input PNG file(s).

Example values:  20   OR   50   OR   80

NOTE: We do not prompt for number of colors (palette size) for the
GIF file(s). We let ImageMagick 'convert' determine a minimum palette." \
        --entry-text "20")

if test "$TRANSP_PERCENT" = ""
then
   exit
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

   OUTFILE="${FILENAMECROP}_wasPNG_TRANS_PCENT${TRANSP_PERCENT}.gif"

   if test -f "$OUTFILE"
   then
      rm -f "$OUTFILE"
   fi

   ###########################################
   ## Use 'convert' to make the 'gif' file.
   ###########################################

   convert "$FILENAME" -channel Alpha -threshold ${TRANSP_PERCENT}% \
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

