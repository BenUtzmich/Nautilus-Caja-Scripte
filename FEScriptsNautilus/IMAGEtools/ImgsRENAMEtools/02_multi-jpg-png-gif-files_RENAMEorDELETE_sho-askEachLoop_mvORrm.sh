#!/bin/sh
##
## Nautilus
## SCRIPT: 06_multi-jpg-png-gif-files_RENAMEorDELETE_sho-askEachLoop_mvORrm.sh
##
## PURPOSE: Takes a list of selected image files and loops thru the list
##          and for each file
##             1) shows the image file with $IMGVIEWER
##             2) puts up a zenity entry-field prompt to offer to rename the file
##             3) puts up a zenity question prompt whether to delete the file
## 
## METHOD: Rename is done with 'mv' and delete is done with 'rm'.
##
##         NOTE:
##          Of course, you can change $IMGVIEWER to hard-code an image editor
##          program that brings up an image quickly, like 'mtpaint' --- or
##          change $IMGVIEWER to $IMGEDITOR.
##
##          Then you could crop the file (or do some other edit), save it ---
##          then, at the zenity prompts, rename or delete the file.
##             (Ordinarily, you would rename it rather than
##              delete it, if you just went to the trouble to edit it.)
##
##          The delete is done with the 'rm' command, rather than moving
##          the file to Trash.
##
##          The rename is done with the 'mv' command. It simply renames it
##          in the current directory. You can move the file to an appropriate
##          directory after renaming.
##
## HOW TO USE: In Nautilus, select one or more '.jpg', '.png', or '.gif'
##             files.
##             Then right-click and choose this script to run (name above).
##
############################################################################
## Created: 2010aug24
## Changed: 2011may11 Get 'nautilus-scripts' directory via an include script. 
## Changed: 2011jul07 Changed to handle filenames with embedded spaces.
##                    (Removed use of FILENAMES var and use a 'for' loop
##                     WITHOUT the 'in' phrase.  Ref: man bash )
## Changed: 2012may12 Changed script name in comments above and touched up
##                    the comments. Changed some indenting below.
###########################################################################

## FOR TESTING: (show statements as they execute)
# set -x


###########################################
## Set the viewer to use in the loop below.
###########################################

##   . $HOME/.gnome2/nautilus-scripts/.set_VIEWERvars.shi

. $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
. $DIR_NautilusScripts/.set_VIEWERvars.shi


###################################
## START THE LOOP on the filenames.
###################################

for FILENAME
do

   ###########################################################
   ## Check that the file is a 'jpg' or 'png' or 'gif' file.
   ###########################################################

   FILEEXT=`echo "$FILENAME" | cut -d\. -f2`

   if test "$FILEEXT" != "jpg" -a "$FILEEXT" != "png" -a "$FILEEXT" != "gif"
   then
      continue
      # exit
   fi

   ###################################################
   ## Show the file with eog (or mtpaint) or whatever.
   ###################################################

   # $IMGEDITOR "$FILENAME" &
     $IMGVIEWER "$FILENAME" &


   ###################
   ## RENAME option. 
   ###################

   NEWNAME=""

   NEWNAME=$(zenity --entry \
   --title "RENAME file ??" \
   --text "Enter a NEW name for the file, OR close the window or Cancel." \
   --entry-text "$FILENAME")

   if test ! "$NEWNAME" = ""
   then
      mv "$FILENAME" "$NEWNAME"
      FILENAME="$NEWNAME"
   fi


   #############################################
   ## DELETE option.
   #############################################

   zenity --question \
   --title "DELETE file ??" \
   --text "\
Delete '$FILENAME' ?
         Cancel = No."

   if test $? = 0
   then
      rm "$FILENAME"
   fi


   ################
   ## Continue?
   ################

   zenity --question \
   --title "CONTINUE ??" \
   --text "\
Continue processing image files ?

         Cancel = Exit = Stop processing."

   if test ! $? = 0
   then
      exit
   fi

done
## END OF 'for FILENAME' loop
