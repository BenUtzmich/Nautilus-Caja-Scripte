#!/bin/sh
##    
## Nautilus                        
## SCRIPT: 03_anyfile4Dir_findSTRorSTR_in_TEXTFILS_allLEVS_find-f-file-egrep-i.sh
##                            
## PURPOSE: For all TEXT files, at all levels under the current directory,
##          this script lists the lines in those files that contain a
##          user-specified string (or strings) --- using 'find' for the
##          directory tree navigation, 'file' to determine the text files,
##          and 'egrep' to find lines containing the user-specified string(s).
##
## METHOD:  A 'zenity --entry' prompt is used to get the search string(s) from
##          the user.
##
##          This 'wrapper' script starts a utility script
##               '.findSTRorSTR_in_dirTEXTFILS_recursive.sh'
##          that is in this same scripts directory.
##          The utility script uses the 'find', 'file' and 'egrep' commands
##          as indicated above.
##
##          The user is given the option to conduct the search
##          in an 'xterm' --- so that the utility script can
##          show progress indicators (filenames) in the xterm, as the
##          search progresses.
##
##          The utility script puts 'egrep' output into a text file.
##
##          The utility script shows the text file using a text-file viewer
##          of the user's choice.
##
## HOW TO USE: Right-click on the name of ANY file (or directory) in a Nautilus 
##             directory list, after navigating to a 'base' directory.
##             Then choose this Nautilus script to run (name above).
##
## Created: 2011may23 Based on 00_findSTR_in_dirTEXTFILS_recursive.sh
## Changed: 2012feb29 Changed the script name in the comment above.


## FOR TESTING: (turn ON display of executed-statements)
#  set -x


######################################################################
## Ask user whether a 'progress window' is wanted.
######################################################################

ANS=$(zenity --list --radiolist \
   --title "Progress Window" \
   --text "\
If this is a 'deep' directory, you may want
a 'Progress Window' to let you know how the
'find' is progressing.

Progress Window - Yes, No, Cancel?" \
   --column "" --column "" \
   Yes Yes No No)

## FOR TESTING: (turn ON display of executed-statements)
#   set -x

if test "$ANS" = ""
then
   exit
fi


######################################################################
## Set the NautilusScripts directory in a var.
######################################################################

. $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi


######################################################################
## If the user answered Yes, start the find query.
######################################################################

if test "$ANS" = "Yes"
then
   xterm -T "Progress Window for Find-StringS-In-Text-Files (recursive)" \
         -bg black -fg white -hold -geometry 80x40+0+25 -sb -leftbar -sl 1000 \
      -e $DIR_NautilusScripts/FINDlists/.findSTRorSTR_in_dirTEXTFILS_recursive.sh \
         noquiet
else
  $DIR_NautilusScripts/FINDlists/.findSTRorSTR_in_dirTEXTFILS_recursive.sh quiet
fi


