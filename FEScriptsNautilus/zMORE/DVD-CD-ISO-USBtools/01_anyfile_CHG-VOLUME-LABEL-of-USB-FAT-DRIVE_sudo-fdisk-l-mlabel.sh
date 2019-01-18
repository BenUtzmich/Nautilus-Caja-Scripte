#!/bin/sh
##
## Nautilus
## SCRIPT: 04_anyfile_CHG-VOLUME-LABEL-of-USB-FAT-DRIVE_sudo-fdisk-mlabel.sh
##
## PURPOSE: Changes the volume label of a USB drive.
##
##          Typically a USB drive is delivered with a rather useless
##          volume label (or none). Example: 'STORE N GO' on most Verbatim
##          USB sticks.
##
##          This utility allows the user to provide a more useful name,
##          such as 'Verbatim16GB' or 'PNY_32GB'.
##
## METHOD:  Uses 'sudo fdisk -l' in an 'xterm' to show the currently
##          connected storage drives --- their partitions and the
##          file-system-types of the partitions.
##
##          Also runs 'mount' in an 'xterm' to show the current volumn name.
##
##          Uses 'zenity' to prompt for a partition identifier --- such as
##          'sdc1' or 'sde1' --- for '/dev/sdc1' or '/dev/sde1'.
##
##          Then uses the 'umount' command to unmount the paritition.
##
##          Then uses 'zenity' to prompt for a volume name.
##
##          Then issues the 'sudo mlabel' command. Example:
##                 sudo mlabel -i /dev/sde1 ::Verbatim16G
##
##          Runs 'mlabel' in an 'xterm', so that messages verify that
##          when the volume renaming is done.
##
## HOW TO USE: In Nautilus, select one or more files in a directory.
##             (The selected files can be directories.)
##             Right click and, from the 'Scripts >' submenus,
##             choose to run this script (name above).
##
## REFERENCES:
##             https://help.ubuntu.com/community/RenameUSBDrive
##
##########################################################################
## Created: 2012apr11
## Changed: 2012may31 Put the 'mlabel' command for the rename in an xterm.
## Changed: 2012jul21 Changed example vol-names in the 'zenity --entry'
##                    prompt for vol-name.
##########################################################################

## FOR TESTING: (show statements as they execute)
#  set -x


################################################
## Run the 'sudo fdisk -l' command in an xterm,
## in the background.
###############################################

xterm -hold -fg white -bg black -geometry 80x40+25+25 \
   -title "Run 'sudo fdisk -l'. See USB drive ID." -e \
   sudo fdisk -l &


################################################
## Run the 'mount' command in an xterm,
## in the background.
###############################################

xterm -hold -fg white -bg black -geometry 80x40+425+25 \
   -title "Run 'mount'. See current USB volume label, if any." -e \
   mount &


##############################################
## Prompt for the target USB partition ID --- 
## without the '/dev/' prefix.
##############################################

sleep 1

PARTITION_ID=""

PARTITION_ID=$(zenity --entry \
   --title "Enter USB PARTITION ID --- example: 'sdc1' or 'sde1'." \
   --text "\
Enter the USB PARTITION ID below -- without the '/dev/' prefix.  Examples:
       sdc1    for /dev/sdc1
       sde1    for /dev/sde1

Use the 'sudo fdisk -l' output  in the 'xterm' that popped up,
to determine the USB PARTITION. Verify the size of the PARTITION.
      Typically the USB drive has a single partition ---
      typically with file-system-type 'W95 FAT32 (LBA)'.

You will be prompted for the new volume label in a following prompt." \
   --entry-text "")

if test "$PARTITION_ID" = ""
then
   exit
fi

DEV_PARTITION="/dev/$PARTITION_ID"

if test "$DEV_PARTITION" = "/dev/sda1" -o "$DEV_PARTITION" = "/dev/sda" -o \
        "$DEV_PARTITION" = "/dev/sdb1" -o "$DEV_PARTITION" = "/dev/sdb" -o \
        "$DEV_PARTITION" = "/dev/sdc1" -o "$DEV_PARTITION" = "/dev/sdc"
then

   zenity --question \
      --title "Is $DEV_PARTITION OK?" \
      --text "\
The partition you selected, $DEV_PARTITION, is one of
/dev/sda1, /dev/sdb1, or /dev/sdc1 --- OR you specified
/dev/sda, /dev/sdb, or /dev/sdc.

If a system has multiple drives and a backup USB drive connected,
sda1, sdb1, and sdc1 might be hard drive partitions.

Is it OK to proceed? Doing so could re-label the wrong drive.

CANCEL or OK?"  --no-wrap

   RETCODE=$?

   if test $RETCODE = 1
   then
      exit
   fi

fi


##############################################
## Prompt for the new volume label.
##############################################

VOLUME_LABEL=""

VOLUME_LABEL=$(zenity --entry \
   --title "Enter the new VOLUME LABEL --- example: 'USB-maker_16GB'." \
   --text "\
Enter the new VOLUME LABEL below --- 11 chars max for FAT, else 16 chars max.
Examples:
   Verbatim16G__ext3   for a 16 Gigabyte Verbatim USB stick with ext3 partition
   PNY__32GB__ext4     for a 32 Gigabyte PNY USB stick with ext3 parition
   KINGST8GFAT         for an 8 Gigabyte Kingston USB stick with FAT partition

NEXT:
After a 'umount' (unmount) of the USB drive partition, in an 'xterm' window,
the 'mlabel' command will be issued --- in an 'xterm' window --- to
put the new volume label on the USB stick.

    Close the 'umount' xterm-window to start the 'mlabel' xterm-window.

Note: The 'mlabel' command completes in an instant.

When it is done, an 'mlabel' query is run in an 'xterm', to confirm
the new volume name.

Furthermore, you can remove the USB drive from its socket
and then re-insert it --- to have it automounted.

The 'mount' command can be used to verify that the USB drive is mounted,
and that the volume name has been changed." \
   --entry-text "")

if test "$VOLUME_LABEL" = ""
then
   exit
fi


###################################################################
## Make an appropriate $HOME/.mtoolsrc file --- to
## avoid the 'mlabel' command failing with a msg like the following:
##
## "Total number of sectors (30258432) not a multiple of sectors per track (63)!
##  Add mtools_skip_check=1 to your .mtoolsrc file to skip this test"
##
## One gets that message if one tries to query the current volume 
## label with:
##    sudo mlabel -i /dev/sde1  -s ::
##
## Once you make the '.mtoolsrc' file, the query gives a response like
##     "Volume label is STORE N GO"
#####################################################################

echo "mtools_skip_check=1" >> $HOME/.mtoolsrc


###############################################################
## Unmount the first (should be only) partition of the drive.
###############################################################

xterm -hold -fg white -bg black -geometry 80x20+250+250 \
   -title "Run 'sudo umount -v $DEV_PARTITION'" -e \
   sudo umount -v $DEV_PARTITION


######################################################
## Run the 'mlabel' command to do the volume rename.
######################################################

xterm -hold -fg white -bg black -geometry 80x40+325+25 \
   -title "Run 'sudo mlabel -i $DEV_PARTITION' -s ::' to SET volname." -e \
sudo mlabel -i $DEV_PARTITION ::$VOLUME_LABEL


######################################################
## Run the 'mlabel -s' command, in an xterm,
## to query the (new) volume name.
###############################################

xterm -hold -fg white -bg black -geometry 80x40+325+25 \
   -title "Run 'sudo mlabel -i $DEV_PARTITION' -s ::' to CHECK volname." -e \
   sudo mlabel -i $DEV_PARTITION -s ::
