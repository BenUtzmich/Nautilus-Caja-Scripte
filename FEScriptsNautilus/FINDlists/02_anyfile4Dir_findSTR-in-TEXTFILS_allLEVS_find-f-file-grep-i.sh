#!/bin/sh
##    
## Nautilus                        
## SCRIPT: 02_anyfile4Dir_findSTR_in_TEXTFILS_allLEVS_find-f-file-grep-i.sh
##                            
## PURPOSE: For all TEXT files, at all levels under the current directory,
##          this script lists the lines in those files that contain a
##          user-specified string --- using 'find' for the directory tree
##          navigation, 'file' to determine the text files, and 'grep' to
##          find lines containing the user-specified string.
##
## METHOD:  A 'zenity --entry' prompt is used to get the search string from
##          the user.
##
##          This 'wrapper' script starts a utility script
##               '.findSTR_in_dirTEXTFILS_recursive.sh'
##          that is in this same scripts directory.
##          The utility script uses the 'find', 'file' and 'grep' commands
##          as indicated above.
##
##          The user is given the option to conduct the search 
##          in an 'xterm' --- so that that the utility script can
##          show progress indicators (filenames) in the xterm, as the
##          search progresses.
##
##          The utility script puts 'grep' output into a text file.
##
##          The utility script shows the text file using a text-file viewer
##          of the user's choice.
##
## HOW TO USE: Right-click on the name of any file (or directory) in a Nautilus 
##             directory list, after navigating to a 'base' directory.
##             Then choose this Nautilus script to run (name above).
##
## Created: 2010sep19 As a 'wrapper' script to start script
##                    '.findSTR_in_dirTEXTFILS_recursive.sh' in an xterm.
## Changed: 2011may02 Added $USER to a temp filename in the .find... hidden script.
## Changed: 2011may11 Get 'nautilus-scripts' directory via an include script.
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
   xterm -T "Progress Window for Find-String-In-Text-Files (recursive)" \
         -bg black -fg white -hold -geometry 80x40+0+25 -sb -leftbar -sl 1000 \
         -e $DIR_NautilusScripts/FINDlists/.findSTR_in_dirTEXTFILS_recursive.sh \
            noquiet

  ## WAS -e ~/.gnome2/nautilus-scripts/FINDlists/.findSTR_in_dirTEXTFILS_recursive.sh noquiet

else
  $DIR_NautilusScripts/FINDlists/.findSTR_in_dirTEXTFILS_recursive.sh quiet

  ## WAS  ~/.gnome2/nautilus-scripts/FINDlists/.findSTR_in_dirTEXTFILS_recursive.sh quiet
fi


