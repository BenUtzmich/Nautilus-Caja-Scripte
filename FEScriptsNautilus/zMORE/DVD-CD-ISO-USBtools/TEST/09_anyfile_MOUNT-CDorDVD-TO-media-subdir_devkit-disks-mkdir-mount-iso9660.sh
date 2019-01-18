#!/bin/sh
##
## Nautilus
## SCRIPT: 09_anyfile_MOUNT-CDorDVD-TO-media_sudir_devkit-disks-mkdir-mount-iso9660.sh
##
## PURPOSE: Mounts a CD or DVD disk in a CD or DVD drive to a subdirectory
##          of the directory /media (or /mnt).
##
##          This script uses a 'zenity --entry' prompt for the 'mount-point' directory
##          name, with a default provided --- such as /media/TEMP_MOUNT.
##
## METHOD: Uses 'sudo fdisk -l' in an 'xterm' to show the currently
##         connected storage drives --- their partitions and the
##         file-system-types of the partitions.
##
##         Uses 'zenity' to prompt for a device name --- for the
##         partition to be mounted, such as  'sr1' --- for '/dev/sr1'.
##
##         Makes the mount directory with
##             sudo mkdir -p $DIRMOUNT
##
##         Mounts the CD/DVD device to the new mount directory with
##             sudo mount -t iso9660 /dev/$DEV $DIRMOUNT
##
## REFERENCES:
##    The command
##          mount -tiso9660 /dev/cdrom /mnt/cdrom
##    was shown at the back of the book
##    '3D Graphics Programming, Games and Beyond', by Sergei Savchenko, SAMS Publishing, 2000
##
##    It also said:
##    '/mnt/cdrom' is just a mount point, but it must exist when you issue the mount
##    command. You may also use any empty directory for a mount point if you
##    don't want to use /mnt/cdrom.
##
##########################################################################
## Script
## Created: 2012dec02
## Changed: 2012
##########################################################################

## FOR TESTING: (show statements as they execute)
#  set -x

################################################
## Run the 'sudo fdisk -l' command in an xterm,
## in the background.
###############################################

xterm -hold -fg white -bg black  -geometry 80x40+25+25 \
      -title "Run 'devkit-disks --enumerate | sort'" -e \
      'devkit-disks --enumerate | sort' &

################################################
## Prompt for the CD/DVD drive partition --- 
## without the '/dev/' prefix.
################################################

PARTITION_ID=""

PARTITION_ID=$(zenity --entry \
   --title "Enter CD/DVD drive 'PARTITION ID' --- example: 'sr1'." \
   --text "\
Enter the CD/DVD drive 'PARTITION ID' below -- without the '/dev/' prefix.  Examples:
       sr0    for /dev/sr0
       sr1    for /dev/sr1

Use the 'devkit-disks --enumerate' output  in the 'xterm' that popped up,
to determine the partition of the CD/DVD drive that is to be mounted.

Typically the CD/DVD drive is indicated by 'sr0' or 'sr1'.
DO NOT USE 'sda' 'sda1' 'sda2' 'sda5' 'sdb' 'sdb1' 'sdb5' 'sdc' 'sdd'.
These are typically hard-drive partitions.

This utility will prompt you for a new or empty mount directory.
If new, the directory will be made with the command
            sudo mkdir -p \$DIRMOUNT
in an 'xterm' window --- so you can provide password if necessary.
Close that 'xterm' window.

Then this utility mounts the specified device partition to the new mount directory
with a command like
            sudo mount -t iso9660 /dev/<partitionID> \$DIRMOUNT
in an 'xterm' window --- so you can provide password if necessary.

Then close the 'xterm' windows. The output of the 'mount' command (no parms)
is shown in a terminal window --- to verify that the partition was mounted.

When done with the CD/DVD drive, you can issue the command
     sudo eject /dev/$PARTITION_ID
to eject the disk.

Then remove the CD/DVD." \
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


################################################
## Prompt for the mount-directory name.
################################################

DIRMOUNT="/media/TEMP_MOUNT"

DIRMOUNT=$(zenity --entry \
   --title "Enter mount directory name --- new or an empty existing directory." \
   --text "\
Enter the name for the CD/DVD mount directory
--- a new directory (which will be made) or an empty existing directory.

If new (non-existing), the directory will be made with the command
            sudo mkdir -p \$DIRMOUNT
in an 'xterm' window --- so you can provide password if necessary.
Close that 'xterm' window.

Then this utility mounts the specified device partition to the new mount directory
with a command like
            sudo mount -t iso9660 /dev/$PARTITION_ID \$DIRMOUNT
in an 'xterm' window --- so you can provide password if necessary.

Then close the 'xterm' windows. The output of the 'mount' command (no parms)
is shown in a terminal window --- to verify that the partition was mounted.

When done with the CD/DVD drive, you can issue the command
     sudo eject /dev/$PARTITION_ID
to eject the disk.

Then remove the CD/DVD.
If you no longer want the empty mount directory, you could delete it
(as root)." \
   --entry-text "$DIRMOUNT")

if test "$DIRMOUNT" = ""
then
   exit
fi


###############################################################
## Make the mount directory if it does not exist, else
## (if it exists) check that it is empty.
###############################################################

if test ! -d "$DIRMOUNT"
then
   xterm -hold -fg white -bg black -geometry 80x20+50+50 \
      -title "Run 'sudo mkdir -p $DIRMOUNT'" -e \
      sudo mkdir -p $DIRMOUNT
else
   EMTPYCHK=`ls $DIRMOUNT`
   if test ! "$EMTPYCHK" = ""
   then
      zenity --info \
         --title "Specified mount directory is not empty. EXITING." \
         --text "\
The specified mount directory, $DIRMOUNT,
is NOT EMPTY. EXITING."
      exit
   fi
fi


###############################################################
## EXECUTE the 'sudo mount -t iso9660 ...' command, in an 'xterm'.
###############################################################

xterm -hold -fg white -bg black -geometry 80x40+150+150 \
      -title "Run 'sudo mount -t iso9660 $DEV_PARTITION $DIRMOUNT'" -e \
      sudo mount -t iso9660 $DEV_PARTITION $DIRMOUNT


###############################################################
## Run the 'mount' command in an xterm -- to confirm the mount.
###############################################################

xterm -hold -fg white -bg black -geometry 80x40+250+250 \
      -title "Verifying the mount, with the 'mount' command." -e \
      mount
