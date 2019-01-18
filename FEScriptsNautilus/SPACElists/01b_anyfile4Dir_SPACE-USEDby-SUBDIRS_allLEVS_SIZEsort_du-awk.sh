#!/bin/sh
##
## Nautilus
## SCRIPT: 02_anyfile4Dir_SPACE-USEDby_SUBDIRS_allLEVS_SIZEsort_du-awk.sh
##
## PURPOSE: This utility will show the space used by all subdirs
##          at all levels under the 'current' directory.
##
## METHOD:  This script puts the output of 'du' in a text file --- after
##          piping the 'du -k' output through 'sort' and 'awk' to produce
##          a nicely formatted report.
##
## HOW TO USE: In the Nautilus file manager, right-click on the name of
##             ANY file (or directory) in ANY Nautilus directory list.
##             Then select this script to run (name above).
##
## Created: 2010apr07
## Changed: 2011may02 Added $USER to a temp filename.
## Changed: 2011may11 Get 'nautilus-scripts' directory via an include script.
## Changed: 2012feb29 Changed the script name in the comment above.
## Changed: 2012sep29 Fixed awk to show complete dirnames when spaces in names.

## FOR TESTING: (show statements as they execute)
#  set -x

############################################################
## Prep a temporary filename, to hold the list of filenames.
##      If the user does not have write-permission to the
##      current directory, we put the list in /tmp.
####################################################################
## NOTE:
## We could simply put the report in the /tmp directory, rather than
## junking up the current directory with this report.
##
## BUT it might be handy to have the last listing to refer to, in
## the directory to which the listing applies.
####################################################################

OUTFILE="${USER}_space_subdirs_all_levs_sizesort_temp.lis"

CURDIR="`pwd`"

if test ! -w "$CURDIR"
then
   OUTFILE="/tmp/$OUTFILE"
fi

if test -f "$OUTFILE"
then
   rm -f  "$OUTFILE"
fi

#########################################################
## Put the hostname in an env var, for use in prompts and
## the report heading.
#########################################################

HOST_ID="`hostname`"


############################################################
## IF THE DIRECTORY SPECIFIED IS '/' or '/usr' or '/home',
## POP A MSG AND EXIT.
############################################################

if test \( "$CURDIR" = "/"  -o  \
   "$CURDIR" = "/usr"  -o  "$CURDIR" = "/usr/" -o \
   "$CURDIR" = "/home" -o  "$CURDIR" = "/home/" \)
then

JUNK=`zenity -- question \
   --title "SubdirSizes,ALL-Levels: EXITING" \
   --text "\
The directory specified was *** $CURDIR ***
on host $HOST_ID

-- one of the 'REALLY BIG' directories:  '/' or '/usr' or '/home'.

There are MANY, MANY THOUSANDS of files in these dirs. It may take
several minutes to answer your query.   EXITING ...

Please change your query to a more specific 'root' directory, like
  /bin  /boot  /cdrom  /dev   /etc      /lib  /media  /mnt
  /opt  /proc  /root   /sbin  /selinux  /srv  /sys    /tmp  /var
OR a specific '/usr' sub-directory, like
  /usr/bin    /usr/games    /usr/include   /usr/lib    /usr/lib32
  /usr/lib64  /usr/local    /usr/sbin      /usr/share  /usr/src
OR a specific user's home directory.
If the root directory allocation on the local machine is nearly full,
per 'df' command, the most likely 'culprits' are  '/var'  or  '/usr/local'."`

   exit

fi
## END OF  if test \( "$CURDIR" = "/"  -o ...


############################################################
## WARN THE USER ABOUT HUGE DIRECTORIES.  GIVE THEM A CANCEL
## A CANCEL OPTION.
############################################################
 
zenity --question \
   --title "SubdirSizes,ALL-Levels: BIG_DIRECTORY_warning" \
   --text "\
IF the directory specified on $HOST_ID, namely
   $CURDIR
is a directory that contains MANY THOUSANDS of
sub-directories (and even more files), it could take multiple minutes
to generate the SUB-DIRECTORY-SIZES (ALL-LEVELS) report.

If this query takes a long time, you can use a command like
        'ps -fu $USER'
on the host --  $HOST_ID -- to check that the query is running.

If you want to cancel the query, you could kill the running 'du' command.

Cancel or OK (Go)?"

## POSSIBLE TEXT TO ADD/SUBSTITUTE ABOVE.
# One option is to try a lower-level directory
# that is likely to have MANY HUNDREDS of
# sub-directories (or less), rather than MANY THOUSANDS.
# 
# Another (fast-response) option, if you want to set up a cron job
# generate a SUBDIRS SIZE REPORT Utility that is a weekly snapshot
# of the subdirectories under the root (/) directory or some other
# very large directory or directories.

if test $? = 0
then
   ANS="OK"
else
   ANS="Cancel"
fi

if test "$ANS" = "Cancel"
then
   exit
fi


#####################################################################
## DIRECTORY CHECKs.
#####################################################################
## CHECK THAT THE CURDIR IS ACCESSIBLE/EXISTS (locally)
## -- on $HOST_ID.
#####################################################################
## For a slightly different technique of handling 'stdout & stderr'
## (with 2>&1), see $FEDIR/scripts/find_big_or_old_files4dir_bygui
#####################################################################
## COMMENTED for now.
#########################

## FOR TESTING:
#  set -x

# DIRCHECK=`ls -d $CURDIR 2> /dev/null`

# if test "$DIRCHECK" = ""
# then
#    zenity --question --title "Exiting." \
#    --text "\
# Specified Directory: $CURDIR
# 
# Not found or does not exist, according to $HOST_ID.
# 
# Exiting.
# "
#    exit
# fi


##########################################################################
## SET REPORT HEADING.
##########################################################################

echo "\
......................... `date '+%Y %b %d  %a  %T%p'` .......................

DISK USAGE (in Megabytes) IN *ALL* SUB-DIRECTORIES

OF DIRECTORY:   $CURDIR    

ON HOST:        ${HOST_ID}

                             SORTED BY *SIZE* --- BIGGEST SUB-DIRECTORIES
                             AT THE TOP.

                             This report was generated by running the
                             'du' command on $HOST_ID .

                             Total usage is shown on the first line, for the
                             top-level directory.
SIZE-SORT
**************
Disk usage
(Megabytes)    Subdirectory name
-------------- ------------------------
TerGigMeg.Kil
  |  |  |   |" > "$OUTFILE"


##########################################################################
## GENERATE REPORT CONTENTS.
##########################################################################

## FOR TESTING:
#  set -x

# du -k "$CURDIR" | sort -k1nr | \

# du -k "$CURDIR" | sort +0 -1nr | \
#    awk '{printf ("%13.3f  %s\n", $1/1000, $2 )}' >> "$OUTFILE"

du -k "$CURDIR" | sort +0 -1nr | \
   awk '{
COLdirnam = index($0,$2)
printf ("%13.3f  %s\n", $1/1000, substr($0,COLdirnam) )
}' >> "$OUTFILE"

##                          | fold -78 >> "$OUTFILE"

## FOR TESTING:
#  set -


########################################################################
## Add TRAILER to report.
########################################################################

SCRIPT_BASENAME=`basename $0`
SCRIPT_DIRNAME=`dirname $0`

echo "\
  |  |  |   |
TerGigMeg.Kil
-------------- ------------------------
(Megabytes)    Subdirectory name
Disk usage
**************
SIZE-SORT

......................... `date '+%Y %b %d  %a  %T%p'` .......................

   The output above was generated by the script

$SCRIPT_BASENAME

   in directory

$SCRIPT_DIRNAME


   It ran the 'du' command on host $HOST_ID .

-----------------
PROCESSING METHOD:

     The script runs a 'pipe' of several commands (du, sort, awk) like:

         du -k <dirname> | sort +0 -1nr | awk '{printf ( ... )}'

     on the specified host,  $HOST_ID .
     
------------
FEATURE NOTE:

     This utility provides size-sorting and columnar-formatting
     that is not available by using only the 'du' command.

......................... `date '+%Y %b %d  %a  %T%p'`........................
" >> "$OUTFILE"


#################################################
## Show the listing.
#################################################

## . $HOME/.gnome2/nautilus-scripts/.set_VIEWERvars.shi

. $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
. $DIR_NautilusScripts/.set_VIEWERvars.shi

$TXTVIEWER "$OUTFILE" &
