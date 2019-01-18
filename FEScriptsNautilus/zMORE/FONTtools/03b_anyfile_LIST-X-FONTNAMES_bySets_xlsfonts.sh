#!/bin/sh
##
## NAUTILUS
## SCRIPT: 03b_anyfile_LIST-X-FONTNAMES_bySets_xlsfonts.sh
##
## PURPOSE: List X server fonts --- either all or --- or list
##          various subsets (is8859-1 or 100x100 or 75x75 or  0x0).
##
## METHOD:  The subset options are presented via a 'zenity' prompt.
##
##          The listing is generated using 'xlsfonts'.
##
##          The list file is shown with a text-viewer of the user's choice.
##
## HOW TO USE: In Nautilus, select ANY file in ANY directory.
##             Then right-click and choose this script to run (name above).
##
#############################################################################
## Script
## Created: 2010may30
## Changed: 2011may02 Added $USER to a temp filename.
## Changed: 2011may11 Get 'nautilus-scripts' directory via an include script.
## Changed: 2012apr18 Changed script name in comments above and touched up
##                    the comments. Changed some indenting below.
############################################################################

## FOR TESTING: (show statements as they execute)
#  set -x


#######################################################
## Prompt for the type of Xfonts list to make.
#######################################################
##     - all
##     - is8859-1
##     - 100x100
##     - 75x75
##     - 0x0
#######################################################

 LISTYPE=""

 LISTYPE=`zenity --list --radiolist \
   --title "Type of Xfonts list to make?" \
   --text "Choose one of the following types of Xfont lists:" \
   --column "" --column "Type" \
      TRUE all \
      FALSE iso8859-1 \
      FALSE 100x100 \
      FALSE 75x75 \
      FALSE 0x0`

if test "$LISTYPE" = ""
then
   exit
fi


###############################################################
## Prep a temporary filename, to hold the list of font names.
##      We put the outlist file in /tmp, in case the user
##      does not have write-permission in the current directory,
##      and because the output does not, usually, have anything
##      to do with the current directory.
###############################################################

OUTLIST="${USER}_list_xlsfonts.lis"

OUTLIST="/tmp/$OUTLIST"
 
if test -f "$OUTLIST"
then
   rm -f "$OUTLIST"
fi


########################################
## Load the vars FONTMASK and LISTTITLE.
########################################

if test "$LISTYPE" = "all"
then
   FONTMASK="'-*-*-*-*-*-*-*-*-*-*-*-*-*-*'"
   LISTTITLE=""
fi

if test "$LISTYPE" = "iso8859-1"
then
   FONTMASK="'-*-*-*-*-*-*-*-*-*-*-*-*-iso8859-1'"
   LISTTITLE="with iso8859-1 for 'registry' and 'encoding'"
fi

if test "$LISTYPE" = "100x100"
then
   FONTMASK="'-*-*-*-*-*-*-*-*-100-100-*-*-*-*'"
   LISTTITLE="designed for 100x100 pixels/inch display"
fi

if test "$LISTYPE" = "75x75"
then
   FONTMASK="'-*-*-*-*-*-*-*-*-75-75-*-*-*-*'"
   LISTTITLE="designed for 75x75 pixels/inch display"
fi

if test "$LISTYPE" = "0x0"
then
   FONTMASK="'-*-*-*-*-*-*-*-*-0-0-*-*-*-*'"
   LISTTITLE="whose fontname contains '-0-0-' at the Xres and Yres positions"
fi


####################################
## Make the header for the list.
####################################

THISHOST=`hostname`

echo "\
................ `date '+%Y %b %d  %a  %T%p %Z'` ......................

X server fonts $LISTTITLE

--- for host:  $THISHOST


Some more information is at the bottom of this list.

------------------------------------------------------------------------------
" > "$OUTLIST"


####################################
## Use 'xlsfonts' to make the list.
####################################

EXECHECK=`which xlsfonts`

if test -f "$EXECHECK"
then

   echo "
########
xlsfonts -fn $FONTMASK :
########
" >> "$OUTLIST"

#  xlsfonts >> "$OUTLIST"

   eval xlsfonts -fn $FONTMASK >> "$OUTLIST"

else

   echo "
The command 'xlsfonts' does not seem to be available.
" >> "$OUTLIST"

fi


####################################
## Add a trailer to the list.
####################################

SCRIPT_DIRNAME=`dirname $0`
SCRIPT_BASENAME=`basename $0`

echo "
................ `date '+%Y %b %d  %a  %T%p %Z'` ......................

  The list above was generated by the script

$SCRIPT_BASENAME

  in the directory

$SCRIPT_DIRNAME

  If you want to change the presentation or add more font info,
  you can simply edit the script to change or enhance it.

------------------------------------------------------------------------------
FOR MORE INFO ON THESE EXECUTABLES:

For help on a topic, such as the command 'xlsfonts',
you can type 'man <topic-name>' to see details on the topic.
    ('man' stands for Manual.  It gives you a user manual 
     for a topic: command or utility or protocol or subsystem.)

You can type 'man man' at a shell prompt to see a description of
the 'man' command.

Or use the 'show_manhelp_4topic' Nautilus script in the
'LinuxHELPS' group of Nautilus scripts.


******* END OF LIST of X fonts on host $THISHOST *******
" >> "$OUTLIST"


###################################
## Show the listing.
###################################

## . $HOME/.gnome2/nautilus-scripts/.set_VIEWERvars.shi

. $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
. $DIR_NautilusScripts/.set_VIEWERvars.shi

$TXTVIEWER "$OUTLIST"