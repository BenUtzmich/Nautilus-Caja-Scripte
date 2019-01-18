#!/bin/sh
##
## Nautilus
## SCRIPT: .filecnt_4dir_1level_2stdout.sh
##
## PURPOSE: This script is meant to be called by the script
##          '06_COUNT_FILESinSUBDIRS_ALLlevels_find.sh' in the
##          FE 'SPACEtools' directory of the 'nautilus-scripts' directory.
##
##          For a given fully-qualified Directory name (passed in var $1),
##          this script creates a file-counts output line, using basic
##          commands -- like 'ls -Ap $1' -- along with 'echo',
##          'grep', and 'wc'.
##
##          For the directory $1, the output line shows TWO separate counts:
##              DIRECTORY-file-counts and NON-DIRECTORY-file-counts.
##
##          Note that cmd 'ls -Ap $1' gives the files immediately under the
##          directory.  I.e. the counts from this script are for ONE directory
##          level, NOT multiple directory levels under $1.
##
##          The two counts are gained by piping the output of the 'ls -Ap $1'
##          command to "grep  '/$'"  and  "grep -v  '/$'" --- and then 'wc -l'
##          --- for directory counts and non-directory counts, respectively.
##
##          The output is simply sent to stdout, to be captured by a
##          calling 'find'-command script.
##          
##          A 'parent' script, calling a 'find'-command script that calls
##          this script, may put the full report (stdout), for multiple dirs,
##          into a temp-file (on the host running the 'parent' script)
##          and show the report file with a text-file viewer, like the
##          'xpg' utility.
##          
##          It is the responsibility of the 'find'-command script
##          to supply the one argument.  It is the responsibility of the 
##          'parent' script to check that the host:directory exists.
##          If it does not exist, the 'parent' script would typically pop
##          an error msg and exit.
##          
##    NOTE: There are NO PROMPTS (such as 'zenity' pop-ups) in this script.
##          This script is meant to get its input from $1 and put its output
##          to stdout, silently.
##
## Created: 2011apr27
## Changed: 

## FOR TESTING: (show executed statements)
#  set -x

ALL_FILENAMES=`ls -Ap "$1"`

DIR_CNT=`echo "$ALL_FILENAMES" | grep    '/$' | wc -l`
FIL_CNT=`echo "$ALL_FILENAMES" | grep -v '/$' | wc -l`

## FOR TESTING:
# echo "Directories: $DIR_CNT   Files: $FIL_CNT  in $1"

echo "$DIR_CNT  $FIL_CNT  $1"

