#!/bin/sh
##
## Nautilus
## SCRIPT: 07_anyfile_show_MEM_everyNsecs_vmstat.sh
##
## PURPOSE: Uses the 'watch -n N -d' command to run the 'vmstat -a -S m' command
##          every N seconds --- to see how memory (free, active, inactive)
##          are changing.
##
##             The '-d' flag will highlight the differences between
##             successive updates.
##             The '-S m' shows the memory usage in Megabytes.
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
Enter N seconds, for this 'watch free-inactive-active memory' utility." \
   --text "\
Enter  an integer  or  a decimal number.   Examples:  120   OR   2.5
NOTE: This utility currently shows the memory figures in MEGABYTES.
      Edit this script to change '-S m' in the 'vmstat' command." \
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

zenity --info --title "Info on 'vmstat -a -S m' output." \
   --text "\
This utility, $BASENAME ,
will use 'vmstat -a -S m' to show, every $NSECS secs, memory status:
free, inactive, and active.

The 'watch -n $NSECS -d vmstat' command is used to run 'vmstat' every $NSECS secs.
The '-d' turns on highlighting of the differences between successive updates.

The memory is shown in Megabytes (1,000,000 byte chunks, not 1,048,576).

MEANING OF THE HEADING ABBREVIATIONS :
   Procs
       r: The number of processes waiting for run time.
       b: The number of processes in uninterruptible sleep.

   Memory
       swpd: the amount of virtual memory used.
       free: the amount of idle memory.
       inact: the amount of inactive memory. (-a option)
       active: the amount of active memory. (-a option)

   Swap
       si: Amount of memory swapped in from disk (/s).
       so: Amount of memory swapped to disk (/s).

   IO
       bi: Blocks received from a block device (blocks/s).
       bo: Blocks sent to a block device (blocks/s).

   System
       in: The number of interrupts per second, including the clock.
       cs: The number of context switches per second.

   CPU
       These are percentages of total CPU time.
       us: Time spent running non-kernel code. (user time, including nice time)
       sy: Time spent running kernel code. (system time)
       id: Time spent idle. Prior to Linux 2.5.41, this includes IO-wait time.
       wa: Time spent waiting for IO. Prior to Linux 2.5.41, included in idle.
       st: Time stolen from a virtual machine. Prior to Linux 2.6.11, unknown.

You can close this window if you do not want it taking screen space.
Closing it will not close the output window." &


#######################################################################
## Run the 'watch -n N -d vmstat -a -S m' command.
########################################################################

xterm -hold -fg white -bg black \
   -title "Memory Usage, in MEGABYTES" \
   -geometry 80x10+20+20 \
   -e "watch -n $NSECS -d vmstat -a -S m"
