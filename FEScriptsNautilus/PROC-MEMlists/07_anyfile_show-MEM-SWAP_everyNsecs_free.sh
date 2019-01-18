#!/bin/sh
##
## Nautilus
## SCRIPT: 07_anyfile_show_MEM-SWAP_everyNsecs_free.sh
##
## PURPOSE: Uses the 'watch -n N -d' command to run the 'free -m' command
##          every N seconds --- to see how memory (free and used)
##          and swap are changing.
##
##             The '-d' flag will highlight the differences between
##             successive updates.
##             The '-m' shows the memory usage in Megabytes.
##
## METHOD:  This script uses 'zenity' to prompt for N, the number of seconds
##          (roughly) between each execution of the 'free' command.
##
##          Shows the 'free' output in a terminal window using 'xterm -hold'.
##
## HOW TO USE: This utility does not depend on any directory or file, so ...
##             In the Nautilus file manager, right-click on the name of
##             ANY file in ANY directory in ANY Nautilus directory list.
##             Then select this Nautilus script to run (name above).
##
## Created: 2011apr27
## Changed: 2012feb29 Changed the script name in the comment above.

## FOR TESTING: (show statements as they execute)
#  set -x


############################################
## Prompt for N seconds, using zenity.
############################################

NSECS=""

NSECS=$(zenity --entry \
   --title "\
Enter N seconds, for this 'watch free memory' utility." \
   --text "\
Enter  an integer  or  a decimal number.   Examples:  120   OR   2.5
NOTE: This utility currently shows the memory figures in MEGABYTES.
      Edit this script to change '-m' in the 'free' command." \
   --entry-text "60")

if test "$NSECS" = ""
then
   exit
fi


##########################################
## Show info on the 'free' output.
##########################################

BASENAME=`basename $0`

zenity --info --title "Info on 'free -m' output." \
   --text "\
This utility, $BASENAME ,
will use 'free -m' to show, every $NSECS secs, memory and swap status.

The 'watch -n $NSECS -d free' command is used to run 'free' every $NSECS secs.
The '-d' turns on highlighting of the differences between successive updates.

'free' displays the total amount of free and used physical and swap
memory in the system, as well as the buffers  used by  the  kernel.
The shared memory column should be ignored; it is obsolete.

Options for UNITS display of the memory numbers :
     -b  bytes
     -k  kilobytes
     -m  megabytes (currently used in this script)
     -g  gigabytes.

You can close this window if you do not want it taking screen space.
Closing it will not close the output window." &


#######################################################################
## Run the 'watch -n N -d free -m' command --- in an 'xterm'.
########################################################################

xterm -hold -fg white -bg black \
      -title "Memory & Swap Usage, in MEGABYTES" \
      -geometry 80x10+20+20 \
      -e "watch -n $NSECS -d free -m"
