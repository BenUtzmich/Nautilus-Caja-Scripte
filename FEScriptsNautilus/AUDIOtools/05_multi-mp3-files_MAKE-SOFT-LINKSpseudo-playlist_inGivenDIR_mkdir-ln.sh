#!/bin/sh
##
## Nautilus
## SCRIPT: 05_multi-mp3-files_MAKE-SOFT-LINKSpseuod-playlist_inGivenDIR_mkdir-ln.sh
##
## PURPOSE: For the mp3 files in the current directory,
##          1. prompts the user for a full-qualified directory name
##             (it should be a subdirectory of an existing directory),
##          2. makes the subdirectory --- if it does not exist already,
##          3. makes 'soft-links' from the selected mp3 files
##             into the new (or previously existing) subdirectory.
##
## METHOD:  Uses 'zenity --info' to popup a window telling how
##          this utility works --- then uses 'zenity --entry'
##          to get the name of the subdirectory to make/use.
##
##          To confirm the making of the links, a list is made with 'ls'
##          and shown to the user in a text-file viewer of the user's
##          choice.
##
## HOW TO USE: In Nautilus, navigate to a directory of mp3 files
##             and select some mp3 files.
##             Then right-click and choose this Nautilus script to run
##             (name above).
##
## Created: 2011nov07
## Changed: 2012feb29 Changed the name of this script, in a comment above.
##                    Clarified some wording in the zenity prompts.

## FOR TESTING: (show statements as they execute)
# set -x

CURDIR="`pwd`"

#############################################################
## A zenity 'info' window to describe how this utility works.
#############################################################

  zenity  --info \
          --title "How this 'Make-Playlist-Subdir-and-Links' utility works." \
          --no-wrap \
          --text  "\
For the mp3 files you selected in the current directory,
   $CURDIR
this utility
1. prompts for a fully-qualified directory name (it should be
   a subdirectory of an existing directory),
2. makes the subdirectory --- if it does not already exist in
   the specified parent directory,
3. makes 'soft-links' from the selected mp3 files
   into the new (or previously existing) subdirectory.
 
An entry-field prompt ask you for the directory in which to make
the 'soft-links' --- also known as 'symbolic links'.

The links will provide you with a 'playlist directory' without
making disk-space-eating, duplicate copies of the audio files.
" &

## Give the user a few seconds to see the usage info before
## displaying the entry GUI for the links-subdirectory name.
sleep 3

######################################################################
## Enter the subdirectory name to be used for the links.
######################################################################

DIR_PARENT="`dirname "$CURDIR"`"

DIR_PLAYLIST=$(zenity --entry \
   --title "Enter a directory into which to make the links to mp3 files." \
   --text "\
Replace the subdirectory name 'whatever' with an appropriate 'playlist directory'
name.
Examples:  heavymetal  OR  funk  OR  favorites3  OR  female  OR  jazzy

NOTE: You can over-ride the parent directory name with a different directory. 

To CANCEL (that is, exit without making the subdirectory or links),
click 'Cancel' or blank out the entire entry before hitting Enter.
" \
   --entry-text "${DIR_PARENT}/whatever")

if test "$DIR_PLAYLIST" = ""
then
   exit
fi


#############################################
## Make the subdirectory if it does not exist
## --- but give the user a chance to cancel.
#############################################

if test ! -d "$DIR_PLAYLIST"
then

   SUBDIR="`basename "$DIR_PLAYLIST"`"
   DIR_ENTERED="`dirname "$DIR_PLAYLIST"`"

   zenity  --question --title "OK to make subdirectory?" \
          --text  "OK to make subdirectory :  $SUBDIR
in directory
   $DIR_ENTERED
?
                   Cancel = No."

   if test $? = 0
   then
      ANS="Yes"
   else
      ANS="No"
   fi

   if test "$ANS" = "Yes"
   then
      mkdir "$DIR_PLAYLIST"
   else
      exit
   fi

fi
## END OF if test ! -d "$DIR_PLAYLIST"


###############################################
## Make the link(s) in the subdirectory ---
## via a LOOP on the filenames.
###############################################
## To handle filenames with embedded spaces,
## we do NOT load a FILENAMES var. Instead,
## we use a 'for' loop WITHOUT the 'in' phrase.
##  Ref: man bash 
###############################################

for FILENAME
do

  ##################################################
  ## Use 'ln -s' to make the links.
  ##################################################
  ## The '--' handles filenames that start with '-'.
  ## It avoids the 'invalid option' error.
  ##################################################

   ln -s -- "${CURDIR}/$FILENAME" "${DIR_PLAYLIST}/$FILENAME"
   
done


#######################################################
#######################################################
## Show the files (links) in the playlist subdirectory.
#######################################################
#######################################################

##############################################
## Prepare the output file --- in dir /tmp.
##############################################

OUTFILE="/tmp/${USER}_playlistDirFILES_via_ls-Ap.txt"

if test -f "$OUTFILE"
then
  rm -f "$OUTFILE"
fi


#####################################
## Generate a heading for the list.
#####################################

DATETIME=`date '+%Y %b %d  %a  %T%p'`

echo "\
..................... $DATETIME ............................

List of files under the directory
  $DIR_PLAYLIST
--- ONE-LEVEL only.

...........................................................................
" >  "$OUTFILE"


#################################################################
## Generate the list.
##
##  The '-p' parm shows directories with an ending slash.
#################################################################

ls -A -p $DIR_PLAYLIST >> "$OUTFILE"


#####################################
## Generate a trailer for the list.
#####################################
SCRIPT_BASENAME=`basename $0`
SCRIPT_DIRNAME=`dirname $0`

echo "
.......................................................................

This list was generated by script
   $SCRIPT_BASENAME
in directory
   $SCRIPT_DIRNAME

Used command
     ls -A -p 

The '-p' requests that directories be listed with an ending slash (/).

..................... $DATETIME ............................
" >>  "$OUTFILE"


###################
## Show the list.
###################

## . $HOME/.gnome2/nautilus-scripts/.set_VIEWERvars.shi

. $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
. $DIR_NautilusScripts/.set_VIEWERvars.shi

$TXTVIEWER "$OUTFILE" &


