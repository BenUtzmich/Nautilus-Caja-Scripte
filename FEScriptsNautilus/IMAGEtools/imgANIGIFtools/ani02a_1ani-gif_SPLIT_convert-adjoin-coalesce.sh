#!/bin/sh
##
## Nautilus
## SCRIPT: ani02a_1ani-gif_SPLIT_convert-adjoin-coalesce.sh
##
## PURPOSE: Splits an animated '.gif' file into a sequence of
##          '.gif' files.
##
## METHOD:  Uses the ImageMagick 'convert +adjoin -coalesce' command.
##
##          Shows the resulting '.gif' image files in an image viewer
##          of the user's choice.
##
## Reference: http://www.imagemagick.org/Usage/anim_basics/#adjoin
##
## HOW TO USE: In Nautilus, select an animated '.gif' file.
##             Then right-click and choose this script to run (name above).
##
############################################################################
## Created: 2010mar08
## Changed: 2011may11 Get 'nautilus-scripts' directory via an include script.
## Changed: 2012may12 Changed script name in comments above and touched up
##                    the comments. Changed some indenting below.
###########################################################################


## FOR TESTING: (show statements as they execute)
# set -x

#########################################
## Get the filename of the selected file.
#########################################

# FILENAMES="$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS"
# FILENAMES="$@"
  FILENAME="$1"


#####################################################
## Check that the selected file is a 'gif' file.
## (Assumes one dot in filename, at the extension.)
##          (Assumes no spaces in filename.)
#####################################################

FILEEXT=`echo "$FILENAME" | cut -d\. -f2`
 
if test "$FILEEXT" != "gif"
then
   exit
fi


##################################################################
## Use 'convert' to make the several 'gif' files.
## Reference: http://www.imagemagick.org/Usage/anim_basics/#adjoin
##################################################################

FILENAMECROP=`echo "$FILENAME" | sed 's|\.gif$||'`

convert +adjoin -coalesce "$FILENAME" "${FILENAMECROP}%03d.gif"

#################################################################
## After editing or whatever, you can rejoin the files with
##   convert ${FILENAMECROP}???.gif  ${FILENAMECROP}_rebuilt.gif
#################################################################


####################################################
## Show the gif files split from the animated gif.
####################################################

## . $HOME/.gnome2/nautilus-scripts/.set_VIEWERvars.shi

. $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
. $DIR_NautilusScripts/.set_VIEWERvars.shi

 $IMGVIEWER  ${FILENAMECROP}001.gif &

# $IMGEDITOR  ${FILENAMECROP}*.gif &
