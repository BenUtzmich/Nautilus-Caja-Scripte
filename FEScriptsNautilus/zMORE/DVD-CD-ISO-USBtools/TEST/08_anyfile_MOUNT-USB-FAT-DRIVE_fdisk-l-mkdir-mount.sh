#!/bin/sh
##
## Nautilus
## SCRIPT: 08_anyfile_MOUNT-USB-FAT-DRIVE_fdisk-l-mkdir-mount.sh
##
## PURPOSE: Mounts a partition of a USB drive (could be a USB 'stick')
##          onto a new directory --- currently set at /media/TEMP_USB.
##
##          (You can change this mount point by changing the DIRMOUNT
##           variable setting statement near the top of this script
##           Alternatively,
##           we could add a 'zenity --entry' prompt for this directory
##           name, with a default provided.)
##
## METHOD: Uses 'sudo fdisk -l' in an 'xterm' to show the currently
##         connected storage drives --- their partitions and the
##         file-system-types of the partitions.
##
##         Uses 'zenity' to prompt for a device name --- for the
##         partition to be mounted, such as  'sdd1' --- for '/dev/sdd1'.
##
##         Makes the mount directory with
##             sudo mkdir -p /media/TEMP_USB
##
##         Mounts the specified partition to the new mount directory with
##             sudo mount -t vfat -o rw,users /dev/sdd1 /media/TEMP_USB
##
##             NOTE: One may need to change 'users' to something like $USER.
##
##         Uses the 'mount' command to confirm that the mount succeeded.
##
## REFERENCES:
##    http://linuxcommando.blogspot.com/2007/12/how-to-mount-usb-flash-drive-from.html
##    https://help.ubuntu.com/community/Mount/USB
##
## HOW TO USE: In Nautilus, select ANY file in ANY directory.
##             Right click and, from the 'Scripts >' submenus,
##             choose to run this script (name above).
##
##########################################################################
## Script
## Created: 2012jul14
## Changed: 2012dec02 Fixed the 'mkdir' step. It had 'mount' instead of
##                    'mkdir'.
## Changed: 2013feb27 Removed a 'mkdosfs' statement from the comments
##                    above. Replaced it with a 'mount' comment.
##########################################################################

## FOR TESTING: (show statements as they execute)
#  set -x

################################################
## Run the 'sudo fdisk -l' command in an xterm,
## in the background.
###############################################

xterm -hold -fg white -bg black  -geometry 80x40+25+25 \
      -title "Run 'sudo fdisk -l'" -e \
      sudo fdisk -l &


################################################
## Set the mount-directory name.
################################################

DIRMOUNT="/media/TEMP_USB"


################################################
## Prompt for the USB drive partition --- 
## without the '/dev/' prefix.
################################################

PARTITION_ID=""

PARTITION_ID=$(zenity --entry \
   --title "Enter USB drive 'PARITION ID' --- example: 'sdd1'." \
   --text "\
Enter the USB drive 'PARTITION ID' below -- without the '/dev/' prefix.  Examples:
       sdc1    for /dev/sdc1
       sdd1    for /dev/sdd1

Use the 'sudo fdisk -l' output  in the 'xterm' that popped up,
to determine the partition of the USB drive that is to be mounted.
      Verify the size of the drive.
      Typically the USB drive has a single partition ---
      when new, typically with file-system-type 'W95 FAT32 (LBA)' --- OR
      after use to hold a CD/DVD '.img' or '.iso' file, typically
      the file-system-type is 'Hidden HPFS/NTFS'.

This utility will make a new mount directory called '$DIRMOUNT' with the command
            sudo mkdir -p $DIRMOUNT
in an 'xterm' window --- so you can provide password if necessary.

Close that 'xterm' window.
Then this utility mounts the specified partition to the new mount directory with
a command like
            sudo mount -t vfat -o rw,users /dev/sdd1 $DIRMOUNT
in an 'xterm' window --- so you can provide password if necessary.

Then close the 'xterm' windows. The 'mount' command (no parms) in a terminal
window can be used verify that the partition was mounted.

When done with the USB drive, BEFORE REMOVING IT, issue a 'umount' command like
       sudo umount $DIRMOUNT

Then remove (unplug) the USB device ." \
   --entry-text "")

if test "$PARTITION_ID" = ""
then
   exit
fi

###########################################
## WARN the user if they chose sda1/sdb1/sdc1.
###########################################

DEV_PARTITION="/dev/$PARTITION_ID"

if test "$DEV_PARTITION" = "/dev/sda1" -o "$DEV_PARTITION" = "/dev/sdb1" -o \
        "$DEV_PARTITION" = "/dev/sdc1"
then

   zenity --question \
      --title "Is $DEV_PARTITION OK?" \
      --text "\
The partition you selected, $DEV_PARTITION, is one of
/dev/sda1, /dev/sdb1, or /dev/sdc1.

If a system has multiple hard disk drives and a backup USB hard drive
connected, then these might be hard drives.

Is it OK to proceed?

CANCEL or OK?"  --no-wrap

   RETCODE=$?

   if test $RETCODE = 1
   then
      exit
   fi

fi


###############################################################
## Make the (empty) mount directory.
## (We could add some checking here to see if it already
##  exists, and sudo-delete DIRMOUNT="/media/TEMP_USB" if it
##  already exists --- then make it. Alternatively, we could
##  sudo-mount /media/TEMP_USB if it is empty.)
############################################################### 

xterm -hold -fg white -bg black -geometry 80x20+50+50 \
      -title "Run 'sudo mkdir -p $DIRMOUNT'" -e \
      sudo mkdir -p $DIRMOUNT


###############################################################
## EXECUTE the 'sudo mount ...' command, in an 'xterm'.
###############################################################

xterm -hold -fg white -bg black -geometry 80x40+150+150 \
      -title "Run 'sudo mount -t vfat -o rw,users $DEV_PARTITION $DIRMOUNT'" -e \
      sudo mount -t vfat -o rw,users $DEV_PARTITION $DIRMOUNT


###############################################################
## Run the 'mount' command in an xterm -- to confirm the mount.
###############################################################

xterm -hold -fg white -bg black -geometry 80x40+250+250 \
      -title "Verifying the mount, with the 'mount' command." -e \
      mount
