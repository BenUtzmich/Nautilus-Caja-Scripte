#!/bin/sh
##
## Nautilus
## SCRIPT: ani05_1ani-gif_RESIZE_XXXxYYYinput_convert-twice.sh
##
## PURPOSE: Resizes an animated '.gif' file.
##
## METHOD:  Uses ImageMagick 'convert +adjoin -coalesce' to break
##          up the animated gif file into separate '.gif' files.
##
##          Prompts the user for an inter-image delay time (in
##          hundredths of seconds) for the new animated '.gif' file.
##
##          Prompts the user for the x-y pixel size for the new file.
##
##          Uses ImageMagick 'convert' with '-resize', '-delay', and
##          '-loop 0' parms to make the new animated gif file.
##
##          Shows the new animated '.gif' file in an animated gif file
##          viewer of the user's choice.
##
## Reference: http://www.imagemagick.org/Usage/anim_basics/#coalesce
##
## HOW TO USE: In Nautilus, select one animated '.gif' file.
##             Then right-click and choose this script to run (name above).
##
############################################################################
## Created: 2010apr01
## Changed: 2011may11 Get 'nautilus-scripts' directory via an include script.
## Changed: 2012may12 Changed script name in comments above and touched up
##                    the comments. Changed some indenting below.
###########################################################################


## FOR TESTING: (show statements as they execute)
# set -x

################################################
## Get the filename of the animated '.gif' file.
################################################

# FILENAMES="$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS"
# FILENAMES="$@"
  FILENAME="$1"


#########################################################
## Check that the selected file is a 'gif' file.
## Assumes one dot (.) in the filename, at the extension.
#########################################################

FILEEXT=`echo "$FILENAME" | cut -d\. -f2`
 
if test "$FILEEXT" != "gif"
then
   exit
fi


##############################################################################
## Use 'convert +adjoin' (with '-coalesce') to extract the several 'gif' files.
## Reference: http://www.imagemagick.org/Usage/anim_basics/#coalesce
##############################################################################

FILENAMECROP=`echo "$FILENAME" | sed 's|\.gif$||'`

convert +adjoin -coalesce "$FILENAME" "${FILENAMECROP}%03d.gif"


###########################################################################
## Set the delay time between frames of the (reconstituted) animation ---
## in 100ths of a second. Example: 250 = 2.5 seconds.
###########################################################################

DELAY100s=""

DELAY100s=$(zenity --entry \
--text "\
Enter delay-time in 100ths of seconds:
      Example: 250 gives 2.5 seconds" \
   --entry-text "250")

if test "$DELAY100s" = ""
then
   exit
fi


###############################################
## Set the new image size for the animated gif.
###############################################

SIZEXY=""

SIZEXY=$(zenity --entry \
--text "\
Enter the X by Y size for the animation :
      Example: 320x240 for 320 pixels wide by 240 pixels high" \
   --entry-text "320x240")

if test "$SIZEXY" = ""
then
   exit
fi


###########################################################################
## Use 'convert' to make the animated gif file
## with the '-resize' parameter, to do the resizing.
## Reference: http://www.imagemagick.org/Usage/anim_mods/#resize_problems
##
## NOTE: It might be better to avoid the '-resize' parameter, per
##       the warnings in the documentation referenced. An alternative
##       is to resize the individual extracted gif files with 'convert -size'
##       then put them together with the command below, without the
##       '-resize' parameter.
##
##       With any method, if you resize to a LARGER size, the resulting
##       animation is probably going to be blurrier than the original
##       animation.
###########################################################################

FILEOUT="${FILENAMECROP}_${SIZEXY}_ani.gif"

convert -delay $DELAY100s -loop 0 -resize $SIZEXY \
         ${FILENAMECROP}*.gif "$FILEOUT"


############################################
## Show the new, resized animated gif file.
############################################

## . $HOME/.gnome2/nautilus-scripts/.set_VIEWERvars.shi

. $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
. $DIR_NautilusScripts/.set_VIEWERvars.shi

$ANIGIFVIEWER "$FILEOUT" &
   