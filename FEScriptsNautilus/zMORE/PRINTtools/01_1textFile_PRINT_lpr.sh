#!/bin/sh
##
## Nautilus
## SCRIPT: 00_1textFile_PRINT_lpr.sh
##
## PURPOSE: For the user-selected file, the filename is
##          passed to an lpr -P<printerID>,
##          where printerID is prompted for via 'zenity'.
##
## METHOD: 'zenity' is used to prompt for a printer ID.
##
##         You can edit this script to change/add printer ID's.
##
##         (Someday, we may use a command like
##                 lpstat -a|cut -d" " -f1
##          to get the printer ID's and formulate the 'zenity'
##          radiolist command, automatically.)
##
## HOW TO USE: In Nautilus, select one (text) file. Then right-click and
##             choose this script to run it (name above).
##
########################################################################
## Created: 2010sep16
## Changed: 2012may11 Changed script name in comments above and touched up
##                    the comments. Changed some indenting below.
## Changed: 2012jun20 Added the name of this script to the zenity text.
#######################################################################

## FOR TESTING: (show statements as they execute)
# set -x

#################################
## Get the filename(s).
#################################
#  FILENAMES="$@"
#  FILENAMES="$NAUTILUS_SCRIPT_SELECTED_URIS"
FILENAME="$1"

########################################
## zenity prompt for printerID
########################################

SCRIPT_BASENAME=`basename $0`
SCRIPT_DIRNAME=`dirname $0`

## Alternative by radiobuttons
PRTRid=""

PRTRid=`zenity --list --radiolist \
   --title "Printer ID?" \
   --text "\
Choose a printer ID.

(You can edit this script to change or add printers.
 The script is
          $SCRIPT_BASENAME
 in
   $SCRIPT_DIRNAME.)
" \
   --column "Pick1" --column "Printer ID" \
   NO hpPSC1300HPLIP NO lp1`
 
if test "$PRTRid" = ""
then
   exit
fi


#########################################
## Apply 'lpr' to the filename.
#########################################
## We run lpr in a terminal window,
## so that messages from lpr will be seen.
########################################

## FOR TESTING:
#   set -x

xterm -title "Print to printer $PRTRid - lpr msgs, if any." \
      -bg black -fg white -hold -geometry 80x20+0+25 \
      -sb -leftbar -sl 1000 \
      -e  lpr -P$PRTRid "$FILENAME"

## FOR TESTING:
#   set -
