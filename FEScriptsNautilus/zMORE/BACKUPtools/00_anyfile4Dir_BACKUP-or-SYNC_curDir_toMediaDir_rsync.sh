#!/bin/sh
##
## Nautilus
## SCRIPT: 00_anyfile4Dir_BACKUP-or-SYNC_curDir_toMediaDir_rsync.sh
##
## PURPOSE: Runs the 'rsync' command to backup (first time) or synchronize
##          (subsequent times) all the files and directories in and under
##          the current directory TO a directory that has been created
##          for backup.
##
## METHOD:  Typically the 'TO' directory is on a USB drive or USB 'stick'
##          that has been mounted to a '/media' directory. (On Ubuntu,
##          USB drives are auto-mounted to the '/media' directory. For other
##          versions of Linux a different directory may be the mount point.)
##
##          Uses the 'rsync' command to do the backup/synchronization.
##
##          Uses 'zenity' with the '--file-selection' option to prompt
##          the user for the 'TO' directory.
## 
##          Runs 'rsync' in an 'xterm' window so that the user can see
##          rsync messages as the backup/syncronization proceeds ---
##          and so the user knows when the process has ended.
##
## HOW TO USE: In Nautilus, navigate to the 'FROM' directory and select
##             any file or directory in the 'FROM' directory. Right-click
##             and choose this script to run (script name above), via the
##             'Scripts >' option of the right-click menu.
##
############################################################################
## Here is 'rsync' info from
##    Linux Format Magazine #130, Apr 2010, p.105, Answers section
## (This 'Answer' gave a quick summary of the most-used options of 'rsync'
##  --- much more compact than the 3300 line 'man rsync' output.)
##
## 'rsync' only copies files that are different. With large files that
## have changed, it only copies the parts that have been altered.
## Its main parameters are a 'from' directory and a 'to' directory.
##
## The '--delete' option removes files not present on the first directory.
## The '--archive' option causes all file permissions and timestamps to
## be copied.
##
## The trailing slashes on the directory names are important because
## they indicate that you want to sync the contents of the folders.
## If you omit them, you could end up copying one directory into another.
##
###########################################################################
## Since we may be using an MS Windows FAT file system on the 'to' drive,
## we use '--modify-window=1', as explained here via 'man rsync':
##
## --modify-window
##	      When  comparing  two  timestamps, rsync treats the timestamps as
##	      being equal if they differ by no	more  than  the  modify-window
##	      value.   This  is  normally  0 (for an exact match), but you may
##	      find it useful to set this to a larger value in some situations.
##	      In  particular,  when  transferring to or from an MS Windows FAT
##	      filesystem (which represents times with a 2-second  resolution),
##	      --modify-window=1 is useful (allowing times to differ by up to 1
##	      second).
###########################################################################
## Script
## Created: 2012feb10
## Changed: 2012apr18 Changed script name in comments above and touched up
##                    the comments. Changed some indenting below.
##########################################################################

## FOR TESTING: (show statements as they execute)
#  set -x


####################################################################
## Get the current ('FROM') directory filename.
####################################################################

FROMDIR="`pwd`"


##########################################################
## Get the 'TO' directory, using 'zenity'
## with the '--file-selection' option.
##########################################################

TODIR=""

TODIR=$(zenity --file-selection \
   --title "Select the TO-directory for the backup/synchronization." \
   --text "\
Enter the TO-directory for the 'rsync' backup/synchronization of the
FROM-directory : $FROMDIR 

NOTE: Typically the 'final-subdirectory' of the TO-directory is the
same as the 'final-subdirectory' of the FROM-directory. Example:
FROM-directory: $HOME/userid
TO-directory: /media/USBstick_16GB/userid

An 'xterm' will be started up in which the 'rsync' messages will be
shown --- so you can see the progress of the backup/synchronization
--- and so that you can see when it has completed." \
   --directory --filename "/media" --confirm-overwrite)

if test "$TODIR" = ""
then
   exit
fi

##########################################################
## Confirm the 'TO' directory choice, using 'zenity'
## with the '--question' option.
##
## From 'man 'zenity':
## 'zenity --question' will return either 0 or 1, depending
## on whether the user pressed OK or Cancel.
##########################################################

zenity --question \
   --title "Is the TO-directory selection OK?" \
   --text "\
You selected
    $TODIR
as the TO-directory. And ...
This utility will use
    $FROMDIR
as the FROM-directory.

NOTE: Usually you want the SAME subdirectory name at the end
of the FROM and TO directory names.

The files and directories 'UNDER'
    $FROMDIR
will be put 'UNDER'
    $TODIR

Warning:
If you have accidentally deleted files or directories UNDER
  $FROMDIR ,
those same files and directories (in the same directory locations)
will be deleted UNDER
  $TODIR
--- because of the '--delete' option on this synchronization utility.

CANCEL or OK?"  --no-wrap

RETCODE=$?

if test $RETCODE = 1
then
   exit
fi


##################################################################
## Run 'rsync' to sync "$FROMDIR/" with "$TODIR/".
## Run 'rsync' in a terminal, to show messages.
##################################################################

## FOR TESTING: (This keeps the 'rsync' from actually running,
##               so we can test the previous statements, like zenity.)
#   xterm -hold -bg black -fg white -e \
#      echo "Testing. rsync messages would show here."
#   exit

xterm -hold -bg black -fg white -e \
   rsync --archive --delete -v  --modify-window=1 \
  "$FROMDIR/" "$TODIR/"

## NOTE1: One danger of using '--delete' is:
## If you accidentally delete directories or files under the $FROMDIR,
## then, to synchronize the TODIR with the FROMDIR, those same directories
## and files are removed from the TODIR --- leaving you with no copies
## of those directories and files (unless you have other backups).

## NOTE2:
## Could try '-vv' instead of '-v'. But '-vv' gives too much output
## when there are many files in the 2 directories --- because it lists
## every file, even if it is not being deleted or copied.
