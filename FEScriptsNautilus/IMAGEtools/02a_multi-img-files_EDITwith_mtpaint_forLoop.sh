#!/bin/sh
##
## Nautilus
## SCRIPT: 02b_multiEdit_imgFiles_mtPaint_forLoop.sh
##
## PURPOSE: Uses a 'for' loop to pass a user-selected set of image filenames,
##          one at a time, to 'mtPaint'. This script starts up 'mtPaint' one
##          time for each filename. The next instance of 'mtPaint' does not
##          start until the previous instance is closed.
##
##              (It is up to the user to select image files that are
##               in formats that mtPaint reads --- such as
##               JPEG or PNG or GIF.)
##
## METHOD:  Starts up 'mtpaint' in a for-loop over the selected filenames.
##
## HOW TO USE: In the Nautilus file manager, navigate to the desired directory
##             and select one or more image files. Then right-click and
##             select this script to run (name above).
##
## ALTERNATIVES NOTE:
##          This script is an alternative to another script
##               02b_multi-img-files_EDITwith_mtpaint_oneInstance.sh
##          which passes the selected image filenames (over 100, for example)
##          to mtPaint on a command line, which starts up ONE instance of
##          mtPaint --- for ALL the filenames.
##
##          With the 'oneInstance' technique,
##          mtPaint is started WITH a LIST of the filenames on the RIGHT
##          of the mtPaint window. Unfortunately, with that method, mtPaint
##          behaves in a confusing fashion in relation to mouse 'focus'
##          between 
##                - the editing sub-window 
##                - the scrollbar of the editing sub-window, and
##                - the filename sub-window on the right of the mtPaint window.
##
##          Certain mouse clicks cause unintentional switches to the 'next'
##          image file in the list. That is, the 'next' image file becomes
##          the file displayed in the editing window. The user has to be
##          careful to click in the edit sub-window after clicking in the
##          filename list sub-window, to restore 'focus' to the editing
##          sub-window.
##
## NOTE: A THIRD alternative:
##       It would be nice to be able to select a bunch (over 100, say) of
##       image files in a directory, in Nautilus, and then simply right-click
##       and choose to Open mtPaint --- BUT this SIMULTANEOUSLY starts an
##       instance of mtPaint for each image file selected, consuming a huge
##       amount of memory (and starts a ridiculous number of windows).
##
##       This for-loop script avoids that problem.
##
##       However, the right-click-and-choose-mtPaint method IS workable,
##       IF one selects no more than about 8 image files at a time.       
##
###########################################################################
## Created: 2010may19
## Changed: 2011jul07 Changed to handle filenames with embedded spaces.
##                    (Removed use of FILENAMES var and use a 'for' loop
##                     WITHOUT the 'in' phrase.  Ref: man bash )
## Changed: 2012feb29 Touched up the comments above.
## Changed: 2013apr10 Added check for the mtpaint executable.
###########################################################################

## FOR TESTING: (show statements as they execute)
# set -x

#########################################################
## Check if the mtpaint executable exists.
#########################################################

EXE_FULLNAME="/usr/bin/mtpaint"

if test ! -f "$EXE_FULLNAME"
then
   zenity  --info --title "Executable NOT FOUND." \
   --no-wrap \
   --text  "\
The mtpaint executable
   $EXE_FULLNAME
was not found. Exiting.

If the executable is in another location,
you can edit this script to change the filename."
   exit
fi


#######################################################
## Call 'mtpaint' for each filename --- in a 'for' loop.
#######################################################

for FILENAME
do
   # mtpaint "$FILENAME"
   $EXE_FULLNAME "$FILENAME"
done
