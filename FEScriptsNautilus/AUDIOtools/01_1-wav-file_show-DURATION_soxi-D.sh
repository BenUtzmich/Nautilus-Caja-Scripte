#!/bin/sh
##
## Nautilus
## SCRIPT: 01_1-wav-file_show_DURATION_soxi-D.sh
##
## PURPOSE: Shows duration (seconds) of a '.wav' file.
##
## METHOD:  Uses 'soxi -D' on the selected filename.
##
##          The duration will be shown in a 'zenity --info' window.
##
## HOW-TO-USE: Using the Nautilus file manager,
##             navigate to a directory and select one '.wav' file.
##             Then right-click and choose this script to run (name above).
##
## REFERENCE: man sox
##
#######################################################################
## Created: 2010oct04
## Changed: 2011feb28 Changed the scriptname, in the comment above.
##                    Added the 'HOW-TO-USE' comments section above.
##                    Added to the 'METHOD' comments section above.
## Changed: 2013apr10 Added check for the soxi executable.
#######################################################################

## FOR TESTING:  (turn ON display of executed-statements)
#   set -x

#########################################################
## Check if the soxi executable exists.
#########################################################

EXE_FULLNAME="/usr/bin/soxi"

if test ! -f "$EXE_FULLNAME"
then
   zenity  --info --title "Executable NOT FOUND." \
   --no-wrap \
   --text  "\
The soxi executable
   $EXE_FULLNAME
was not found. Exiting.

If the soxi executable is in another location,
you can edit this script to change the filename."
   exit
fi


###########################################
## Get the filename of the selected file.
###########################################

# FILENAMES="$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS"
# FILENAMES="$@"
  FILENAME="$1"

###########################################
## Get the 'duration' of the selected file,
## in seconds.
###########################################

# SECS=`soxi -D "$FILENAME"`

SECS=`$EXE_FULLNAME -D "$FILENAME"`

zenity --info --title "Duration of audio file" \
       --text "\
Duration of file $FILENAME
is $SECS seconds."
