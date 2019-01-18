#!/bin/sh
##
## Nautilus
## SCRIPT: 08_anyfile_show_DISK-IO_everyNsecs_vmstat.sh
##
## PURPOSE: Uses the 'watch -n N -d' command to run the 'vmstat -d' command
##          every N seconds --- to see how disk IO (reads,writes)
##          are changing.
##
##             The '-d' flag will highlight the differences between
##             successive updates.
##
## METHOD:  This script uses 'zenity' to prompt for N, the number of seconds
##          (roughly) between each execution of the 'vmstat' command.
##
##          Shows the output in a terminal window using 'xterm -hold'.
##
## HOW TO USE: This utility does not depend on any directory or file, so ...
##             In the Nautilus file manager, right-click on the name of
##             ANY file in ANY directory in a Nautilus directory list.
##             Then select this Nautilus script to run (name above).
##
## Created: 2011may23
## Changed: 2012feb29 Changed the script name in the comment above.

## FOR TESTING: (show statements as they execute)
#  set -x


############################################
## Prompt for N seconds, using zenity.
############################################

NSECS=""

NSECS=$(zenity --entry \
   --title "\
Enter N seconds, for this 'watch disk IO (reads,writes)' utility." \
   --text "\
Enter  an integer  or  a decimal number.   Examples:  120   OR   2.5" \
   --entry-text "60")

if test "$NSECS" = ""
then
   exit
fi

##########################################
## Show info on the vmstat output.
##########################################

CURDIR="`pwd`"
CURDIRFOLDED=`echo "$CURDIR" | fold -55`

BASENAME=`basename $0`

zenity --info --title "Info on 'vmstat -d' output." \
   --text "\
This utility, $BASENAME ,
will use 'vmstat -d' to show, every $NSECS secs, disk IO statistics:
reads and writes.

The 'watch -n $NSECS -d vmstat' command is used to run 'vmstat' every $NSECS secs.
The '-d' turns on highlighting of the differences between successive updates.

MEANING OF THE HEADING ABBREVIATIONS :
   Reads
       total: Total reads completed successfully
       merged: grouped reads (resulting in one I/O)
       sectors: Sectors read successfully
       ms: milliseconds spent reading

   Writes
       total: Total writes completed successfully
       merged: grouped writes (resulting in one I/O)
       sectors: Sectors written successfully
       ms: milliseconds spent writing

   IO
       cur: I/O in progress
       s: seconds spent for I/O

You can close this window if you do not want it taking screen space.
Closing it will not close the output window." &


#######################################################################
## Run the 'watch -n N -d vmstat -d' command.
########################################################################

xterm -hold -fg white -bg black \
   -title "Disk IO counts" \
   -geometry 80x40+20+20 \
   -e "watch -n $NSECS -d vmstat -d"
