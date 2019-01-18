#!/bin/sh
##
## Nautilus
## SCRIPT: 00_one-level-JPEG-files_SLIDESHOW_ls-file-grep_files-list-to-ONE-display.sh
##
## PURPOSE: Finds ALL the files in the current directory
##          whose file-type contains the string
##          'JPEG image data' --- using 'ls', 'file', and 'grep'.
##
##          Example outputs from 'file' on JPEG files:
##
##            JPEG image data, EXIF standard 
##            JPEG image data, JFIF standard 1.01 
##            JPEG image data, JFIF standard 1.02
##
##          Shows the files with an image viewer --- the ImageMagick 
##          'display' command --- by passing a list of filenames to
##          'display' on the command line.
##
## METHOD:  Builds a list of JPEG filenames --- found by the 'ls-file-grep'
##          combo --- and used a loop supplying each filename to the
##          'display' command.
##
##          Note that this technique works even if the JPEG files
##          have no suffix, such as '.jpg' --- or a wrong suffix.
##
## HOW TO USE: Right-click on the name of any file (or directory) in
##             a Nautilus list, after navigating to a 'base' directory.
##             Then choose this Nautilus script (name above).
#########################################################################
## MAINTENANCE HISTORY:
## Created: 2013apr10
## Changed: 2013
#########################################################################

## FOR TESTING: (show statements as they execute)
   set -x

#########################################################
## Check if the display executable exists.
#########################################################

EXE_FULLNAME="/usr/bin/display"

if test ! -f "$EXE_FULLNAME"
then
   zenity  --info --title "Executable NOT FOUND." \
   --no-wrap \
   --text  "\
The display executable
   $EXE_FULLNAME
was not found. Exiting.

If the executable is in another location,
you can edit this script to change the filename.
OR, install the ImageMagick package."
   exit
fi


#########################################################
## Prompt for X and Y size of the display area.
#########################################################

XYPIXELS=""

XYPIXELS=$(zenity --entry --title "Enter X and Y pixels, to size display area." \
   --text "\
Enter X and Y sizes (in pixels), to size the display area of the slide show.
Examples: 900 700   OR   800 600

You can advance through the slide show by pressing the space bar
when the mouse cursor is over the image area.

NOTE: If these values are too large, there will be a small window that
appears. It allows you to scroll the image within the larger window." \
   --entry-text "900 700")

if test "$XYPIXELS" = ""
then
   exit
fi

XPIXELS=`echo "$XYPIXELS" | cut -d' ' -f1`
YPIXELS=`echo "$XYPIXELS" | cut -d' ' -f2`


########################################################################
## Use 'ls-file-grep' to get the JPEG filenames.
########################################################################
## REFERENCE for this technique - FE Nautilus script:
## 07t_anyfile4Dir_PLAYall-mp3sOfDir-in-Totem_ls-grep-make-filenames-string.sh
## in the 'AUDIOtools' group.
########################################################################

## This does not work for filenames with embedded spaces.
#  JPGNAMES=`ls  | grep '\.jpg$' | sed 's|$| |'`

FILENAMES=`ls`
 
HOLD_IFS="$IFS"
## We put a single line-feed in IFS.
IFS='
'

## It would be nice to avoid changing IFS, but I have not
## found a way, yet, to make the 'in' reader
## of the 'for' loop recognize the separate filenames
## when filenames contain spaces.
##   (Perhaps we could use 'sed' to put a quote at the
##    beginning and end of each line in $FILENAMES.)

JPGNAMES=""

for FILENAME in $FILENAMES
do
   FILECHK=`file "$FILENAME" | grep 'JPEG image'`
   if test ! "$FILECHK" = ""
   then
      JPGNAMES="$JPGNAMES \"$FILENAME\""
   fi
done

IFS="$HOLD_IFS"

if test "$JPGNAMES" = ""
then
   zenity  --info --title "NO MATCHES." \
      --text  "No JPEG files found. EXITING."
   exit
fi

## FOR TESTING:
#  xterm -fg white -bg black -hold -geometry 90x24+100+100 -e \
#  echo "JPGNAMES: $JPGNAMES"

########################################################################
## Pass the string of filenames to the 'display' image viewer command.
## (Simply using $FILENAMES as input to the viewer will encounter failures
##  when there are spaces embedded in filenames.)
########################################################################

eval $EXE_FULLNAME -sample ${XPIXELS}x$YPIXELS  "$JPGNAMES"

exit
## This 'exit' is to make sure that the following info on
## the 'display' command is not fed to the script interpreter.

#######################################################################
## NOTE: 'man display'includes the following lines:
##
## NAME
##       display - displays an image or image sequence on any X server.
##
## SYNOPSIS
##       display [options] input-file
##
## OVERVIEW
##       The  display  program is a member of the ImageMagick suite of tools.
##       Use it to display an image or image sequence on any X server.
##
##       For more information about the display command, point your  browser  to
##       http://www.imagemagick.org/script/display.php.
##
## DESCRIPTION
##       Image Settings:
##
##	 -antialias	         remove pixel-aliasing
##	 -backdrop	         display image centered on a backdrop
##	 -comment string     annotate image with comment
##	 -delay value	      display the next image after pausing
##	 -density geometry   horizontal and vertical density of the image
##	 -depth value	      image depth
##	 -display server     display image to this X server
##	 -filter type	      use this filter when resizing an image
##	 -fuzz distance      colors within this distance are considered equal
##	 -geometry geometry  preferred size and location of the Image window
##	 -gravity type	      horizontal and vertical backdrop placement
##	 -identify	         identify the format and characteristics of the image
##	 -interlace type     type of image interlacing scheme
##	 -interpolate method pixel color interpolation method
##	 -label string	      assign a label to an image
##	 -loop iterations    loop images then exit
##	 -map type	         display image using this Standard Colormap
##	 -page geometry      size and location of an image canvas
##	 -quiet 	            suppress all warning messages
##	 -repage geometry    size and location of an image canvas (operator)
##	 -sampling-factor geometry     horizontal and vertical sampling factor
##	 -size geometry      width and height of image
##	 -support factor     resize support: > 1.0 is blurry, < 1.0 is sharp
##	 -texture filename	name of texture to tile onto the image background
##	 -transparent-color color      transparent color
##	 -visual type	      display image using this visual type
##	 -window id	         display image to background of this window
##	 -window-group id    exit program when this window id is destroyed
##	 -write filename     write image to a file
##
##       Image Operators:
##
##	 -auto-orient	      automatically orient image
##	 -border geometry    surround image with a border of color
##	 -colors value	      preferred number of colors in the image
##	 -contrast	         enhance or reduce the image contrast
##	 -crop geometry      preferred size and location of the cropped image
##	 -despeckle	         reduce the speckles within an image
##	 -edge factor	      apply a filter to detect edges in the image
##	 -enhance	         apply a digital filter to enhance a noisy image
##	 -extract geometry   extract area from image
##	 -flip		         flip image in the vertical direction
##	 -flop		         flop image in the horizontal direction
##	 -frame geometry     surround image with an ornamental border
##	 -gamma value	      level of gamma correction
##	 -monochrome	      transform image to black and white
##	 -negate	            replace every pixel with its complementary color
##	 -raise value	      lighten/darken image edges to	create a 3-D effect
##	 -resample geometry  change the resolution of an image
##	 -resize geometry    resize the image
##	 -roll geometry      roll an image vertically or horizontally
##	 -rotate degrees     apply Paeth rotation to the image
##	 -sample geometry    scale image with pixel sampling
##	 -segment value      segment an image
##	 -sharpen geometry   sharpen the image
##	 -strip 	            strip image of all profiles and comments
##	 -trim		         trim image edges
##
##       Image Sequence Operators:
##
##	 -coalesce	         merge a sequence of images
##	 -flatten	         flatten a sequence of images
##
##       Miscellaneous Options:
##
##	 -debug events	      display copious debugging information
##	 -help		         print program options
##	 -log format	      format of debugging information
##	 -list type	         print a list of supported option arguments
##	 -version	         print version information
##
##       In  addition  to  those	listed above, you can specify these standard X
##       resources as command line options:  -background, -bordercolor, -border-
##       width,  -font, -foreground, -iconGeometry, -iconic, -mattecolor, -name,
##       -shared-memory, -usePixmap, or -title.
##
##       By default, the image format of 'file' is determined by its magic number.
##       To specify a particular image format, precede the filename with
##       an image format name and a colon (i.e. ps:image) or specify  the  image
##       type as the filename suffix (i.e. image.ps).  Specify 'file' as '-' for
##       standard input or output.
##
##       Buttons:
##	 1    press to map or unmap the Command widget
##	 2    press and drag to magnify a region of an image
##	 3    press to load an image from a visual image directory
##
#######################################################################
