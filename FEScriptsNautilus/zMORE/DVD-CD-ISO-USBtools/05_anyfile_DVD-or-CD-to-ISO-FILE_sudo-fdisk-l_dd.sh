#!/bin/sh
##
## Nautilus
## SCRIPT: 02_anyfile_DVD-or-CD-to-ISO-FILE_sudo-fdisk-l_dd.sh
##
## PURPOSE: Copies a DVD to a '.iso' file -- using 'umount' and
##          'dd if=... of=... bs=... conv=...'.
##
##          This could be a 1st step for making a bootable 'live' Linux
##          USB boot drive --- from a live distro on a DVD or CD.
##
##          The next step is to use a utility like the feNautilusScript
##             02_one-iso-file_HYBRID-ISO-to-USB-DRIVE_sudo-fdisk-l_dd.sh
##          in the 'ISOtools' group, to make a 'non-persistent' Live distro
##          USB boot drive --- from a 'hybrid' distro on a DVD or CD.
##
##          OR, use the technique outlined at
##             https://www.linux.com/community/blogs/133-general-linux/420179-creating-a-debian-live-usb-flash-drive-with-persistence-for-non-techies
##          to make a 'persistent' Live distro USB boot drive.
##          It uses 'gparted' to make the persistent partition.
##
## METHOD:  Uses 'sudo fdisk -l' in an 'xterm' to show the currently
##          connected storage drives --- their partitions and the
##          file-system-types of the partitions.
##
##          Uses 'zenity' to prompt for a device name --- for the
##          DVD or CD drive, such as
##          'sr0' or 'sr1' --- for '/dev/sr0' or '/dev/sr1'.
##
##          Then uses the 'dd' command to do the copy --- example:
##                
##           sudo dd if=/dev/sr0  of=whatever.iso  bs=2048 conv=sync,notrunc
##
##          Runs 'dd' in an 'xterm', so summary messages indicate
##          when the copy is done. (The copy may take about 8 minutes.)
##
## HOW TO USE: In Nautilus, select one or more files in a directory.
##             (The selected files can be directories.)
##             Right click and, from the 'Scripts >' submenus,
##             choose to run this script (name above).
##
## REFERENCES:
##    http://superuser.com/questions/85987/mac-os-x-best-way-to-make-an-iso-from-a-cd-or-dvd
##
## Created: 2012apr07
## Changed: 2012

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
## Make the name for the output '.iso' file
## --- in the /tmp directory.
###########################################

ISOFILENAME="/tmp/${USER}_temp.iso"

if test -f "$ISOFILENAME"
then
   rm -f "$ISOFILENAME"
fi


###########################################
## Prompt for the DVD/CD drive path --- 
## without the '/dev/' prefix.
###########################################

DRIVE_ID=""

DRIVE_ID=$(zenity --entry \
   --title "Enter DVD/CD DRIVE ID --- ex: 'sdc' or 'sde'." \
   --text "\
Enter the DVD/CD DRIVE ID --- without the '/dev/' prefix.

Examples:
      sr0      for /dev/sr0
      sr1      for /dev/sr1
      dvd3     for /dev/dvd3 
      dvdrw3   for /dev/dvdrw3
      cdrom3   for /dev/cdrom3
      cdrw3    for /dev/cdrw3

Use 'sudo fdisk -l' or 'mount' output to verify the device id
of the DVD/CD drive to be copied to a '.iso' file.

The '.iso' file
   $ISOFILENAME
will be made from the DVD/CD drive, using 'dd' --- in an 'xterm' window
--- after a 'umount', in a preceding 'xterm' window. Close the
'umount' window to start the 'dd' window.

Note: The copy may take about 8 minutes. Summary recs-in-and-out
messages, in the 'dd xterm', indicate when the copy is done.
Close the 'xterm' to sync the drive --- that is, force unwritten
blocks in file buffers to be written to the '.iso' file. Then it is
safe to remove the DVD/CD drive and re-insert it in a computer." \
   --entry-text "")

if test "$DRIVE_ID" = ""
then
   exit
fi

DEV_DRIVE="/dev/$DRIVE_ID"

if test "$DEV_DRIVE" = "/dev/sda" -o "$DEV_DRIVE" = "/dev/sdb" -o
        "$DEV_DRIVE" = "/dev/sdc"
then

   zenity --question \
      --title "Is $DEV_DRIVE OK?" \
      --text "\
The drive you selected, $DEV_DRIVE, is one of
/dev/sda, /dev/sdb, or /dev/sdc.

If a system with multiple drives and a backup DVD/CD drive connected,
these might be hard drives. DANGER! DANGER!

Is it OK to proceed? Doing so would wipe out a hard drive.

CANCEL or OK?"  --no-wrap

   RETCODE=$?

   if test $RETCODE = 1
   then
      exit
   fi


fi


###############################################################
## Unmount the DVD/CD drive.
###############################################################

xterm -hold -fg white -bg black -geometry 80x20+250+250 \
      -title "Run 'sudo umount -v ${DEV_DRIVE}'" -e \
      sudo umount -v ${DEV_DRIVE}


###############################################################
## EXECUTE the 'sudo dd if=... of=...' command, in an 'xterm'.
##       Edit this script to remove the 'oflag=direct'
##       option if it is not supported by 'dd' on this host.
##       And can change 'bs='. These are to speedup the copy.
##       1048576 = 1024 x 1024. Could use 'bs=1m'.
###############################################################

xterm -hold -fg white -bg black -geometry 80x40+250+250 \
      -title "Run 'sudo dd if=... of=..." -e \
      sudo dd if=$DEV_DRIVE  of=$ISOFILENAME  bs=2048 conv=sync,notrunc

###################################################################
## Force unwritten data, from buffers, to the '.iso' file, with 'sync'
## --- for good measure --- in case 'conv=sync' was not enough.
###################################################################

sync
