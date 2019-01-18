#!/bin/sh
##
## Nautilus
## SCRIPT: 01_multi-img-files_CONVERT-TOpng_optCOLOR2TRANSPARENT_convert-transparent-fuzz.sh
##
## PURPOSE: For a selected set of image files --- '.jpg', '.png', '.gif' or
##          whatever, converts them to '.png' files --- AND OPTIONALLY makes
##          a specified color transparent.
##
## METHOD:  Uses 'zenity --entry' to ask user for a color to make transparent
##          --- or no transparency.
##
##          Uses 'zenity --entry' to prompt for a fuzz percent (for making
##          'nearby' colors transparent).
##
##          Uses ImageMagick 'convert' --- with the '-transparent' option
##          if a color is specified for transparency.
##
##          Puts the new '.png' files in the directory with the selected
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
################################################################################
## Created: 2013dec25 Adopted a script from the 'imgTRANPtools' group.
## Changed: 2013
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
#ff0000   OR   red
#ffffff   OR   white
-1 if no color is to be made transparent" \
   --entry-text "-1")

if test "$TRANSPCOLOR" = ""
then
   exit
fi


###############################################
## Get the 'fuzz-percent' to use in determining
## the colors to make transparent.
###############################################

if test "$TRANSPCOLOR" != "-1"
then

   FUZZPERCENT=""

   FUZZPERCENT=$(zenity --entry \
      --title "Enter the FUZZ PERCENT." \
      --text "\
Enter the 'FUZZ-PERCENT' to use in determining
the colors to make transparent --- near the
specified color: $TRANSPCOLOR.

Examples: 2   OR   3   OR   5   OR   9" \
   --entry-text "2")

   if test "$FUZZPERCENT" = ""
   then
      exit
   fi
fi
## END OF if test "$TRANSPCOLOR" != "-1"

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
   ## Check that the file extension is 'png'.
   ##   Assumes one dot (.) in the filename, at the extension.
   ## COMMENTED, for now.
   ###########################################################
 
   ## if test "$FILEEXT" != "png"
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
   ## Use 'convert' to make the (transparent) 'png' file.
   #####################################################

   if test "$TRANSPCOLOR" = "-1"
   then
      OUTFILE="${FILEMIDNAME}.png"

      if test -f "$OUTFILE"
      then
         rm -f "$OUTFILE"
      fi

      convert "$FILENAME" "$OUTFILE"

   else
      OUTFILE="${FILEMIDNAME}_TRANSPARENT${TRANSPCOLOR}_FUZZ${FUZZPERCENT}.png"

      if test -f "$OUTFILE"
      then
         rm -f "$OUTFILE"
      fi

      convert "$FILENAME" -fuzz ${FUZZPERCENT}\% -transparent "$TRANSPCOLOR" \
         "$OUTFILE"
   fi
   ## END OF   if test "$TRANSPCOLOR" = "-1"

done
## END OF 'for FILENAME' loop
