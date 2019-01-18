#!/bin/sh
##
## Nautilus
## SCRIPT: 00_anyfile_NOTIFY-EVERY-N-MINS_sleep.sh
##
## PURPOSE: Every N minutes this script pops up a reminder that N minutes
##          have passed. (Can be used to remind a person working
##          too diligently at a computer to stand up and stretch every
##          N minutes.)
##
## METHOD:  Uses a 'zenity --entry' prompt to get N from the user.
##
##          In a 'while' loop, this script
##          uses 'zenity' with the '--question' option to popup the
##          notification that N minutes have passed --- and allow the
##          user to cancel out of the notification loop.
##
##          Uses 'sleep' to pause the script until the next zenity
##          popup is to occur.
##
## HOW TO USE: In Nautilus, select ANY file in ANY directory.
##             Then right-click and choose this script to run
##             (script name above), via the 'Scripts >' option of
##              the right-click menu. Go to the 'OFFICEtools' group.
##
###########################################################################
## Script
## Created: 2012jun03
## Changed: 2012jun04 Added CNT var.
##########################################################################

## FOR TESTING: (show statements as they execute)
   set -x


############################################
## Prompt for N, the number of minutes. 
############################################

NMINS=""

NMINS=$(zenity --entry \
   --title "Enter N, the number of minutes." \
   --text "\
Enter N, the number of minutes between each
notification that N minutes have passed." \
   --entry-text "15")

if test "$NMINS" = ""
then
   exit
fi

NSECS=`expr 60 \* $NMINS`
CNT=0

##########################################################
## Start the prompting loop.
##########################################################

# while true
while :
do

   #######################################################
   ## Pause for N minutes.
   #######################################################
   sleep $NSECS

   ##########################################################
   ## Confirm that N minutes have passed, using 'zenity'
   ## with the '--question' option. The user can click Cancel
   ## to exit the notification while-loop.
   ##
   ## From 'man 'zenity':
   ## 'zenity --question' will return either 0 or 1, depending
   ## on whether the user pressed OK or Cancel.
   ##########################################################

   CNT=`expr $CNT + 1`

   zenity --question \
   --title "$NMINS MINUTES have passed." \
   --no-wrap \
   --text "\
Notification number $CNT.

$NMINS MINUTES have passed.

Click 'OK' to continue this notification loop ---
OR click 'Cancel' to terminate this loop.

CANCEL or OK?"

   RETCODE=$?

   if test $RETCODE = 1
   then
      exit
   fi

done
## END OF 'while true' loop.
