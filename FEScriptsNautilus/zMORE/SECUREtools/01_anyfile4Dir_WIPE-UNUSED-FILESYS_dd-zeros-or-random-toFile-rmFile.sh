#!/bin/sh
##
## Nautilus
## SCRIPT: 01_anyfile4Dir_WIPE-UNUSED-FILESYS_dd-zeros-or-random-toFile-rmFile.sh
##
## PURPOSE: Writes zeros or random-data to a new file in the current
##          directory and then deletes that file. This is to wipe
##          unused areas of a filesystem by filling it with data, and
##          then removing that data.
##
## METHOD:  Uses 'zenity --list --radiolist' to offer a choice of zeros or
##          'urandom' data.
##
## HOW TO USE: In Nautilus, select ANY file in a directory of the file system
##             whose unused areas you wish to wipe.
##             Then right-click and choose this script to run (name above).
##
## REFERENCE: Linux Format Magazine, LXF166, Jan 2013, page 109.
##
###########################################################################
## Created: 2013apr06
## Changed: 2013
######################################################################

## FOR TESTING: (show statements as they execute)
#   set -x


##############################################################
## Set the current directory.
## (Make sure the variable is not empty.)
##############################################################

CURDIR=`pwd`

if test "$CURDIR" = ""
then
   exit
fi

##############################################################
## Prompt for zeros (/dev/zero) or random-data (/dev/urandom).
##############################################################

DEV_TYPE=""

DEV_TYPE=$(zenity --list --radiolist \
   --title "Use zeros or random-data?" \
   --text "Choose one of the following types.

NOTE1: This utility will use the 'dd' command to write
zeros or random-data to the unused areas of the filesystem
in which this directory
   $CURDIR
exists. This utility will use /dev/zero or /dev/urandom
depending on your choice. An example of the two commands used:

   dd if=/dev/zero of=$CURDIR/TEMP-space-filling-file
   rm $CURDIR/TEMP-space-filling-file

NOTE2: It may take on the order of 1 minute per Gigabyte to
write the data. For a 32 GB USB stick, this means it may take
over half an hour. For a 1 Terabyte drive, multiple hours.

A window will popup when the process is done.
" \
   --column "" --column "Type" \
   TRUE zeros FALSE random)

if test "$DEV_TYPE" = ""
then
   exit
fi

## FOR TESTING:
#   exit

if test "$DEV_TYPE" = "zeros"
then
   DEV_DATA="/dev/zero"
else
   DEV_DATA="/dev/urandom"
fi

#####################################################
## Make and remove the file --- with 'dd' and 'rm'.
#####################################################

TEMPFILE="$CURDIR/TEMP-space-filling-file"

dd if="$DEV_DATA" of="$TEMPFILE"

rm "$TEMPFILE"


##############################################################
## A zenity 'info' window(s) to show that the process is done.
##############################################################

zenity --info --title "Filesystem space-wipe is DONE." \
   --no-wrap \
   --text  "\
The 'dd' and 'rm' commands have completed."
