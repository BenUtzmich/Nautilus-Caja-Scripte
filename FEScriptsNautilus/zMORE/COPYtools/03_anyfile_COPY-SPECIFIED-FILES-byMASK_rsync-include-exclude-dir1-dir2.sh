#!/bin/sh
##
## Nautilus
## SCRIPT: 03_anyfile_COPY-SPECIFIED-FILES-byMASK_rsync-include-exclude-dir1-dir2.sh
##
## PURPOSE: For two selected directories, this utility copies the
##          user-specified files (according to --include and --exclude parms)
##          of the first directory (under all sub-directories) to the
##          second directory.
##
## METHOD:  Uses 'zenity' with the '--file-selection' option to prompt
##          the user for the 'FIRST' directory.
##
##          Uses 'zenity' with the '--file-selection' option, AGAIN,
##          to prompt the user for the 'SECOND' directory.
##
##          Uses 'zenity --entry' to present the user with a set of sample
##          'rsync' options: '-ni', '--include', and '--exclude' parms. 
##
##          Runs the 'rsync' command in an 'xterm'.  Examples:
##              rsync -a -ni --include='*/' --include='*.jpg' \
##                    --exclude='*EDIT*.jpg' --exclude='*' dir1/ dir2/
##          or
##              rsync -a -ni --include='*/' \
##                    --include='*.mpg' --include='*.mp4' \
##                    --exclude='*CROP*.mpg' --exclude='*CROP*.mp4' \
##                    --exclude='*CLIP*.mpg' --exclude='*CLIP*.mp4' \
##                    --exclude='*bkup*/' \
##                    --exclude='*' dir1/ dir2/
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
##             and Google a set of keywords like
##             'rsync include exclude directories'
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


#################################################
## Get the 'rsync' parms --- esp. '-ni' or '-v'
## --- and '--include=' and '--exclude=' parms.
#################################################

RSYNC_PARMS=""

RSYNC_PARMS=$(zenity --entry \
   --title "Provide '--include' and '--exclude' parms." \
   --text "\
Provide '--include' and '--exclude' parms for the 'rsync -a' command and
the 'FROM' and 'TO' directories
  $DIRNAME1
and
  $DIRNAME2

Examples:

-ni --include='*/' --include='*.jpg' --exclude='*EDIT*.jpg' --exclude='*'

to copy all directory names and only '.jpg' files, but NOT the '.jpg' files
with the string 'EDIT' in their filenames. All other files are excluded.

OR

a more complex example of copying files with 2 different suffixes ---
excluding some of those files, and excluding directories with 'bkup' in
the directory name:

-ni --include='*/' --include='*.mpg' --include='*.mp4'
--exclude='*CROP*.mpg' --exclude='*CROP*.mp4'
--exclude='*CLIP*.mpg' --exclude='*CLIP*.mp4'
--exclude='*bkup*/'  --exclude='*' 

The '-ni' tells 'rsync' to do a 'dry run' --- while itemizing changes
--- that is, listing the files to be copied (created) but not actually
creating them.  Replace '-ni' with '-v' for a 'real' run.

You could use '-nim' and '-vm' to prune empty directories.
" \
   --entry-text "-ni --include='*/' --include='*.jpg' --exclude='*EDIT*.jpg' --exclude='*'")

if test "$RSYNC_PARMS" = ""
then
   exit
fi


###############################################################
## Check with the user before running 'rsync'.
###############################################################

zenity --question \
   --title "Are you ready to run 'rsync'?" \
   --text "\
The 'FROM' and 'TO' directories that you selected are
  $DIRNAME1
and
  $DIRNAME2

The files under the first directory will be
copied under the second directory --- according to the
following 'rsync' parameters:

$RSYNC_PARMS

Some example masks for the '--include' and '--exclude' parms:
  '*/' - refers to any directory
  '*bkup*/' - refers to directories with the string 'bkup' in their name
  '*.jpg' - refers to files with the suffix '.jpg'
  '*EDIT*.jpg' - refers to files with the string 'EDIT' in their
                           filenames and with the suffix '.jpg'.

If you are NOT SURE that you want to do this,
CANCEL now.

CANCEL or OK?"  --no-wrap

RETCODE=$?

if test $RETCODE = 1
then
   exit
fi

###############################################
## Run the 'rsync' command in an 'xterm'.
#######################################################
## NOTE: The 'eval' --- and the back-slashes and
## the double-quotes --- are needed to pass the 'rsync'
## parms properly into the 'xterm' without getting
## too many files copied. It appears that, without the
## 'eval' method, the rsync parameters like '*' were
## getting expanded when we didn't want them to be.
#######################################################

eval xterm -hold -fg white -bg black -geometry 80x40+250+250 \
   -title \"Run 'rsync' with include and exclude parms.\" -e \
   rsync -a  "$RSYNC_PARMS"  "$DIRNAME1/"  "$DIRNAME2/"
