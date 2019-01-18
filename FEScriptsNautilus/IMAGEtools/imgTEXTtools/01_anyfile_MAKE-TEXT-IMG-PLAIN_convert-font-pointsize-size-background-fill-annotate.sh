#!/bin/sh
##
## NAUTILUS
## SCRIPT: 01_anyfile_MAKE-TEXT-IMG-PLAIN_convert-font-pointsize-size-background-fill-annotate.sh
##
## PURPOSE: Makes an image containing a user-specified text string.
##
##          Prompts the user for the text string and several other parameters
##          such as
##             - font family name
##             - font pointsize
##             - background color
##             - text-font 'fill' color
##             - image size
##             - text skew parameters        
##
## METHOD:  Makes a list of available fontnames --- using 'fc-list'.
##          Shows the list file in a text-viewer of the user's choice.
##
##          Uses 'zenity' several times to prompt for the items indicated above.
##
##          Then uses the ImageMagick 'convert' command to create the image
##          in the current directory.
##
##          This script makes the output image file of type (suffix) '.jpg'.
##          (We could add a prompt for type --- jpg, png, gif, or others.)
##
##          This script shows the new image file in an image viewer of the
##          user's choice.
##
## References: http://www.imagemagick.org/Usage/fonts/
##             http://www.imagemagick.org/script/command-line-options.php?#annotate
##
## HOW TO USE: In Nautilus, select ANY file in the directory in which
##             the new image file is to be created.
##             Then right-click and choose this script to run (name above).
##
##             The new, generated image file will be put in the current
##             directory, if the user has write permission there ---
##             otherwise the file is put in /tmp.
##
############################################################################
## Script
## Created: 2013apr10
## Changed: 2013
#######################################################################

## FOR TESTING: (show statements as they execute)
#  set -x

#########################################################
## Check if the fc-list executable exists.
#########################################################

EXE_FULLNAME="/usr/bin/fc-list"

if test ! -f "$EXE_FULLNAME"
then
   zenity  --info --title "Executable NOT FOUND." \
   --no-wrap \
   --text  "\
The 'fc-list' executable
   $EXE_FULLNAME
was not found. Exiting. Can't provide a list of the scalable fonts.

If the executable is in another location,
you can edit this script to change the location.
OR, install the fontconfig package that contains 'fc-list'."
   exit
fi


###################################################################
## Prep a temporary filename, to hold the list of font family names.
##      We put the outlist file in /tmp, in case the user
##      does not have write-permission in the current directory,
##      and because the output does not, usually, have anything
##      to do with the current directory.
###################################################################

OUTLIST="${USER}_list_fonts_fc-list.lis"

OUTLIST="/tmp/$OUTLIST"
 
if test -f "$OUTLIST"
then
   rm -f "$OUTLIST"
fi


####################################
## Make the header for the list.
####################################

THISHOST=`hostname`

echo "\
................ `date '+%Y %b %d  %a  %T%p %Z'` ......................

fonts known to 'fc-list'
--- for host:  $THISHOST


These font-family names can be used when you receive a prompt
for font family name.

------------------------------------------------------------------------------
" > "$OUTLIST"


####################################
## Use 'fc-list' to make the list.
####################################

echo "
###########################
Command: 'fc-list : family'
###########################
" >> "$OUTLIST"

#   fc-list : family | sort >> "$OUTLIST"

$EXE_FULLNAME : family | sort >> "$OUTLIST"


####################################
## Add a trailer to the list.
####################################

# SCRIPT_DIRNAME=`dirname $0`
# SCRIPT_BASENAME=`basename $0`

echo "
**** END OF LIST of fonts known to 'fc-list' on host $THISHOST ****
" >> "$OUTLIST"


################################################
## Show the listing --- as a background process.
################################################

## . $HOME/.gnome2/nautilus-scripts/.set_VIEWERvars.shi

. $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
. $DIR_NautilusScripts/.set_VIEWERvars.shi

$TXTVIEWER "$OUTLIST" &


#########################################################
## Check if the 'convert' executable exists.
#########################################################

EXE_FULLNAME="/usr/bin/convert"

if test ! -f "$EXE_FULLNAME"
then
   zenity  --info --title "Executable NOT FOUND." \
   --no-wrap \
   --text  "\
The 'convert' executable
   $EXE_FULLNAME
was not found. Exiting.

If the executable is in another location,
you can edit this script to change the location.
OR, install the ImageMagick package. It contains 'convert'."
   exit
fi

########################################################
## Set the current directory for use in messages and in
## determining output file location.
########################################################

CURDIR="`pwd`"


#######################################################
## Prompt for the TEXT STRING of the image file to be
## generated.
#######################################################

## Allow some time for the user to look at the font-family list.

sleep 2

TEXTSTRING=""

TEXTSTRING=$(zenity --entry --title "Enter TEXT STRING for the image." \
   --text "\
Enter the text string that is to be placed in the image to be generated." \
   --entry-text "This is a test.")

if test "$TEXTSTRING" = ""
then
    exit
fi


#######################################################
## Prompt for the font-family for the text
## in the image file to be generated.
#######################################################

FONTFAM=""

FONTFAM=$(zenity --entry --title "Enter FONT FAMILY name." \
   --text "\
Enter the FONT FAMILY name for the text in the image.

Example: Arial" \
   --entry-text "Arial")

if test "$FONTFAM" = ""
then
    exit
fi


#######################################################
## Prompt for the pointsize for the text
## in the image file to be generated.
#######################################################

POINTSIZE=""

POINTSIZE=$(zenity --entry --title "Enter POINT SIZE for the font." \
   --text "\
Enter the POINT SIZE for the font, for the text in the image.

Example: 72" \
   --entry-text "72")

if test "$POINTSIZE" = ""
then
    exit
fi



#######################################################
## Prompt for the size (XXXxYYY) of the image file to be
## generated.
#######################################################

IMGSIZE=""

IMGSIZE=$(zenity --entry --title "Enter IMAGE SIZE, XXXxYYY." \
        --text "\
Enter the image size (WIDTHxHEIGHT), in pixels,
for the TEXT-STRING image file to be generated.

Example: 640x480

The image filename will start with 'TEXT-IMAGE' and will
be placed in the current directory:

$CURDIR

or in /tmp if you do not have write permission to the
current directory." \
   --entry-text "640x480")

if test "$IMGSIZE" = ""
then
   exit
fi


##########################################################
## Prompt for the background color.
##########################################################

BKGDCOLOR=""

BKGDCOLOR=$(zenity --entry --title "Enter a background COLOR." \
        --text "\
Enter a color. (Transparency is possible.) Examples:

#000000   OR   black   OR   rgb(0,0,0)
#ffffff   OR   white   OR   rgb(255,255,255)   OR   rgb(100%,100%,100%)

#ff0000   OR   red   OR   rgb(255, 0, 0)   OR   rgb(100%, 0%, 0%)
          OR   rgba(255, 0, 0, 1.0)   OR   rgba(100%, 0%, 0%, 0.5)

#00ff00   OR   green  OR   rgb(0,255,0)
#0000ff   OR   blue  OR   rgb(0,0,255)
#ffff00   OR   yellow  OR   rgb(255,255,0)

tomato
LightSteelBlue

#808080   OR   gray   OR    gray(50%)   OR   graya(50%, 0.5)
gray0  to  gray100

transparent   OR   none   OR   rgba( 0, 0, 0, 0.0)" \
   --entry-text "#000000")

if test "$BKGDCOLOR" = ""
then
    exit
fi


##########################################################
## Prompt for the text color.
##########################################################

TEXTCOLOR=""

TEXTCOLOR=$(zenity --entry --title "Enter a background COLOR." \
        --text "\
Enter a color. (Transparency is possible.) Examples:

#000000   OR   black   OR   rgb(0,0,0)
#ffffff   OR   white   OR   rgb(255,255,255)   OR   rgb(100%,100%,100%)

#ff0000   OR   red   OR   rgb(255, 0, 0)   OR   rgb(100%, 0%, 0%)
          OR   rgba(255, 0, 0, 1.0)   OR   rgba(100%, 0%, 0%, 0.5)

#00ff00   OR   green  OR   rgb(0,255,0)
#0000ff   OR   blue  OR   rgb(0,0,255)
#ffff00   OR   yellow  OR   rgb(255,255,0)

tomato
LightSteelBlue

#808080   OR   gray   OR    gray(50%)   OR   graya(50%, 0.5)
gray0  to  gray100

transparent   OR   none   OR   rgba( 0, 0, 0, 0.0)" \
   --entry-text "#ffff00")

if test "$TEXTCOLOR" = ""
then
    exit
fi


##################################################################
## Make full filename for the output text-image file.
##
## If the user has write-permission on the
## current directory, put the file in the pwd.
## Otherwise, put the file in /tmp.
##################################################################

CURDIR="`pwd`"

OUTFILE="TEXT-IMAGE_${TEXTCOLOR}on${BKGDCOLOR}_${IMGSIZE}.jpg"

if test ! -w "$CURDIR"
then
  OUTFILE="/tmp/$OUTFILE"
fi

if test -f "$OUTFILE"
then
  rm -f "$OUTFILE"
fi


########################################################
## Call 'convert' to make the text-image file.
########################################################

convert  -size $IMGSIZE  xc:$BKGDCOLOR \
         -font "$FONTFAM"  -pointsize $POINTSIZE \
         -gravity Center \
         -fill $TEXTCOLOR -annotate 0x0+0+0 "$TEXTSTRING" \
         "$OUTFILE"

##########################
## Show the new image file.
##########################

## . $HOME/.gnome2/nautilus-scripts/.set_VIEWERvars.shi

. $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
. $DIR_NautilusScripts/.set_VIEWERvars.shi

$IMGVIEWER "$OUTFILE" &

# $IMGEDITOR "$OUTFILE" &
