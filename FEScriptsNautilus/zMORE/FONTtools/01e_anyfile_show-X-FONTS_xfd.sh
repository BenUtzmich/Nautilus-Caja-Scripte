#!/bin/sh
##
## Nautilus
## SCRIPT: 01e_anyfile_show_X-FONTS_xfd.sh
##
## PURPOSE: Shows a list of X fontnames. The user selects one and
##          then the characters of the font are shown by 'xfd'.
##
## METHOD:  Uses 'zenity' to show a list of font FAMILY names to
##          choose from. Uses 'zenity' again to show a list of
##          X-fontnames within the selected family.
##
## HOW TO USE: In Nautilus, select ANY file in ANY directory.
##             Then right-click and choose this script to run (name above).
##
##########################################################################
## Script
## Created: 2010may30
## Changed: 2012apr18 Changed script name in comments above and touched up
##                    the comments. Changed some indenting below.
#######################################################################

## FOR TESTING: (show statements as they execute)
#  set -x


##################################
## Start looping thru font prompts
## until the user 'Cancels' out.
##################################

while :
do

   ###########################################################
   ## Use 'zenity' to show a list of font FAMILY names to
   ## choose from.
   ###########################################################

   FONTFAM=`xlsfonts -fn '-*-*-*-*-*-*-*-*-*-*-*-*-*-*' | \
      cut -d'-' -f3 | sort  -u | \
      zenity --list  --width 600 --height 400 \
         --title  "Choose an X font FAMILY." \
         --text "List of X font FAMILY names. 'Cancel' to exit." \
         --column "X font families"`

   if test "$FONTFAM" = ""
   then
      exit
   fi

   ###########################################################
   ## Use 'zenity' to show a list of fontnames to choose from.
   ##
   ##    To reduce the size of the list,
   ##    we leave out the ones ending in '-2' thru '-11' and
   ##    '-13' thru '-16'. See 'man ISO-8859-1'
   ###########################################################

   FONTNAME=`eval xlsfonts -fn \'-*-$FONTFAM-*-*-*-*-*-*-*-*-*-*-*-*\' | \
      egrep -v '\-2$|\-3$|\-4$|\-5$|\-6$|\-7$|\-8$|\-9$|\-10$|\-11$|\-13$|\-14$|\-15$|\-16$' \
      | zenity --list  --width 600 --height 400 \
               --title  "Choose an X font to display." \
               --text "List of X fontnames." \
               --column "Xfonts"`

   if test "$FONTNAME" = ""
   then
      exit
   fi

   ######################################
   ## Run 'xfd' on the selected fontname.
   ######################################

   XFD_MSG=`xfd -fn "$FONTNAME" 2>&1`

   ######################################
   ## If there seems to be an error,
   ## use 'zenity' to show the msg.
   ######################################

   if test ! "$XFD_MSG" = ""
   then
      zenity --info --title "Message from 'xfd'." \
            --text "\
$XFD_MSG"
   fi

done
## END of 'while' loop
