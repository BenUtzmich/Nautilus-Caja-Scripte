#!/bin/sh
##
## Nautilus
## SCRIPT: 04_anyfile_SHOW-PRINTER-OPTIONS_lpoptions-p.sh
##
## PURPOSE: For a user-selected printer id, the CUPS options
##          for the printer are shown, using the 'lpoptions'
##          command.
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
## HOW TO USE: In Nautilus, select ANY file in ANY directory.
##             Then right-click and choose this script to run
##             (name above).
##
########################################################################
## Created: 2012jun20
## Changed: 2012
#######################################################################

## FOR TESTING: (show statements as they execute)
# set -x

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
## Apply 'lpoptions' to the printer ID.
#########################################
## We run lpoptions in a terminal window,
## rather than using 'zenity --info',
## so that a large number of options
## can be seen.
############################################
## Alternatively, we could direct the output
## into a temporary text file and show it
## with $TXTVIEWER. This would give better
## readability and allow for readily 
## reformatting the text with sed or awk.
############################################

## FOR TESTING:
#   set -x

xterm -title "Output of 'lpoptions -p $PRTRid'" \
      -bg black -fg white -hold -geometry 80x20+0+25 \
      -sb -leftbar -sl 1000 \
      -e  lpoptions -p $PRTRid

## FOR TESTING:
#   set -
