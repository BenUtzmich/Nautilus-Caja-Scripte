#!/bin/sh
##
## SCRIPT: F2e_anyfile4Dir_LIST-FILES-allLEVS_SHOW-FILE-TYPES_find-d_for-file.sh
##
## PURPOSE: List ALL DIRECTORIES in a directory AND in its
##          subdirectories at ALL levels below --- using 'find'.
##
##          Then list ALL FILES in each directory AND in each of the
##          subdirectories at ALL levels below --- using 'file' on
##          each of the directories found by 'find'.
##
## METHOD:  Uses the 'find -d' command to list all the subdirectories.
##
##          Then in a for-loop, for each of the subdirectory names,
##          uses the 'file' command to show the file-type info for all
##          the files in each subdirectory.
##
##          Puts the output of the 'find' and 'file' commands in a text file.
##          
##          Shows the text file using a text-file viewer of the user's
##          choice.
##
## HOW TO USE: In Nautilus, select any file in the 'navigated to' directory.
##             Then right-click and choose this Nautilus script to run.
##
## Created: 2012dec30
## Changed: 2012mar03 Changed scriptname to include 'SHOW'.

## FOR TESTING: (show statements as they execute)
#  set -x

#################################################
## Prepare the output file.
##
## If the user has write-permission on the
## current directory, put the file in the pwd.
## Otherwise, put the file in /tmp.
##
## CHANGED: We always put the report file in /tmp.
#################################################

CURDIR="`pwd`"

OUTFILE="${USER}_temp_dirAllFilesRecursiveLIST_find-d_for-file.txt"

# if test ! -w "$CURDIR"
# then
  OUTFILE="/tmp/$OUTFILE"
# fi

if test -f "$OUTFILE"
then
  rm -f "$OUTFILE"
fi


#####################################
## Generate a heading for the listing.
#####################################

DATETIME=`date '+%Y %b %d  %a  %T%p'`

echo "\
..................... $DATETIME ............................

**FILE-TYPES** REPORT:

List of SUB-DIRECTORIES under directory
  $CURDIR
--- ALL levels (recursive) ---

followed by a

List of 'regular' FILES under directory
  $CURDIR
and its sub-directories --- ALL levels (recursive) ---

showing **FILE-TYPE** info for each file.

...........................................................................
" >  "$OUTFILE"


############################################
## Generate the directories part of the list.
############################################

echo "
#################
# SUB-DIRECTORIES :
#################
" >> "$OUTFILE"

DIRS=`find . -type d -name '*' -print | sort`

echo "$DIRS" >> "$OUTFILE"

#######################################################
## Generate the files-per-subdirectory part of the list.
#######################################################
## First the files under CURDIR --- then files in each
## of its subdirectories --- using a for-loop.
#######################################################

echo "
#################################
# FILES under 'current' DIRECTORY
#   $CURDIR
# with their FILE-TYPES.
#################################
" >> "$OUTFILE"


FILES=`ls -a -F "$CURDIR" | grep -v '/$'`

for FILE in $FILES
do
   file "./$FILE" >> "$OUTFILE"
done
## END OF LOOP 'for FILE in $FILES'
    

IFS="
"

for SUBDIR in $DIRS
do
   if test "$SUBDIR" = "."
   then
      continue
   fi
   echo "
###########################
# FILES under SUB-DIRECTORY
#   $SUBDIR
# with their FILE-TYPES.
###########################
" >> "$OUTFILE"

  FILES=`ls -a -F "$SUBDIR" | grep -v '/$'`

   for FILE in $FILES
   do
      file "$SUBDIR/$FILE" >> "$OUTFILE"
   done
   ## END OF LOOP 'for FILE in $FILES'
    
done
## END OF LOOP 'for SUBDIR in $DIRS'


#####################################
## Add a trailer to the listing.
#####################################

SCRIPT_BASENAME=`basename $0`
SCRIPT_DIRNAME=`dirname $0`

echo "
...........................................................................
 
This list was generated by script
   $SCRIPT_BASENAME
in directory
   $SCRIPT_DIRNAME

Used command
     find . -type d -name '*' -print |  sort
to get the names of all the sub-directories.

Then used the command
   ls -a -F | grep -v '/$'
on the current directory
   $CURDIR
and all its subdirectories to get a list of the files (including 'hidden' files)
in the current directory and in each sub-directory.

Used the 'file' command on each of those files to show the file-type
for each file.

-----

Filenames ending in asterisk (*) are files that have execute permissions.
     
..................... $DATETIME ............................
" >>  "$OUTFILE"


######################
## Show the list.
######################

## . $HOME/.gnome2/nautilus-scripts/.set_VIEWERvars.shi

. $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
. $DIR_NautilusScripts/.set_VIEWERvars.shi

$TXTVIEWER "$OUTFILE" &
