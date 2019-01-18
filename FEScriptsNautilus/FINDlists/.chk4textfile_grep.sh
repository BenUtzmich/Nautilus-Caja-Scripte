#!/bin/sh
##               
## Nautilus             
## SCRIPT: .chk4textfile_grep.sh
##                            
## PURPOSE: Finds the lines in a file ($3) that contain a given string ($2),
##          by using grep. $1 contains a 'quiet' indicator.
##
##          Before doing the grep, this script first tests that the file
##          is a text-type file.
## 
## USED BY: an FE Nautilus script '00_findSTR_in_dirTEXTFILS...'
##
## MAINTENANCE HISTORY:
## Created: 2010apr12 For Linux (Ubuntu). Based on a 1997 script for SGI IRIX.
## Changed: 2011may23 Changed name of this script to include '_grep'. 

## FOR TESTING: (show statements as they execute)
#  set -x

QUIET="$1"
STRING1="$2"
FILENAME1="$3"

########################################################
## If $1 is 'noquiet', echo the filename to stderr,
## not stdout --- so it does not get put in the listing.
## This is a 'progress' indicator.
########################################################
if test "$QUIET" = "noquiet"
then
   echo "$FILENAME1" 1>&2
fi

FILETYPE=`file "$FILENAME1"`

##########################################################################
##  Show filename even if there are no 'hits' in the file. 
##########################################################################
# FILETYPE_CHK=`echo "$FILETYPE" | grep 'text'`
# 
# if test ! "$FILETYPE_CHK" = ""
# then
#         echo "
# ${FILENAME1} :"
#         grep -ni $STRING1 $FILENAME1
# fi
##########################################################################

##########################################################################
##  Show filename only if there is a 'hit' in the file, via 'grep'. 
##########################################################################

FILETYPE_CHK=`echo "$FILETYPE" | egrep 'text|Mail'`

if test ! "$FILETYPE_CHK" = ""
then

   FOUND_STUFF=`grep -ni $STRING1 $FILENAME1`

   if test ! "$FOUND_STUFF" = ""
   then
      echo "
------------------
${FILENAME1} :

$FOUND_STUFF"
   fi

fi

## FOR TESTING:
#   set -

