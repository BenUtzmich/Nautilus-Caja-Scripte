#!/bin/sh
##
## Nautilus
## SCRIPT: 00_anyfile_show_manHELP4topic_man-w-zcat-groff-col.sh
##
## PURPOSE: This script prompts the user for a command or topic name and
##          looks for man help for that name.
##
## METHOD:  Puts the 'man' help into a text file.
##
##          Shows the text file using a text-file viewer of the
##          user's choice.
##
## HOW TO USE: In the Nautilus file manager, right-click on ANY file in
##             ANY Nautilus directory list.
##             Then select this Nautilus script to run (name above).
##
## Created: 2010apr04
## Changed: 2010may17 Use $TXTVIEWER instead of 'gedit' to
##                    show/search/extract the text.
## Changed: 2011may02 Add $USER to the temp filename.
## Changed: 2011may11 Get 'nautilus-scripts' directory via an include script.
## Changed: 2011may23 Add a while loop, for multiple prompts. 
## Changed: 2012feb29 Changed the script name in the comment above.

## FOR TESTING: (show statements as they execute)
#  set -x

#####################################
## Prompt for the utility/topic name.
#####################################

while :
do

   UTIL_NAME=""

   UTIL_NAME=$(zenity --entry \
   --title "Show 'man' help for a name/utility." \
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
   ## Prep a temporary filename, to hold the manhelp text.
   ##      We put the outlist file in /tmp in case the user does
   ##      not have write-permission to the current directory
   ##      --- and because the manhelp often has nothing to do
   ##      with the current directory.
   ############################################################

   OUTFILE="/tmp/${USER}_manhelp4_${UTIL_NAME}.lis"
 
   if test -f "$OUTFILE"
   then
      rm -f "$OUTFILE"
   fi


   ##########################################
   ## Prepare a heading for the listing.
   ##########################################

  echo "\
man help for '$UTIL_NAME' :
##########################
" > "$OUTFILE"


   #########################################################
   ## Add the 'man' help to the listing.
   ## Use pipes 'zcat|groff|col' to format the man help text.
   #########################################################

   MANFILE=`man -w $UTIL_NAME`

   if test "$MANFILE" = ""
   then

       echo "***** man file for $UTIL_NAME not found. *****" >> "$OUTFILE"

   else

      # TERM="ansi-m"
      # export TERM

      ## On SGI-IRIX, 'pcat' with 'man -p' (and 'col' and 'ul') works.
      ##   CMD="pcat \`man -p $STRING | cut -d' ' -f2\` | col | ul -t dumb"

      ## On Mandriva 2007, 'groff -P -c' gets rid of color codes
      ## from the bz2-uncompressed man files.
      ## If '-P -c' stops working, use:   export GROFF_NO_SGR="yes"
      #   CMD="bzcat $MANFILE | /usr/bin/groff -t -Tascii -mandoc -P -c | col -b"

      ## On Ubuntu 2009 (9.10, Karmic), 'groff -P -c' gets rid of color codes
      ## from the gzip-uncompressed man files.
      ## If '-P -c' stops working, use:   export GROFF_NO_SGR="yes"
         zcat "$MANFILE" | /usr/bin/groff -t -Tascii -mandoc -P -c | col -b >> "$OUTFILE"

   fi
   ## END OF   if test "$MANFILE" = ""


   ########################
   ## Show the man help.
   ########################
   
   ## . $HOME/.gnome2/nautilus-scripts/.set_VIEWERvars.shi

   . $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
   . $DIR_NautilusScripts/.set_VIEWERvars.shi

   $TXTVIEWER "$OUTFILE" &

done
## END OF LOOP:  while :
