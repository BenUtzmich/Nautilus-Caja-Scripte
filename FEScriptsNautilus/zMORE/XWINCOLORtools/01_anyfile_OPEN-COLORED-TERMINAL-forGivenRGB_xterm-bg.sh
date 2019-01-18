#!/bin/sh
##
## Nautilus
## SCRIPT: 00_anyfile_SHOW_COLORED-WINDOW_forGivenRGB_xterm-bg.sh
##
## PURPOSE: Prompts the user for a triplet of RGB values
##          (between 0 and 255). Shows the RGB color by using
##          the background of an xterm.
##
## METHOD:  This script uses a 'zenity' prompt for the RGB triplet.
##
## HOW TO USE: In Nautilus, select ANY file in ANY directory.
##             Then right-click and choose this script to run (name above).
##
###########################################################################
## Created: 2010may30
## Changed: 2012may12 Changed script name in comments above and touched up
##                    the comments. Changed some indenting below.
#######################################################################

## FOR TESTING: (show statements as they execute)
# set -x

####################################
## Start a prompting loop.
## The user clicks 'Cancel' to exit.
####################################

MSG="NOTE: You can exit this prompting loop by clicking 'Cancel'."
RGB255="210 153 78"

# while true
while :
do

   #################################
   ## Prompt for the RGB triplet.
   #################################

   RGB255=""

   RGB255=$(zenity --entry \
           --title "Enter 3 RGB values --- 0 to 255." \
           --text "\
$MSG

Enter 3 Red-Green-Blue values, each value between
0 and 255, inclusive. OR, click 'Cancel' to exit.

  The 3 values will be converted to hexadecimal format and
  will be used to display an xterm window with the background
  color determined by the RGB values specified.

  Close the xterm window to return to this prompt." \
           --entry-text "$RGB255")

   if test "$RGB255" = ""
   then
      exit
   fi

   NUMCHK=`echo -n "$RGB255" | sed 's|[0-9]||g' | sed 's| ||g'`

   if test ! "$NUMCHK" = ""
   then
      MSG="*** Entry must be numeric or spaces. ***"
      continue
   fi

   NUMWORDS=`echo "$RGB255" | wc -w`

   if test ! "$NUMWORDS" = 3
   then
      MSG="*** More or less than 3 values were entered. ***"
      continue
   fi

   ## FOR TESTING: (show statements as they execute)
   #   set -x

   R255=`echo "$RGB255" | awk '{print $1}'`
   G255=`echo "$RGB255" | awk '{print $2}'`
   B255=`echo "$RGB255" | awk '{print $3}'`

   ## FOR TESTING: (turn off display of executing statements)
   #   set -

   if test "$R255" -gt 255 -o "$R255" -lt 0
   then
      MSG="*** The RED value was out of range. ***"
      continue
   fi

   if test "$G255" -gt 255 -o "$G255" -lt 0
   then
      MSG="*** The GREEN value was out of range. ***"
      continue
   fi

   if test "$B255" -gt 255 -o "$B255" -lt 0
   then
      MSG="*** The BLUE value was out of range. ***"
      continue
   fi

   ## FOR TESTING: (show statements as they execute)
   #    set -x

   ## There is, no doubt, a more efficient way to add the leading zero
   ## than with using 'awk' and 'tr'.
   RHEX=`echo "obase = 16 ; $R255" | bc | awk '{printf ("%2s", $1)}' | tr ' ' '0'`
   GHEX=`echo "obase = 16 ; $G255" | bc | awk '{printf ("%2s", $1)}' | tr ' ' '0'`
   BHEX=`echo "obase = 16 ; $B255" | bc | awk '{printf ("%2s", $1)}' | tr ' ' '0'`

   ## FOR TESTING: (show statements as they execute)
   #     set -x

   HEXSTRING="${RHEX}${GHEX}$BHEX"

   xterm -bg "#$HEXSTRING" -hold -e echo "Hex string used: $HEXSTRING
For RGB values: $RGB255"

   ## FOR TESTING: (turn off display of executing statements)
   #    set -

   MSG="NOTE: You can exit this prompting loop by clicking 'Cancel'."

done
## END of 'while' loop
