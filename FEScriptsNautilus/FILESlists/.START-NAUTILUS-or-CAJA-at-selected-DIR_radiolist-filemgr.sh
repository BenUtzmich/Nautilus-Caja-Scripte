#!/bin/sh
##
## NAUTILUS
## SCRIPT: .START-NAUTILUS-or-CAJA-at-selected-DIR_radiolist-filemgr.sh
##
## PURPOSE: Given a single argument of value 'nautilus' or 'caja', this
##          script starts up Nautilus or Caja at a selected directory.
##
## METHOD:  Uses a 'zenity --radiolist' prompt to present a list
##          of directory 'nicknames'.
##
##          These nicknames correspond to 'bookmarked' or 'favorites'
##          directories of the user.
##
##          The user edits this script to add 'bookmarks' --- nicknames and
##          corresponding full-names (the latter in 'if' statements,
##          as seen below).
##
## HOW USED: 
##         This script is a 'hidden' utility script that is called by un-hidden
##         scripts:
##
##     00_anyfile_START-NAUTILUS-at-selected-DIR_radiolist-nautilus.sh
## and
##     00_anyfile_START-CAJA-at-selected-DIR_radiolist-nautilus.sh
## 
## These 3 scripts are in a 'FILESlists' subdirectory
## of $HOME/.gnome2/nautilus-scripts
## or $HOME/.config/caja/scripts.
##
##########################################################################
## Script
## Created: 2012aug19
## Changed: 2012
##########################################################################

## FOR TESTING: (show statements as they execute, in a terminal window)
#   set -x


if test "$1" = "nautilus"
then
   FILEMGR_EXENAME="nautilus"
   FILEMGR_NAME="Gnome-Nautilus"
else
   FILEMGR_EXENAME="caja"
   FILEMGR_NAME="MATE-Caja"
fi

########################################################
## zenity prompt for a directory id (nickname/shortname)
## -- in a while loop.
########################################################

while :
do

   DIR_NICKNAME=""

   DIR_NICKNAME=$(zenity --list --radiolist \
      --title "Choose DIRECTORY at which to open $FILEMGR_NAME." \
      --height=500 \
      --text "\
Choose a directory (nickname) at which to start $FILEMGR_NAME.

  (You can edit this script to add or delete or change directory
   nicknames and the full names that go with those nicknames." \
      --column "Pick1" --column "Directory (folder)" \
      NO Documents \
      NO DOWNLOADS_xfrs \
      NO IMAGE_CAPTURE \
      NO .mozilla \
      NO nautilus-scripts \
      NO \(caja\)scripts \
      NO apps \
      NO .freedomenv \
      NO tmp \
      NO usr \
      NO share \
      NO etc \
      NO lib \
   )
 
   if test "$DIR_NICKNAME" = ""
   then
      exit
   fi
 
   if test "$DIR_NICKNAME" = "Documents"
   then
      DIR_FULLNAME="$HOME/Documents"
   fi
 
   if test "$DIR_NICKNAME" = "DOWNLOADS_xfrs"
   then
      DIR_FULLNAME="$HOME/DOWNLOADS_xfrs"
   fi
 
   if test "$DIR_NICKNAME" = "IMAGE_CAPTURE"
   then
      DIR_FULLNAME="$HOME/IMAGE_CAPTURE"
   fi
 
   if test "$DIR_NICKNAME" = ".mozilla"
   then
      DIR_FULLNAME="$HOME/.mozilla"
   fi
 
   if test "$DIR_NICKNAME" = "nautilus-scripts"
   then
      DIR_FULLNAME="$HOME/nautilus-scripts"
   fi
 
   if test "$DIR_NICKNAME" = "(caja)scripts"
   then
      DIR_FULLNAME="$HOME/.config/caja/scripts"
   fi
 
   if test "$DIR_NICKNAME" = "apps"
   then
      DIR_FULLNAME="$HOME/apps"
   fi
 
   if test "$DIR_NICKNAME" = ".freedomenv"
   then
      DIR_FULLNAME="$HOME/.freedomenv"
   fi
 
   if test "$DIR_NICKNAME" = "tmp"
   then
      DIR_FULLNAME="/tmp"
   fi
 
   if test "$DIR_NICKNAME" = "usr"
   then
      DIR_FULLNAME="/usr"
   fi
 
   if test "$DIR_NICKNAME" = "share"
   then
      DIR_FULLNAME="/usr/share"
   fi
 
   if test "$DIR_NICKNAME" = "etc"
   then
      DIR_FULLNAME="/etc"
   fi
 
   if test "$DIR_NICKNAME" = "lib"
   then
      DIR_FULLNAME="/usr/lib"
   fi


   ########################################################
   ## Start the specified file manager at the selected dir.
   ##
   ## We start it in the background so that the zenity-radiolist
   ## prompt appears again and can be used to open the file
   ## manager at another directory --- or simply Cancel.
   ########################################################

   $FILEMGR_EXENAME "$DIR_FULLNAME" &

done
## END of while prompting loop.
