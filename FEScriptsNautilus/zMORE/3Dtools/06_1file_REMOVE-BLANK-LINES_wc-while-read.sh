#!/bin/sh
##
## Nautilus
## SCRIPT: 0x_1file_REMOVE-BLANK-LINES_wc-while-read.sh
##                                 
## PURPOSE: Reads a file and removes blank lines --- lines that
##          contain only a line-feed AND lines that contain only
##          spaces and a line-feed. Puts the output in a new file.
##
##          This is intended to handle 3D data files, containing
##          vertex data records and face/connection recordss, say
##          after reformatting one 3D fromat to another with a
##          text editor and ending up with a lot of blank lines.
##
## METHOD:  Uses a while-read loop to read the user-selected input
##          file, and an 'echo "....." >' statement to
##          concatenate the non-blank lines to the output file.
##
##          Puts the results in a temp file and shows it in a GUI
##          text browser/editor of the user's choice.
##
## HOW TO USE: In Nautilus, navigate to a (text) file, select it,
##             right-click and choose this Nautilus script to run.
##
## Created: 2012aug18
## Changed: 2012

## FOR TESTING: (show statements as they execute)
# set -x

#######################################
## Get the filename.
#######################################

FILENAME="$1"


#######################################################
## Check that the selected file is a text file.
## COMMENTED, for now.
#######################################################

#  FILECHECK=`file "$FILENAME" | egrep 'text|Mail|ASCII'`
 
#  if test "$FILECHECK" = ""
#  then
#     exit
#  fi


################################################################
## Prompt for an end indicator to stop processing the input file.
################################################################

ENDSTRING=""

ENDSTRING=$(zenity --entry \
   --title "Enter an end-of-processing indicator." \
   --text "\
Enter a string that indicates this utility should stop processing
the input file when a record is encountered that contains this
string anywhere in the record (case-sensitive).

Examples:
#textures  - an indicator that texture data records follow and
             no more vertex  and face/connection records.

NOTE: If you enter a string that is not in the file,
      the processing will continue to the end-of-file." \
   --entry-text "#textures")

if test "$ENDSTRING" = ""
then
   exit
fi

#########################################################
## Initialize the output file.
##
## NOTE: If the files is in a directory for which the user
##       does not have write-permission,
##       we put the output file in /tmp rather than in the
##       current working directory.
## CHANGE: To avoid junking up curdir, we use /tmp.
#########################################################

CURDIR="`pwd`"

OUTFILE="${FILENAME}_BLANK-LINES-REMOVED"

# if test ! -w "$CURDIR"
# then
OUTFILE="/tmp/$OUTFILE"
# fi

if test -f  "$OUTFILE"
then
   rm -f "$OUTFILE"
fi



###############################################################
## Use a while-read loop to read the file and remove
## blank lines (line-feed only or spaces and a line-feed).
###############################################################


while read LINE
do

   ## FOR TESTING:
   #   echo "$LINE"


   ## Break out of this read-loop if the end indicator is found.

   ENDCHECK=`echo "$LINE" | grep "$ENDSTRING"`

   if test "$ENDCHECK" -ne ""
   then
      break
   fi


   ## Skip blank lines.

   BLANKCHECK=`echo "$LINE" | sed 's/^ *$/EMPTY/'`

   if test "$BLANKCHECK" = "EMPTY"
   then
      continue
   fi

   ## Write all other lines.

   echo "$LINE" >> "$OUTFILE"

done < "$1"
## END OF LOOP: while read LINE


############################
## Show the list.
############################

## . $HOME/.gnome2/nautilus-scripts/.set_VIEWERvars.shi

. $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
. $DIR_NautilusScripts/.set_VIEWERvars.shi

$TXTVIEWER "$OUTFILE" &
