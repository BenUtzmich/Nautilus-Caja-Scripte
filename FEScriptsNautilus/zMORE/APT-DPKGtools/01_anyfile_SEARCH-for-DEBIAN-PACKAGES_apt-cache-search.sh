#!/bin/sh
##
## Nautilus
## SCRIPT: 01_anyfile_SEARCH-for-DEBIAN-PACKAGES_apt-cache-search.sh
##
## PURPOSE: This script prompts the user for a 'keyword' and
##          looks for debian packages whose names contain that keyword.
##
## METHOD:  Uses 'zenity --entry' to prompt for the keyword.
##
##          Puts the 'apt-cache search' output into a text file.
##
##          Shows the text file using a text-file viewer of the
##          user's choice.
##
## HOW TO USE: In the Nautilus file manager, right-click on ANY file in
##             ANY directory.
##             Then select this Nautilus script to run (name above).
##
############################################################################
## Created: 2012jul28
## Changed: 2012
############################################################################

## FOR TESTING: (show statements as they execute)
#  set -x

#####################################
## Prompt for the 'keyword'.
#####################################

# while true
while :
do

   KEYSTRING=""

   KEYSTRING=$(zenity --entry \
   --title "Show Debian packages for a 'key string'." \
   --text "\
Enter a 'key string'.  Examples:
   font   OR   image   OR   audio   OR   video   OR   gstreamer  OR
   restricted  OR   media   OR   edit   OR   pdf   OR   print   OR
   scan   OR   mail   OR   ftp   OR   config   OR   lib   OR   net" \
   --entry-text "media")

   if test "$KEYSTRING" = ""
   then
      exit
   fi


   ############################################################
   ## Prep a temporary filename, to hold the command output.
   ##      We put the outlist file in /tmp in case the user does
   ##      not have write-permission to the current directory
   ##      --- and because the output often has nothing to do
   ##      with the current directory.
   ############################################################

   OUTFILE="/tmp/${USER}_apt-cache_search_${KEYSTRING}.lis"
 
   if test -f "$OUTFILE"
   then
      rm -f "$OUTFILE"
   fi


   ##########################################
   ## Prepare a heading for the listing.
   ##########################################

  echo "\
OUTPUT of 'apt-cache search $KEYSTRING' :
########################################
" > "$OUTFILE"


   #########################################################
   ## Add the 'apt-cache search' output to the listing.
   #########################################################

   apt-cache search "$KEYSTRING" >> "$OUTFILE"


   ########################
   ## Show the man help.
   ########################
   
   ## . $HOME/.gnome2/nautilus-scripts/.set_VIEWERvars.shi

   . $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
   . $DIR_NautilusScripts/.set_VIEWERvars.shi

   $TXTVIEWER "$OUTFILE" &

done
## END OF LOOP:  while :
