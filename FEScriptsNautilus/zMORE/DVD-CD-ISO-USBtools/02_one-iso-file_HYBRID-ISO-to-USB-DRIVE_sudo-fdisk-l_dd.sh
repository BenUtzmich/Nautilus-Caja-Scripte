#!/bin/sh
##
## Nautilus
## SCRIPT: 02_one-iso-file_HYBRID-ISO-to-USB-DRIVE_sudo-fdisk-l_dd.sh
##
## PURPOSE: Copies a ('hybrid') 'iso' file to a USB drive --- like
##          a USB 'pendrive'.
##
##          Typically for making a bootable 'live' Linux USB boot drive.
##          It is up to the user to make sure that the '.iso' file
##          is a 'hybrid' file.
##
## METHOD:  Uses 'sudo fdisk -l' in an 'xterm' to show the currently
##          connected storage drives --- their partitions and the
##          file-system-types of the partitions.
##
##          Uses 'zenity' to prompt for a device name --- such as
##          'sdc' or 'sde' --- for '/dev/sdc' or '/dev/sde'.
##
##          Then uses the 'dd' command to do the copy --- example:
##                
##           sudo dd if=whatever.iso  of=/dev/sdx oflag=direct bs=1048576
##
##          Runs 'dd' in an 'xterm', so summary messages indicate
##          when the copy is done. (The copy may take about 3 minutes.)
##
## HOW TO USE: In Nautilus, select one '.iso' file in a directory.
##             Right click and, from the 'Scripts >' submenus,
##             choose to run this script (name above).
##
## REFERENCES:
##       http://community.linuxmint.com/tutorial/view/744
##
## Created: 2012apr07
## Changed: 2012apr11 Changed some comments in the zenity prompt for DeviceID.
##                    Added a zenity 'Are you sure?' prompt before the 'dd'.
##                    Also added a 2nd 'fdisk -l' command at the end.
## Changed: 2012may06 Added an xterm for 'top'. Added to title of dd-xterm.

## FOR TESTING: (show statements as they execute)
#  set -x

################################################
## Get '.iso' filename.
################################################

ISOFILENAME="$1"


################################################
## Run the 'sudo fdisk -l' command in an xterm,
## in the background.
###############################################

xterm -hold -fg white -bg black -geometry 80x40+25+25 \
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
      typically with file-system-type 'W95 FAT32 (LBA)'.

After a 'umount' (unmount) of the USB drive partition, in an 'xterm' window,
the '.iso' file
    $ISOFILENAME
will be copied to the drive using 'dd' --- in an 'xterm' window.
Close the 'umount' xterm-window to start the 'dd' xterm-window.

(If the '.iso' file is a 'hybrid' CD/USB live Linux distro '.iso' file,
the USB drive should become a bootable 'live' Linux USB drive.)

Note: The copy may take several minutes. Summary recs-in-and-out
messages, in the 'dd-xterm', indicate when the copy is done.

Close the 'dd-xterm' to sync the drive --- that is, force unwritten
blocks in file buffers to be written to the drive. Also, 'fdisk -l'
is run again in an xterm --- to verify the FAT32 parition is now
an NTFS partition.

Then it is safe to remove the USB drive and re-insert it in a computer." \
   --entry-text "")

if test "$DRIVE_ID" = ""
then
   exit
fi

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
## Unmount the first (should be only) partition of the drive.
###############################################################

xterm -hold -fg white -bg black -geometry 80x20+250+250 \
      -title "Run 'sudo umount -v ${DEV_DRIVE}1'" -e \
      sudo umount -v ${DEV_DRIVE}1


###############################################################
## Check with the user before running 'dd'.
###############################################################

zenity --question \
   --title "Are you ready to run 'dd'?" \
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
## Start 'top' in an xterm --- in the background.
###############################################################

xterm -hold -fg white -bg black -geometry 80x30+25+300 \
      -title "top" -e top &


###############################################################
## EXECUTE the 'sudo dd if=... of=...' command, in an 'xterm'.
##       Edit this script to remove the 'oflag=direct'
##       option if it is not supported by 'dd' on this host.
##       And can change 'bs='. These are to speedup the copy.
##       1048576 = 1024 x 1024. Could use 'bs=1m'.
###############################################################

xterm -hold -fg white -bg black -geometry 80x40+250+250 \
      -title "Running 'sudo dd if=... of=...' ; WAIT!" -e \
      sudo dd if=$ISOFILENAME  of=$DEV_DRIVE  oflag=direct  bs=1048576


###################################################################
## Force unwritten data from buffers to the USB drive, with 'sync'.
###################################################################

sync

########################################################
## Run the 'sudo fdisk -l' command in an xterm,
## in the background --- to check the changed USB drive.
## Typically the 'W95 FAT32 (LBA)' file type is changed
## to 'NTFS'.
########################################################

xterm -hold -fg white -bg black -geometry 80x40+150+25 \
      -title "Run 'sudo fdisk -l'" -e \
      sudo fdisk -l &