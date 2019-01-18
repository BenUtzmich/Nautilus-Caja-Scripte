#!/bin/sh
##
## Nautilus
## SCRIPT: 00_anyfile_show_infoHELP4topic_info-coreutils.sh
##
## PURPOSE: This script prompts the user for a command or topic name and
##          looks for 'Texinfo manual' help for that name.
##
## METHOD:  Puts the 'Texinfo' help into a text file.
##
##          Shows the text file using a text-file viewer of the
##          user's choice.
##
## HOW TO USE: In the Nautilus file manager, right-click on ANY file in
##             ANY Nautilus directory list.
##             Then select this Nautilus script to run (name above).
##
## Created: 2012apr07
## Changed: 2012

## FOR TESTING: (show statements as they execute)
#  set -x

#####################################
## Prompt for the utility/topic name.
#####################################

while :
do

   UTIL_NAME=""

   UTIL_NAME=$(zenity --entry \
   --title "Show 'Texinfo' help for a name/utility." \
   --text "\
Enter a name.  Examples:
   ls  OR  grep  OR  sed  OR  cut  OR  tr  OR  awk  OR  bash  OR  X OR
   find  OR  gnome-terminal  OR  xterm  OR  convert  OR  identify  OR
   mplayer  OR  vlc  OR  df  OR  du  OR  ps  OR  ifconfig  OR  netstat" \
   --entry-text "ls")

   if test "$UTIL_NAME" = ""
   then
      exit
   fi


   ############################################################
   ## Prep a temporary filename, to hold the Texinfo help text.
   ##      We put the outlist file in /tmp in case the user does
   ##      not have write-permission to the current directory
   ##      --- and because the help often has nothing to do
   ##      with the current directory.
   ############################################################

   OUTFILE="/tmp/${USER}_texinfo_help4_${UTIL_NAME}.lis"
 
   if test -f "$OUTFILE"
   then
      rm -f "$OUTFILE"
   fi


   ##########################################
   ## Prepare a heading for the listing.
   ##########################################

  echo "\
Texinfo help for '$UTIL_NAME' :
##############################
" > "$OUTFILE"


   #########################################################
   ## Add the 'texinfo' help to the listing.
   #########################################################

   info coreutils "$UTIL_NAME invocation" >> "$OUTFILE"


   ########################
   ## Show the texinfo help.
   ########################
   
   ## . $HOME/.gnome2/nautilus-scripts/.set_VIEWERvars.shi

   . $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
   . $DIR_NautilusScripts/.set_VIEWERvars.shi

   $TXTVIEWER "$OUTFILE" &

done
## END OF LOOP:  while :
