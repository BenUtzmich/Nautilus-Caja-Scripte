#!/bin/sh
##
## Nautilus
## SCRIPT: 02_anyfile_COPY-DIRSonly-NOfiles_rsync-include-exclude-dir1-dir2.sh
##
## PURPOSE: For two selected directories, this utility copies the
##          sub-directory structure of the first directory (not the
##          non-directory files in those sub-directories) to the
##          second directory.
##
## METHOD:  Uses 'zenity' with the '--file-selection' option to prompt
##          the user for the 'FIRST' directory.
##
##          Uses 'zenity' with the '--file-selection' option, AGAIN,
##          to prompt the user for the 'SECOND' directory.
##
##          Runs the command
##              rsync -av --include='*/' --exclude='*' dir1/ dir2/
##          in an 'xterm'.
##
##             Alternatively, we could:
##
##             Put the output of the command
##               rsync -av --include='*/' --exclude='*' dir1/ dir2/
##             into a text file.
##
##             Show the text file in a text-file viewer of the
##             user's choice.
##
## NOTE on 'rsync' parms:
##
##     The '-a' (archive) option of 'rsync' is the short way of
##     specifying the following options:
##
##     -r   recursively transfer files
##     -l   'pick up' symlinks
##     -p   retain the permissions of each file
##     -t   retain the time-stamps of each file
##     -g   preserve the group membership of each file
##
## REFERENCES: man rsync
##             and Google terms like 'rsync include exclude directories'
##    
## HOW TO USE: In Nautilus, select ANY file in ANY directory. Then
##             right-click and choose this Nautilus script to run.
##
##             Note: The current directory may be used to initially position
##                   at least one of the file selection GUIs.
#########################################################################
## Created: 2012jul14
## Changed: 2012
#########################################################################

## FOR TESTING: (show statements as they execute)
# set -x

#########################################################
## Get the CURRENT directory name --- to use as a basis
## for at least one of the following file-selection GUIs.
#########################################################

CURDIR="`pwd`"


####################################
## Get the FIRST directory name.
####################################

DIRNAME1=""

DIRNAME1=$(zenity --file-selection \
   --title "Select the FIRST ('FROM') directory for the rsync-copy." \
   --text "\
Select the 'FIRST' directory for the rsync-subdirectory-structure-copy.
" \
   --directory --filename "$CURDIR" --confirm-overwrite)

if test "$DIRNAME1" = ""
then
   exit
fi


####################################
## Get the SECOND directory name.
####################################

DIRNAME2=""

DIRNAME2=$(zenity --file-selection \
   --title "Select the SECOND ('TO') directory for the rsync-copy." \
   --text "\
Select the 'SECOND' directory for the rsync-subdirectory-structure-copy.
" \
   --directory --filename "$CURDIR" --confirm-overwrite)

if test "$DIRNAME2" = ""
then
   exit
fi


###############################################################
## Check with the user before running 'rsync'.
###############################################################

zenity --question \
   --title "Are you ready to run 'rsync'?" \
   --text "\
The directories that you selected are
  $DIRNAME1
and
  $DIRNAME2

The sub-directory structure of the first directory will be
copied under the second directory --- BUT none of the
NON-directory files under the first directory will be copied
under the second directory.

In other words, JUST directories will be created --- no
'regular' files.

If you are NOT SURE that you want to do that,
CANCEL now.

CANCEL or OK?"  --no-wrap

RETCODE=$?

if test $RETCODE = 1
then
   exit
fi

###############################################
## Run the 'rsync' command in an 'xterm'.
###############################################

xterm -hold -fg white -bg black -geometry 80x40+250+250 \
   -title "Run 'rsync' with include and exclude parms." -e \
   rsync -av  --include='*/' --exclude='*'  "$DIRNAME1/" "$DIRNAME2/"
