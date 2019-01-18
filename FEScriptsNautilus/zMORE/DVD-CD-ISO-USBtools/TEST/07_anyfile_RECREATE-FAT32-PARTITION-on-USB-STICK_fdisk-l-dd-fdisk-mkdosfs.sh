#!/bin/sh
##
## Nautilus
## SCRIPT: 07_anyfile_RECREATE-FAT32-PARITION-on-USB-STICK_dd-fdisk-mkdosfs.sh
##
## PURPOSE: Restores a USB stick to its original state --- using
##          'dd' and 'fdisk' and 'mkdosfs'.  Explanation:
##
##   When you have put a '.img' or '.iso' file on a USB stick,
##   the USB stick is no longer useful for anything else.  Any remaining
##   space on the stick (supposing you used one larger-than the .img file)
##   is inaccessible. Fortunately, it is easy to re-create a FAT partition
##   on the stick so that the USB stick again becomes available for carrying
##   around your data.
##
## METHOD: Uses 'sudo fdisk -l' in an 'xterm' to show the currently
##         connected storage drives --- their partitions and the
##         file-system-types of the partitions.
##
##         Uses 'zenity' to prompt for a device name --- for the
##         USB stick, such as  'sde' --- for '/dev/sde'.
##            (IMPORTANT TO CHOOSE THE RIGHT DEVICE, to avoid wiping
##             out data on a hard disk drive.)
##
##         Then, wipes the bootsector of the USB stick:
##               dd if=/dev/zero of=/dev/sde bs=512 count=1
##
##         Then, creates a new FAT32 partition on the stick and write a FAT32 
##         filesystem on it (vfat or type b in fdisk terminology):
##
##         fdisk /dev/sde <<EOF
##         n
##         p
##         1  
##         
##         
##         t
##         b
##         w
##         EOF
##
##        Then formats the partition as FAT32:
##             mkdosfs -F32 /dev/sde1 
##
## REFERENCE:
##    http://mirror.mocker.org/archlinux/iso/archboot/Restore-Usbstick.txt
##    which was available on 2012apr11
##
##########################################################################
## Script
## Created: 2012apr18
## Changed: 2012
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


###########################################
## Prompt for the target USB drive path --- 
## without the '/dev/' prefix.
###########################################

DRIVE_ID=""

DRIVE_ID=$(zenity --entry \
   --title "Enter USB DRIVE ID --- example: 'sdc' or 'sde'." \
   --text "\
Enter the USB DRIVE ID below -- without the '/dev/' prefix.  Examples:
       sdc    for /dev/sdc
       sde    for /dev/sde

Use the 'sudo fdisk -l' output  in the 'xterm' that popped up,
to determine the USB drive. Verify the size of the drive.
      Typically the USB drive has a single partition ---
      when new, typically with file-system-type 'W95 FAT32 (LBA)' ---
      after use to hold a CD/DVD '.img' or '.iso' file, typically
      with file-system-type 'Hidden HPFS/NTFS'.

After a 'umount' (unmount) of the USB drive partition, in an 'xterm' window,
the 'dd' command will be used to wipe the boot sector of the USB stick
--- in an 'xterm' window.
Close the 'umount' xterm-window to start the 'dd' xterm-window.

Close the 'dd-xterm' to allow the 'fdisk' command to re-partition the
USB device. Then, in another 'xterm', the 'mkdosfs' command is run
to format the partition as FAT32.

Then close that 'xterm' and the output of another 'sudo fdisk -l'
command, in another 'xterm', can be used to verify the formatting.

Then remove the USB device and re-connect it to a computer." \
   --entry-text "")

if test "$DRIVE_ID" = ""
then
   exit
fi

###########################################
## WARN the user if they chose sda/sdb/sdc.
###########################################

DEV_DRIVE="/dev/$DRIVE_ID"

if test "$DEV_DRIVE" = "/dev/sda" -o "$DEV_DRIVE" = "/dev/sdb" -o \
        "$DEV_DRIVE" = "/dev/sdc"
then

   zenity --question \
      --title "Is $DEV_DRIVE OK?" \
      --text "\
The drive you selected, $DEV_DRIVE, is one of
/dev/sda, /dev/sdb, or /dev/sdc.

If a system has multiple hard disk drives and a backup USB hard drive
connected, then these might be hard drives. DANGER! DANGER!

Is it OK to proceed? Doing so would wipe out a hard drive.

CANCEL or OK?"  --no-wrap

   RETCODE=$?

   if test $RETCODE = 1
   then
      exit
   fi

fi


###############################################################
## Unmount the first (probably only) partition of the drive.
###############################################################

xterm -hold -fg white -bg black -geometry 80x20+50+50 \
      -title "Run 'sudo umount -v ${DEV_DRIVE}1'" -e \
      sudo umount -v ${DEV_DRIVE}1


###############################################################
## Check with the user before running 'dd' to erase boot sector.
###############################################################

zenity --question \
   --title "Are you ready to erase the boot sector with 'dd'?" \
   --text "\
The drive you selected is $DEV_DRIVE 

If you are NOT SURE that that is the USB drive,
CANCEL now.

CANCEL or OK?"  --no-wrap

RETCODE=$?

if test $RETCODE = 1
then
   exit
fi

###############################################################
## EXECUTE the 'sudo dd if=... of=...' command, in an 'xterm'
## -- to erase the boot sector.
###############################################################

xterm -hold -fg white -bg black -geometry 80x40+150+150 \
      -title "Run 'sudo dd if=/dev/zero of=$DEV_DRIVE bs=512 count=1" -e \
      sudo dd if=/dev/zero  of=$DEV_DRIVE  bs=512 count=1 


##################################################################
## Use 'fdisk' to create a new (single) partition on the stick ---
## vfat or type b in fdisk terminology.
##################################################################

sudo fdisk $DEV_DRIVE <<EOF
n
p
1


t
b
w
EOF


###########################################################
## Use 'mkdosfs' to create a FAT32 filesystem on the stick.
###########################################################

xterm -hold -fg white -bg black -geometry 80x20+200+200 \
      -title "Run 'sudo mkdosfs -F32 ${DEV_DRIVE}1'" -e \
      sudo mkdosfs -F32 ${DEV_DRIVE}1


########################################################
## Run the 'sudo fdisk -l' command in an xterm,
## in the background --- to check the changed USB drive
## to see if the file type is now 'W95 FAT32 (LBA)' or
## some such.
########################################################

xterm -hold -fg white -bg black -geometry 80x40+250+250 \
      -title "Run 'sudo fdisk -l'" -e \
      sudo fdisk -l &
