#!/bin/sh
##
## Nautilus
## SCRIPT: 00_anyfile_SHOW-CD-DVD-DRIVES_wodim-checkdrive.sh
##
## PURPOSE: Shows CD or DVD drives connected to the computer.
##          (Note: Has been known not to show all of them.)
##
## METHOD:  Puts the output of 'wodim' in a text file.
##
##          This script shows the text file using a textfile-viewer of
##          the user's choice.
##
## HOW TO USE: In Nautilus, select ANY file in ANY directory.
##             Then right-click and choose this script to run (name above).
##
## REFERENCE: https://wiki.archlinux.org/index.php/CD_Burning#Burning_an_ISO_image
##
############################################################################
## Created: 2013apr20
## Changed: 2013
#######################################################################

## FOR TESTING: (show statements as they execute)
#  set -x

################################################################
## Prep a temporary filename, to hold the list of drives info.
##
##      We put the outlist file in /tmp, in case the user
##      does not have write-permission in the current directory,
##      and because the output does not, usually, have anything
##      to do with the current directory.
################################################################

OUTLIST="${USER}_list_CD-DVD_drives.lis"

OUTLIST="/tmp/$OUTLIST"
 
if test -f "$OUTLIST"
then
   rm -f "$OUTLIST"
fi


##################################
## Make a HEADER for the list.
##################################

THISHOST=`hostname`

echo "\
................ `date '+%Y %b %d  %a  %T%p %Z'` ......................

CD/DVD drives detected by 'wodim -checkdrive'

--- for host:  $THISHOST

NOTE: This command may not detect ALL of the CD/DVD drives.

Some more information is at the bottom of this list.

------------------------------------------------------------------------------
" > "$OUTLIST"


##################################
## Make the list with 'wodim'.
##################################

EXECHECK=`which wodim`

if test -f "$EXECHECK"
then

   echo "
##########################
'wodim -checkdrive' output :
##########################
" >> "$OUTLIST"

   wodim -checkdrive  >> "$OUTLIST"

else  
   echo "
The program 'wodim' does not seem to be available.
" >> "$OUTLIST"
fi


##################################
## Make a TRAILER for the list.
##################################

SCRIPT_DIRNAME=`dirname $0`
SCRIPT_BASENAME=`basename $0`

echo "
------------------------------------------------------------------------------

  The list above was generated by the script

$SCRIPT_BASENAME

  in directory

$SCRIPT_DIRNAME

  using 'wodim -checkdrive'.

  If you want to change the presentation format or options on 'wodim',
  you can simply edit the script.

------------------------------------------------------------------------------
FOR MORE INFO:

For more info the executables used,
you can type 'man <exe-name>' to see details on how the program
can be used.  ('man' stands for Manual.  It gives you the user
manual for the command/utility.)

You can type 'man man' at a shell prompt to see a description of
the 'man' command.

Or use the 'SHOW-man-HELP' Nautilus script in the
'LinuxHELPS' group of FE Nautilus scripts.


******* END OF LIST of CD/DVD drives and their properties, on host $THISHOST *******
" >> "$OUTLIST"


###################################
## Show the listing.
###################################

## . $HOME/.gnome2/nautilus-scripts/.set_VIEWERvars.shi

. $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
. $DIR_NautilusScripts/.set_VIEWERvars.shi

$TXTVIEWER  "$OUTLIST"
