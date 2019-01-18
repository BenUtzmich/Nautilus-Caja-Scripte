#!/bin/sh
##
## Nautilus
## SCRIPT:
## 00_multi-img-files_CONVERT_TOjpg_convert-quality-strip-samplingfactor-filter.sh
##
## PURPOSE: Converts a selected set of image files --- '.png' or '.gif'
##          or whatever --- to '.jpg' files. Can also be used to further
##          compress '.jpg' files.
##
## METHOD:  Uses ImageMagick 'convert' with option '-quality', '-samplingfactor',
##          '-strip', and '+dither'.
##
##          Uses 'zenity' to ask user for 'quality factor' --- recommended
##          between 80 and 100 (for less than 80, 'mosquito noise' appears).
##
##          Uses 'zenity' to ask user for 'sampling factor' --- such as
##          '1x1' or '2x2'.
##
##          Shows the (last) new image file in an image viewer (or editor)
##          of the user's choice.
##
## HOW TO USE: In the Nautilus file manager, navigate to the desired directory
##             and select one or more image files.
##             Then right-click and choose this script to run (name above).
##
## REFERENCES:
##        http://www.imagemagick.org/Usage/formats/#jpg
##########################################################################
## Created: 2014jun26 To add a quality prompt to the script
##                    '00_multi-img-files_CONVERT_TOjpg_convert-quality-100.sh'
## Changed: 2014jun30 Added '+dither' & '-enhance' to the 'convert' command.
##                    Then tried '-sampling-factor' instead. Reference:
##             http://www.impulseadventure.com/photo/chroma-subsampling.html
##                    Then tried '-despeckle'. Reference:
##      http://www.wizards-toolkit.org/discourse-server/viewtopic.php?f=1&t=15855
##                    None of these made a significant difference on a
##                    cartoon image at quality=60.
## Changed: 2014jul16 Added '-strip'. 
## Changed: 2014jul28 Added '-filter lanczos -sampling-factor 2x2'. This
##                    STILL does not eliminate a dithering effect around text.
## Changed: 2014nov14: Added a prompt for the sampling-factor, and changed
##                     the end of the name of this script. Changed filter
##                     to Mitchell.
## Changed: 2014nov19 Added some info on '-strip' to the zenity command.
##                    Added a zenity prompt for '-filter'.
## Changed: 2014dec03 Changed '-quality' and '-sampling-factor' defaults
##                    to match ImageMagick 'convert' defaults. Added more
##                    filter names to the zentity filter prompt.
##########################################################################

## FOR TESTING: (show statements as they execute)
#  set -x

#########################################################
## Check if the convert executable exists.
#########################################################

EXE_FULLNAME="/usr/bin/convert"

if test ! -f "$EXE_FULLNAME"
then
   zenity  --info --title "Executable NOT FOUND." \
   --no-wrap \
   --text  "\
The convert executable
   $EXE_FULLNAME
was not found. Exiting.

If the executable is in another location,
you can edit this script to change the filename.
OR, install the ImageMagick package."
   exit
fi

#####################################################
## Get the 'quality' factor for the output JPEG files.
#####################################################
## FROM:
## http://www.imagemagick.org/discourse-server/viewtopic.php?f=1&t=21934&p=93593
##
## No downsampling is used when quality is 91 or more.
## For lower values of quality, the U and V channels are
## downsampled by a factor of 2. You can override that
## default behaviour with "-define jpeg:sampling-factor=...".
## Look at "-define" and "-quality" on the Commandline-Tools/Options page.
########################################################################

QUAL=""

QUAL=`zenity --entry \
   --title "Enter a QUALITY factor (80 - 100)." \
   --text "\
Enter the JPEG quality factor. (Lower results in more compression.)
Recommended between 80 and 100.
For less than 80, 'mosquito noise' becomes apparent.
ImageMagick 'convert' default is 92.

References:
http://www.imagemagick.org/Usage/formats/#jpg
http://www.imagemagick.org/script/command-line-options.php#quality

This utility uses the '-strip' option of the 'convert'
command, to strip out text data, like EXIF data, from
the output '.jpg' file.
" \
   --entry-text "92"`

if test "$QUAL" = ""
then
   exit
fi


#####################################################
## Get the 'sampling-factor' for the output JPEG files.
#####################################################
## FROM:
## http://www.imagemagick.org/discourse-server/viewtopic.php?t=23487
##
## With a bit of experimentation, it seems the general advice should be:
## "If you get blurring in an output JPG file, insert '-sampling-factor 1x1'
## immediately before the output filename. However, this will also increase
## the file size."
##
## This seems to be confirmed at
##      http://celestia.h-schmidt.net/earth-vt/
## with '-quality 75', and confirmed by
##      http://www.niksula.hut.fi/~plahteen/misc/Gamma%20error%20in%20picture%20scaling.html
## with '-quality 85', and confirmed by
##      http://www.sitepoint.com/forums/showthread.php?310644-Looking-for-better-JPEG-compression-in-PHP-than-GD-offers
## with '-quality 80'.
#####################################################
## FROM:
## http://www.imagemagick.org/Usage/formats/#jpg_write
##
##-sampling-factor {horizontal}x{vertical}
## Adjusts the sampling factor used by JPEG library for chroma down sampling.
## This can be set to '2x1' for creating MPEG-2 animation files.
## "2x2, 1x1, 1x1" is IM's standard sub-sampling method and corresponds to
## 4:2:0, see Wikipedia, Chroma Sub-Sampling. However when "quality" is 90
## or higher, the channels are not sub-sampled. Basically it will define
## whether the processing 'block' or 'cell' size is 8 pixels or 16 pixels. 
#####################################################
## FROM:
## http://stackoverflow.com/questions/15837750/imagemagick-sampling-factor
##
## I have been using ImageMagick command line tool for jpeg compression
## of the images. However, I'm trying to understand the role of sampling factor.
## It says the sampling factor is used to specify the block size i.e. 8x8 or 16x16.
## etc. etc. etc. (much still-puzzling verbiage)
###########################################################################

SAMPFACT=""

SAMPFACT=`zenity --entry \
   --title "Enter a 'sampling-factor' (such as 1x1)." \
   --text "\
Enter the JPEG 'sampling-factor' (horizontal-factorxvertical-factor).
Example values:
 1x1
 2x2 (ImageMagick 'convert' default)
 2x1

References:
http://www.imagemagick.org/script/command-line-options.php#quality
http://www.imagemagick.org/script/command-line-options.php#sampling-factor
" \
   --entry-text "2x2"`

if test "$SAMPFACT" = ""
then
   exit
fi


#####################################################
## Get the 'filter' for the output JPEG files.
#####################################################
## SOME VALUES FOR '-filter' :
## lanczos lanczos2 lanczos2sharp Box Cubic Mitchell Catrom Sinc Blackman
##
## FROM: http://www.dpreview.com/forums/post/40282142
## My versions for downsampling are:
##  convert %1 -filter Lanczos -sampling-factor 1x1 -quality 90 -resize 1024 "out_1024.jpg"
## For a soft downsample with ZERO ringing
##  convert %1 -filter Mitchell -sampling-factor 1x1 -quality 90 -resize 1024 "out_1024.jpg"
## For something between Lanczos and Mitchell, Catrom is a good bet
##  convert %1 -filter Catrom -sampling-factor 1x1 -quality 90 -resize 1024 "out_1024.jpg"
##
## FROM: http://www.meteoadriatic.net/pub/tif2jpg/tif2jpg
## Recommended filters are Lanczos, Sinc or Mitchell. For little sharper result,
## you can try Box or Blackman. For little softer image try Cubic.
## There are lot of other filters in imagemagick.
########################################################################
## For using '-filter' when resizing images, SEE
## http://imagemagick.org/discourse-server/viewtopic.php?f=22&t=18514
## on trying
## '-filter lanczos2sharp -distort resize'
## or simply
## '-filter lanczos2 -resize'.
########################################################################

FILTER=""

FILTER=`zenity --entry \
   --title "Enter a FILTER NAME." \
   --text "\
Enter a FILTER-NAME to use with the JPEG 'sampling-factor'.
Example values:
 Blackman Bohman Box Catrom Cosine Cubic Hamming Hann Hermite
 Jinc Kaiser Lagrange Lanczos Lanczos2 Lanczos2sharp Mitchell
 Parzen Point Quadratic Robidoux Sinc Spline Triangle Welch ...

References:
http://www.dpreview.com/forums/post/40282142
http://www.meteoadriatic.net/pub/tif2jpg/tif2jpg
" \
   --entry-text "Mitchell"`

if test "$FILTER" = ""
then
   exit
fi


###################################
## START THE LOOP on the filenames.
###################################

for FILENAME
do

   ###########################################################
   ## Get the file extension, such as 'png' or 'gif'.
   ##   Assumes one dot (.) in the filename, at the extension.
   ###########################################################

   FILEEXT=`echo "$FILENAME" | cut -d\. -f2`

   ###########################################################
   ## Check that the file extension is 'png' or 'gif'.
   ## COMMENTED for now. Instead we allow any image file type.
   ###########################################################

   # if test "$FILEEXT" != "png" -a "$FILEEXT" != "gif"
   # then
   #    continue 
   #    #  exit
   # fi


   ###########################################################
   ## Get the 'midname' of the filename by removing the
   ## extension --- such as '.png' or '.gif'.
   ##   Assumes one dot (.) in the filename, at the extension.
   ###########################################################

   # FILENAMECROP=`echo "$FILENAME" | sed 's|\..*$||'`

   FILENAMECROP=`echo "$FILENAME" | cut -d\. -f1`


   ##############################################################
   ## Make the name of the output '.jpg' file.
   ## If the file already exists, remove it.
   ## If the file already exists, we could skip processing this file.
   ## (We could use 'zenity --info' to pop a notice to the user.)
   ##############################################################

   OUTFILE="${FILENAMECROP}_Quality${QUAL}_SampFact${SAMPFACT}_Filter${FILTER}_Stripped.jpg"


   rm -f "$OUTFILE"

   # if test -f "$OUTFILE"
   # then
   #    continue 
   #    #  exit
   # fi


   ########################################################################
   ## Use 'convert' to make the 'jpg' file --- with '-quality' and
   ## '-sampling-factor'. We use '-filter' with '-sampling-factor'.
   ##
   ## Also we use '-strip' (to strip file of profiles and comments)
   ## and '+dither' (to try to make sure no dithering is applied).
   ########################################################################
   ## NOTE: '+dither' is used to try to make sure that 'convert' does not
   ## try to dither the image, as it seems to do by default in many cases,
   ## especially when creating a '.gif' file.
   ########################################################################
   ## For info on '-strip', SEE
   ## http://www.imagemagick.org/Usage/formats/#jpg_read
   ########################################################################
   ## FROM:
   ## http://www.imagemagick.org/discourse-server/viewtopic.php?t=21934
   ## we see we might want to add '-colorspace RGB'.
   ## This might handle input image files in CMYK color format.
   ########################################################################

   $EXE_FULLNAME "$FILENAME" -strip +dither -quality $QUAL \
      -filter $FILTER -sampling-factor $SAMPFACT "$OUTFILE"

done
## END OF LOOP: for FILENAME


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
