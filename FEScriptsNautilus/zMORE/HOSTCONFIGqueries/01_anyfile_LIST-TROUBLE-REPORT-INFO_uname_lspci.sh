#!/bin/sh
##
## NAUTILUS
## SCRIPT: 00_anyfile_LIST-TROUBLE-REPORT-INFO_uname_lspci.sh
##
## PURPOSE: List the output of 'uname' and 'lspci'.
##
##          This is the kind of info required to report
##          hardware problems to 'outfits' like
##          Linux Format Magazine when posing help questions
##          for its 'Answers' section.
##
## METHOD:  Puts the output of 'uname' and 'lspci' in a text file and
##          shows the text file in a text-viewer of the user's choice.
##
## HOW TO USE: In Nautilus, select ANY file in ANY directory.
##             Then right-click and choose this script to run (name above).
##
#############################################################################
## Script
## Created: 2010apr04
## Changed: 2011may02 Added $USER to a temp filename.
## Changed: 2011may11 Get 'nautilus-scripts' directory via an include script.
## Changed: 2012apr18 Changed script name in comments above and touched up
##                    the comments. Changed some indenting below.
#######################################################################

## FOR TESTING: (show statements as they execute)
#  set -x

##################################################################
## Prep a temporary filename, to hold the list of filenames.
##      We put the outlist file in /tmp, in case the user
##      does not have write-permission in the current directory,
##      and because the output does not, usually, have anything
##      to do with the current directory.
##################################################################

OUTLIST="/tmp/${USER}_list_uname_lspci.lis"
 
if test -f "$OUTLIST"
then
   rm -f "$OUTLIST"
fi


###############################
## Make the HEADER for the list.
###############################

THISHOST=`hostname`

echo "\
................ `date '+%Y %b %d  %a  %T%p %Z'` ......................

'uname' and 'lspci' info
--- for host:  $THISHOST


Some more information is at the bottom of this list.

------------------------------------------------------------------------------
" > "$OUTLIST"


############################################################
## Use 'uname' and 'lspci' to make the main part of the list.
############################################################

   echo "
#####
uname -a :
#####
" >> $OUTLIST
   uname -a >> "$OUTLIST"


   echo "
#####
lspci :
#####
" >> $OUTLIST
   lspci >> "$OUTLIST"


   echo "
#########
lspci -vv :
#########
" >> $OUTLIST
   lspci -vv >> "$OUTLIST"


#################################
## Make the TRAILER for the list.
#################################

SCRIPT_BASENAME=`basename $0`
SCRIPT_DIRNAME=`dirname $0`

echo "
------------------------------------------------------------------------------

  The list above was generated by the script

$SCRIPT_BASENAME

  in directory

$SCRIPT_DIRNAME


  If you want to add more host config info via more commands (like lsusb),
  you can simply edit the script.

------------------------------------------------------------------------------
FOR MORE INFO ON THESE EXECUTABLES:

For some of these topics (or commands like 'lspci' and 'uname'),
you can type 'man <topic-name>' to see details on the topic.
   ('man' stands for Manual.  It gives you a user manual
     for the command/utility/protocol/topic.)

You can type 'man man' at a shell prompt to see a description of
the 'man' command.

Or use the 'show_manhelp_4topic' Nautilus script in the
'LinuxHELPS' group of Nautilus scripts.


******* END OF LIST of 'uname' and 'lspci' on host $THISHOST *******
" >> "$OUTLIST"


###############################
## Show the listing.
###############################

## . $HOME/.gnome2/nautilus-scripts/.set_VIEWERvars.shi

. $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
. $DIR_NautilusScripts/.set_VIEWERvars.shi

$TXTVIEWER  "$OUTLIST"
