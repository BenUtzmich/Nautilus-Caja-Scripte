#!/bin/sh
##
## NAUTILUS
## SCRIPT: 00_multi-img-files_BLUR_convert-blur.sh
##
## PURPOSE: Makes blurred file(s) from selected image file(s).
##
## METHOD:  Uses ImageMagick 'convert' with the '-blur' option.
##
##          Uses 'zenity' to prompt the user for one of a few typical
##          ImageMagick 'convert'  blur parameters:  'radius' and 'sigma',
##          where 'sigma' is a fuzziness factor.
##
##          These two values are used on the 'convert' command line in the form
##                     -blur  {radius}x{sigma}
##
##           Examples: 0x1  OR  3x1  OR  3x2  OR  2x0.3
##                     to remove 'jaggies'.
##
##          This script shows the (last) new image file in an image viewer of
##          the user's choice.
##
## REFERENCE:  http://www.imagemagick.org/Usage/blur/#blur
##
## HOW TO USE: In the Nautilus file manager, select the name(s) of image
##             file(s) in a Nautilus directory list.
##             Then right-click and choose this script to run (name above).
##
## Created: 2010jun01
## Changed: 2011may11 Get 'nautilus-scripts' directory via an include script.
## Changed: 2011jan18 Add '_convert-blur' to the name of this script.
##                    Other minor changes.
## Changed: 2012feb22 To handle multiple image files (added do-loop).
## Changed: 2012feb29 Changed the script name in the comment above.

## FOR TESTING: (show statements as they execute)
#  set -x

#######################################################
## Prompt for the blur parameter.
#######################################################

BLURPARMS=""

BLURPARMS=`zenity --list --radiolist \
   --title "Blur parameters?" \
   --text "
Choose the blur parameters --- 'radius' and 'sigma'.
Sigma is a fuzziness factor.  It determines the actual amount of blurring
that will take place

If radius is set to zero, the ImageMagick 'convert' program will calculate
an appropriate radius.  If you want to specify a non-zero radius ...

As a guideline, radius should be at least twice the sigma value,
although three times will produce a more accurate result." \
   --column "" --column "{radius}x{sigma}" \
   TRUE  0x1 \
   FALSE 0x2 \
   FALSE 0x3 \
   FALSE 0x4 \
   FALSE 0x6 \
   FALSE 1x0.3 \
   FALSE 3x1 \
   FALSE 6x2 \
   FALSE 12x4`

if test "$BLURPARMS" = ""
then
   exit
fi


####################################
## START THE LOOP on the filenames.
####################################

for FILENAME
do

   ##########################################################
   ## Get the 'midname' and suffix of the selected image file,
   ## to use to name the new output file.
   ##     Assumes just one period (.) in the filename,
   ##     at the suffix.
   ##########################################################

   FILEMIDNAME=`echo "$FILENAME" | cut -d'.' -f1`
   FILESUFFIX=`echo "$FILENAME" | cut -d'.' -f2`


   ####################################################################
   ## Get and check that the file extension is 'jpg' or 'png' or 'gif'.
   ##     Assumes one period (.) in filename, at the extension.
   ## COMMENTED, for now.
   ####################################################################
   # FILEEXT=`echo "$FILENAME" | cut -d\. -f2`
 
   # if test "$FILEEXT" != "jpg" -a "$FILEEXT" != "png" -a "$FILEEXT" != "gif"
   # then
   #    continue
   #    # exit
   # fi


   ##################################################################
   ## Make full filename for the output file --- using the
   ## name of the input file.
   ##
   ## If the user has write-permission on the
   ## current directory, put the file in the pwd.
   ## Otherwise, put the file in /tmp.
   ##################################################################

   CURDIR="`pwd`"

   OUTFILE="${FILEMIDNAME}_BLURRED${BLURPARMS}.$FILESUFFIX"

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

   ## FOR TESTING:
   #      set -x

   convert "$FILENAME"  -channel RGBA -blur $BLURPARMS  "$OUTFILE"

   ## FOR TESTING:
   #      set -

done
## END OF LOOP: for FILENAME


############################################################
## Show the LAST new image file.
## NOTE: The viewer may be able to go back through the other
##       image files if multiple image files were resized.
############################################################

## . $HOME/.gnome2/nautilus-scripts/.set_VIEWERvars.shi

. $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
. $DIR_NautilusScripts/.set_VIEWERvars.shi

$IMGVIEWER "$OUTFILE" &

# $IMGEDITOR "$OUTFILE" &
