#!/bin/sh
##
## NAUTILUS
## SCRIPT: 00_anyfile_LIST-GNOME-CONFIG-DB-KEYS_gconftool.sh
##
## PURPOSE: Shows the output of 'gconftool -R <base>' where <base>
##          is specified by the user. Choices are:
##             - apps
##             - desktop
##             - schemas
##             - system
##
## METHOD:  A 'zenity -list -radiolist' prompt is used to get the
##          'base' of the query.
##
##          The output is put in a text file and the file is shown
##          in a text-viewer of the user's choice.
##
## HOW TO USE: In Nautilus, select ANY file in ANY directory.
##             Then right-click and choose this script to run (name above).
##
##########################################################################
## Script
## Created: 2012aug20
## Changed: 2012
#######################################################################

## FOR TESTING: (show statements as they execute)
#  set -x


############################################################
## zenity prompt for the 'base' of the 'gconftool -R' query.
############################################################

while :
do

   BASEPATH=""

   BASEPATH=$(zenity --list --radiolist \
      --title "Choose the base (root) for this Gnome config query." \
      --height 400 \
      --text "\
Choose a 'base-path' for this 'gconftool -R' query --- which shows
the Gnome configuration-database keys for a given 'base-path'.

  (The listings for /apps and /schemas are quite long.
   You can edit this script to add pathnames, such as /apps/eog ---
   to see Gnome configuration-database keys for only the
   'Eye of Gnome' image viewer-printer utility.)" \
      --column "Pick1" --column "Directory (folder)" \
      NO /apps \
      NO /desktop \
      NO /schemas \
      NO /system \
      NO /apps/nautilus \
   )
 
   if test "$BASEPATH" = ""
   then
      exit
   fi


   ##################################################################
   ## Prep a temporary filename, to hold the 'gconftool -R' output.
   ##      We put the outlist file in /tmp, in case the user
   ##      does not have write-permission in the current directory,
   ##      and because the output does not, usually, have anything
   ##      to do with the current directory.
   ##################################################################

   OUTLIST="/tmp/${USER}_list_gconftools_vars.lis"
 
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

GNOME CONFIGURATION - DATABASE KEYS (and their values) - for path $BASEPATH
--- for host:  $THISHOST

     This output is generated by the command 'gconftool -R $BASEPATH'.

     Some more information is at the bottom of this list.

------------------------------------------------------------------------------
" > "$OUTLIST"


   #################################################################
   ## Add the 'gconftool -R' output to the list.
   #################################################################

   gconftool -R $BASEPATH >> "$OUTLIST"


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


  If you want to add more 'base-paths' for 'gconftool -R',
  you can simply edit the script.

------------------------------------------------------------------------------

The 'gconftool' command can be used to script changes to the Gnome
configuration database.  In particular ...


Get the attribute type of a specific key using the -T (type) option. Example:

   gconftool -T /apps/nautilus/preferences/enable_delete


Get the value of a specific key using the -g (get) option. Example:

   gconftool -g /apps/nautilus/preferences/enable_delete


Set the value of a specific key using the -s (set) option. Example:

   gconftool -t bool -s /apps/nautilus/preferences/enable_delete true


Furthermore, you can query and change database keys interactively with
'gconf-editor'.

------------------------------------------------------------------------------
FOR MORE INFO ON THESE EXECUTABLES:

For some of these topics (or commands like 'gconftool' and 'gconf-editor'),
you can type 'man <topic-name>' to see details on the topic.
   ('man' stands for Manual.  It gives you a user manual
     for the command/utility/protocol/topic.)

You can type 'man man' at a shell prompt to see a description of
the 'man' command.

Or use the 'show_manhelp_4topic' Nautilus script in the
'LinuxHELPS' group of Nautilus scripts.


******* END OF LIST of 'mount' output on host $THISHOST *******
" >> "$OUTLIST"


   ###############################
   ## Show the listing.
   ###############################

   ## . $HOME/.gnome2/nautilus-scripts/.set_VIEWERvars.shi

   . $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
   . $DIR_NautilusScripts/.set_VIEWERvars.shi

   $TXTVIEWER  "$OUTLIST"

done
## END of while prompting loop.