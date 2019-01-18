#!/bin/sh
##
## Nautilus
## SCRIPT: 00_multi-img-files_aCOLOR2TRANSPARENT-gif_convert-transparent-fuzz.sh
##
## PURPOSE: For a selected set of image files --- '.jpg', '.png', '.gif' or
##          whatever, converts them to TRANSPARENT '.gif' files by making
##          a specified color transparent.
##
## METHOD:  Uses 'zenity --entry' to ask user for a color to make transparent.
##
##          Uses 'zenity' to prompt for a fuzz percent (for making 'nearby'
##          colors transparent).
##
##          Uses ImageMagick 'convert' with the '-transparent' option.
##
##          Puts the new '.gif' files in the directory with the selected
##          image files.
##
## References:
##    http://www.imagemagick.org/discourse-server/viewtopic.php?f=1&t=12914
##    http://www.imagemagick.org/script/command-line-options.php#transparent
##    http://www.imagemagick.org/script/command-line-options.php#fuzz
##
## HOW TO USE: In Nautilus, select one or more image files.
##             Then right-click and choose this script to run (name above).
##
##########################################################################
## Created: 2012feb11
## Changed: 2012may14 Changed script name in comments above and touched up
##                    the comments. Changed some indenting below.
## Changed: 2015nov07 Added code to show the last new image file.
###########################################################################

## FOR TESTING: (show statements as they execute)
# set -x


###########################################
## Get the 'color' to make transparent.
###########################################

TRANSPCOLOR=""

TRANSPCOLOR=$(zenity --entry \
   --title "Enter a COLOR." \
   --text "\
Enter the COLOR to make TRANSPARENT.

Examples:
#000000   OR   black
#ffffff   OR   white" \
        --entry-text "#000000")

if test "$TRANSPCOLOR" = ""
then
   exit
fi


###############################################
## Get the 'fuzz-percent' to use in determining
## the colors to make transparent.
###############################################

FUZZPERCENT=""

FUZZPERCENT=$(zenity --entry \
   --title "Enter the FUZZ PERCENT." \
   --text "\
Enter the 'FUZZ-PERCENT' to use in determining
the colors to make transparent --- near the
specified color: $TRANSPCOLOR.

Examples: 2   or   3   OR   5   OR   9" \
   --entry-text "2")

if test "$FUZZPERCENT" = ""
then
   exit
fi


####################################
## START THE LOOP on the filenames.
####################################

for FILENAME
do

   ###########################################################
   ## Get the file extension.
   ##    Assumes one dot (.) in the filename, at the extension.
   ## COMMENTED, for now.
   ###########################################################

   # FILEEXT=`echo "$FILENAME" | cut -d\. -f2`

   ###########################################################
   ## Check that the file extension is 'png' or 'jpg' or 'gif'.
   ##   Assumes one dot (.) in the filename, at the extension.
   ## COMMENTED, for now.
   ###########################################################
 
   ## if test "$FILEEXT" != "png" -a "$FILEEXT" != "jpg" -a "$FILEEXT" != "gif"
   ## then
   ##    continue 
   ##    #  exit
   ## fi


   ###########################################################
   ## Get the 'midname' of the filename --- by stripping
   ## the file extension.
   ##    Assumes one dot (.) in the filename, at the extension.
   ###########################################################

   # FILEMIDNAME=`echo "$FILENAME" | sed 's|\..*$||'`
   FILEMIDNAME=`echo "$FILENAME" | cut -d\. -f1`

   #####################################################
   ## Use 'convert' to make the transparent 'gif' file.
   #####################################################

   OUTFILE="${FILEMIDNAME}_MADE${TRANSPCOLOR}TRANSPARENT_FUZZ${FUZZPERCENT}.gif"

   if test -f "$OUTFILE"
   then
      rm -f "$OUTFILE"
   fi

   convert "$FILENAME" -fuzz ${FUZZPERCENT}\% -transparent "$TRANSPCOLOR" \
          "$OUTFILE"

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


