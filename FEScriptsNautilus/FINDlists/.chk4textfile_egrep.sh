#!/bin/sh
##               
## Nautilus             
## SCRIPT: .chk4textfile_egrep.sh
##                            
## PURPOSE: Finds the lines in a file ($3) that contain given strings ($2),
##          by using egrep. The strings in $2 are to be separated by a 
##          vertical bar ( | ).   $1 contains a 'quiet' indicator.
##
##          Before doing the egrep, this script first tests that the file
##          is a text-type file.
## 
## USED BY: an FE Nautilus script '00_findSTRorSTR_in_dirTEXTFILS...'
##
## MAINTENANCE HISTORY:
## Created: 2011may23 Based on .chk4textfile_grep.sh
## Changed: 

## FOR TESTING: (show statements as they execute)
#  set -x

QUIET="$1"
STRINGS="$2"
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
#         egrep -ni $STRINGS $FILENAME1
# fi
##########################################################################

##########################################################################
##  Show filename only if there is a 'hit' in the file, via 'egrep'. 
##########################################################################

FILETYPE_CHK=`echo "$FILETYPE" | egrep 'text|Mail'`

if test ! "$FILETYPE_CHK" = ""
then

   FOUND_STUFF=`egrep -ni $STRINGS $FILENAME1`

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

