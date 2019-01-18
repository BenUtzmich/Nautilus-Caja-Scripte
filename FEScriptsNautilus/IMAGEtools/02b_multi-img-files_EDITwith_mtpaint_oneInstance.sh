#!/bin/sh
##
## Nautilus
## SCRIPT: 02b_multi-img-files_EDITwith_mtpaint_oneInstance.sh
##
## PURPOSE: This script passes a set of selected image filenames
##          ('.jpg' or '.png' or '.gif' - or whatever else 'mtpaint' reads)
##          and starts up 'mtpaint' --- with a list of the filenames
##          on the right of the 'mtaint' window.
##
## METHOD:  Starts up 'mtpaint' once --- passing the one instance of 'mtpaint'
##          all the selected filenames.
##
## HOW TO USE: In the Nautilus file manager, navigate to the desired directory
##             and select one or more image files. Then right-click and
##             select this script to run (name above).
##
## PROBLEMS-WITH-THIS-METHOD NOTE:
##          This script passes the selected image filenames
##          (could be over 100, for example)
##          to 'mtpaint' on a command line, which starts up ONE instance of
##          'mtpaint' --- for ALL the filenames.
##
##          With this 'oneInstance' technique,
##          'mtpaint' is started WITH a LIST of the filenames on the RIGHT
##          of the mtPaint window. Unfortunately, with this method, mtPaint
##          behaves in a confusing fashion in relation to mouse 'focus'
##          between 
##                  - the editing sub-window 
##                  - the scrollbar of the editing sub-window, and
##                  - the filename sub-window of the mtPaint window.
##
##          Certain mouse clicks cause unintentional switches to the 'next'
##          image file in the list. That is, the 'next' image file becomes
##          the file displayed in the editing sub-window. The user has to be
##          careful to click in the edit sub-window after clicking in the
##          filename sub-window, to restore 'focus' to the editing sub-window.
##
## ALTERNATIVES NOTE:
##          This script is an alternative to another script
##               02a_multi-img-files_EDITwith_mtpaint_for-loop.sh
##          which passes the selected image filenames to
##          an instance of 'mtpaint', for each image file, in a
##          for-loop.
##
##          That for-loop script is probably the LEAST problematic method.
##
## NOTE: It would be nice to be able to select a bunch of image files
##       in a directory, in Nautilus, and then simply right-click
##       and choose to Open 'mtpaint' --- BUT this starts an instance
##       of mtpaint, simultaneously, for each image file selected.
##       TOO MANY WINDOWS and too much memory hogging.
##
##       This right-click-and-choose-mtPaint method IS workable,
##       IF one selects no more than about 8 image files at a time.
##
#########################################################################
## Created: 2010apr20
## Changed: 2011jul07 Using "$@" to pass all the filenames to 'mtpaint'.
##                    (Handles spaces in filenames.  Ref: man bash )
## Changed: 2012feb29 Touched up the comments above.
## Changed: 2013apr10 Added check for the mtpaint executable. 
#########################################################################

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



#####################################################
## Call 'mtpaint' with all the filenames passed on the
## command line.
#####################################################

# mtpaint "$@"

$EXE_FULLNAME "$@"
