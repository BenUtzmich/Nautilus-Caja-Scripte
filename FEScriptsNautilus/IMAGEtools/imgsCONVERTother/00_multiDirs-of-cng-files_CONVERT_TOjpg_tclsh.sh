#!/bin/sh
##
## Nautilus
## SCRIPT: 00_multiDirs-of-cng-files_CONVERT_TOjpg_tclsh.sh
##
## PURPOSE: For one or more DIRECTORIES of 
##          '.cng' (Complete NationalGeographic) files,
##          this script runs a 'hidden' Tcl script --- .cng2jpg.tcl ---
##          in the directory in which this script lies ---
##          to convert (decode) the '.cng' files to '.jpg' (JPEG) files.
##
## METHOD:  There is no prompt for a parameter.
##
##          Each '.jpg' file is put into the directory with its '.cng'
##          file.
##
##          After each '.jpg' file is created, the corresponding '.cng'
##          file is deleted. Alternatively, ...
##
##          Just in case there are conversion problems, we COULD choose to
##          *not* remove the '.cng' file after the conversions. Instead ...
##
##          One can go to each directory and remove the '.cng' files 
##          with the 'rm *.cng' command --- or make a script like
##          this one to remove the '.cng' files from the selected directories.
##
## HOW TO USE: In Nautilus, navigate to a DIRECTORY OF DIRECTORIES of
##             '.cng' files. Then select the directories to be processed.
##             Then right-click on any of the directories,
##             and choose this Nautilus script to run (script name above).
##
##########################################################################
## Created: 2011dec28
## Changed: 2011dec29 Activate the deletion of the '.cng' files.
## Changed: 2012may14 Changed script name in comments above and touched up
##                    the comments. Changed some indenting below.
###########################################################################

## FOR TESTING: (show the statements as executed)
# set -x

DIR_THISSCRIPT=`dirname $0`

 
HOLD_IFS="$IFS"
## We put a single line-feed in IFS.
IFS='
'

## It would be nice to avoid changing IFS, but I have not
## found another way, yet, to make the 'in' reader
## of the 'for' loop recognize the separate filenames
## when filenames contain spaces.
##   (Perhaps we could use 'sed' to put a quote at the
##    beginning and end of each line in $FILENAMES.)


##################################################
## START THE LOOP on the selected directory names.
##################################################

for DIRNAME
do

   ###########################################################
   ## Get and check that the selected file is a directory.
   ## Skip the selected files that are not directories.
   ##    Assumes one dot (.) in the filename, at the extension.
   ###########################################################
 
   if test ! -d "$DIRNAME"
   then
      continue 
      #  exit
   fi

   ## FOR TESTING:
   #   xterm -hold -fg white -bg black -e echo "DIRNAME: $DIRNAME"
   #   exit

   ###############################################################
   ## If the user does not have write-permission in the
   ## directory $DIRNAME, we could put the output file in  /tmp.
   ###############################################################

   DIROUT="$DIRNAME"
   if test ! -w "$DIRNAME"
   then
      DIROUT="/tmp"
   fi

   ###############################################################
   ## Get the '.cng' filenames in directory $DIRNAME.
   ###############################################################

   FILENAMES=`ls $DIRNAME/*.cng`


   ###############################################################
   ## START THE LOOP ON THE '.cng' filenames in directory $DIRNAME.
   ## (The IFS setting above should handle embedded spaces in filenames.)
   ###############################################################

   for FILENAME in $FILENAMES
   do

      ###########################################################
      ## Get and check that the file extension is 'cng'.
      ## Skip the files that are not '.cng' files.
      ##    Assumes one dot (.) in the filename, at the extension.
      ###########################################################

      FILEEXT=`echo "$FILENAME" | cut -d\. -f2`
 
      if test "$FILEEXT" != "cng"
      then
         continue 
         #  exit
      fi

      ###########################################################
      ## Get the 'midname' of the filename by removing the
      ## extension --- '.cng'.
      ###########################################################

      BASEFILENAME=`basename "$FILENAME"`

      FILENAMECROP=`echo "$BASEFILENAME" | sed 's|\.cng$||'`


      ###########################################################
      ## Prep the output filename.
      ###########################################################

      OUTFILE="${DIROUT}/${FILENAMECROP}.jpg"

      if test -f "$OUTFILE"
      then
         rm -f "$OUTFILE"
      fi


      ###########################################################
      ## Use '.cng2jpg.tcl' to make the 'jpg' file.
      ###########################################################

      $DIR_THISSCRIPT/.cng2jpg.tcl "$FILENAME" "$OUTFILE"

      RETCODE="$?"

      ## FOR TESTING:
      #   xterm -hold -fg white -bg black -e echo "RETCODE: $RETCODE"
      #   exit

      ###########################################################
      ## Remove the '.cng' file if the conversion seems to
      ## have completed successfully.
      ##      COMMENTED FOR NOW.
      ###########################################################

      if test $RETCODE = 0
      then
         rm "$FILENAME"
      fi

   done
   ## BOTTOM OF the 'for FILENAME' loop

done
## BOTTOM OF the 'for DIRNAME' loop

## We could reset IFS, but IFS should not be needed again,
## since we are exiting this script now.
# IFS="$HOLD_IFS"
