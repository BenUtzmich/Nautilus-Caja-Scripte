#!/bin/sh
##
## NAUTILUS
## SCRIPT: 01_anyfil_set-Vidout-to-TV-or-Computer-Screen_radiolist_xrandr.sh
##
## PURPOSE: This script is meant to switch the video output of a computer between
##          the computer (typically a netbook or laptop) screen (typical ID = LVDS1)
##          and an attached TV or overhead-projector (typical output ID = VGA1) ---
##          or use both outputs.
##
##          This script may prompt for a specified screen resolution for the port(s)
##          to be used --- and allows both ports to be used. In the latter case,
##          a common (or nearly the same) resolution ('mode') should be used.
##
## CAUTIONS:
##          The '--mode' (xy-size in pixels) parameters prompted for in this script
##          should be set to the sizes of supported by the TV and by the computer.
##
##          When both video ports are to be used simultaneously,
##          the TV resolution and the computer screen resolution should be set close
##          to the same size (so the desktop on the TV looks nearly the same as the
##          computer desktop, with very little clipping for either screen).
##
## *******
## WARNING:
## ******* 
##   Best to connect the TV/projector to the VGA port on the computer
##   ***BEFORE*** booting up the computer.
##############################################################################
##
## METHOD:  Uses a 'zenity --radiolist' prompt to present a list
##          of several video-out reconfig options --- TV-screen-only,
##          LAPtop-screen-only, or both TV-and-LAP.
##
##          Uses 'zenity --entry' prompts to get parameters for the '--output'
##          and '--mode' parameters of 'xrandr', in each of the 3 output
##          config cases.
##
##          Uses 'xrandr' to set the ports on/off and their sizes (modes).
##
## HOW TO USE: 
##         1) In Nautilus, select ANY file in ANY directory.
##            (Note that the selected file and the Nautilus current
##            directory are not used by this script.
##            This is simply a way to get to the Nautilus 'Scripts' menu.)
##         2) Then right-click and choose this script to run (name above).
##
## REFERENCES: 'man xrandr' , 'xrandr -' and ...
##   http://sites.google.com/site/moosyresearch/n210plus
##   http://shallowsky.com/blog/2010/Sep/13/
##   http://kissmyarch.blogspot.com/p/xinitrc.html
##   http://www.google.com/search?q=xrandr++lvds1+vga1+off+on
##   http://en.wikipedia.org/wiki/RandR
##   https://wiki.ubuntu.com/X/Config/Resolution
##
#########################################################################
## EXAMPLE xrandr QUERY OUTPUT:
##
## When my Samsung LN46D630-M3FXZA TV is connected to my Acer netbook 
## with Intel N450 processor (TV connected BEFORE computer bootup,
## TV set in 'PC mode'), 'xrandr -q' gives:
##
## $ xrandr -q
## Screen 0: minimum 320 x 200, current 1024 x 600, maximum 4096 x 4096
## VGA1 connected (normal left inverted right x axis y axis)
##    1920x1080      60.0 +
##    1280x1024      75.0  
##    1360x768       60.0  
##    1152x864       75.0  
##    1024x768       75.1     70.1     60.0  
##    832x624        74.6  
##    800x600        72.2     75.0     60.3  
##    640x480        72.8     75.0     66.7     60.0  
##    720x400        70.1  
## LVDS1 connected 1024x600+0+0 (normal left inverted right x axis y axis) 222mm x 125mm
##    1024x600       60.0*+
##    800x600        60.3  
##    640x480        59.9 
##
## Note: VGA1 is the TV; LVDS1 is the Acer netbook.
##
#######################################################################
## Created: 2012mar18 Based on a PRINTtools '_radio-list.sh' script.
## Changed: 2012may12 Changed script name in comments above and touched up
##                    the comments above. Changed some comments below.
## Changed: 2013apr11 Added 'zenity --entry' prompts for port ID and
##                    mode (resolution) parameters.
#######################################################################

## FOR TESTING: (show statements as they execute, in a terminal window)
#   set -x

###############################################
## zenity prompt for a video-out config:
## TV-screen-only, computer-screen-only, or both.
###############################################

VIDOUT_OPT=""

VIDOUT_OPT=$(zenity --list --radiolist \
   --title "Which VIDEO-OUT config to set?" \
   --height 400 \
   --text "\
Choose a video-out configuration.

TV may be an overhead-projector.
The computer is typically a laptop or netbook.

***WARNING:
   You should connect the TV (or projector) to the VGA/HDMI port
   on the computer *BEFORE* booting up the computer.
" \
   --column "Pick1" --column "VIDOUT-TYPE" \
   YES  TV-SCREEN-ONLY \
   NO   LAP-SCREEN-ONLY \
   NO   TV-and-LAP)
 
if test "$VIDOUT_OPT" = ""
then
   exit
fi


#######################################################################
## Handle the 'TV-SCREEN-ONLY' case.
#######################################################################

if test "$VIDOUT_OPT" = "TV-SCREEN-ONLY"
then
     
   ###############################################################
   ## Prompt for output-ID and mode (resolution) for the TV screen.
   ###############################################################

   TV_ID_RES=""

   TV_ID_RES=$(zenity --entry --title "Enter output-ID and mode for the TV." \
   --text "\
For TV-SCREEN-ONLY config:
Enter the output-ID and mode (resolution) to use for the TV/projector screen.

You can use the 'SHOW-VIDEO-PORTS' FE Nautilus script --- or the
'xrandr -q' command --- to see a list of the IDs of connected video
devices and their supported resolutions.

Example: VGA1 1024x768
" \
   --entry-text "VGA1 1024x768")

   if test "$TV_ID_RES" = ""
   then
      exit
   fi

   TV_ID=`echo "$TV_ID_RES" | cut -d' ' -f1`
   TV_RES=`echo "$TV_ID_RES" | cut -d' ' -f2`


   ###############################################################
   ## Prompt for output-ID of the computer screen.
   ###############################################################

   LAP_ID=""

   LAP_ID=$(zenity --entry --title "Enter output-ID for the COMPUTER." \
   --text "\
For TV-SCREEN-ONLY config:
Enter the output-ID to use for the COMPUTER screen.
(to turn off output to that screen)

You can use the 'SHOW-VIDEO-PORTS' FE Nautilus script --- or the
'xrandr -q' command --- to see a list of the IDs of connected video
devices.

Example: LVDS1
" \
   --entry-text "LVDS1")

   if test "$LAP_ID" = ""
   then
      exit
   fi

   ###############################################################
   ## Issue the 'xrandr' command to stop output to the computer
   ## screen and establish appropriate output to the TV/projector.
   ###############################################################

   ## Example of using 2 'xrandr' commands:
   ## xrandr --fb $TV_RES3 --output VGA1 --auto
   ## xrandr --output LVDS1 --off

   xrandr --output "$LAP_ID" --off --output "$TV_ID"  --mode "$TV_RES"

fi
## END OF "TV-SCREEN-ONLY" section


#######################################################################
## Handle the 'LAP-SCREEN-ONLY' case.
#######################################################################

if test "$VIDOUT_OPT" = "LAP-SCREEN-ONLY"
then

   ###############################################################
   ## Prompt for output-ID and mode (resolution) for the LAP screen.
   ###############################################################

   LAP_ID_RES=""

   LAP_ID_RES=$(zenity --entry --title "Enter output-ID and mode for the COMPUTER." \
   --text "\
For LAP-SCREEN-ONLY config:
Enter the output-ID and mode (resolution) to use for the COMPUTER screen.

You can use the 'SHOW-VIDEO-PORTS' FE Nautilus script --- or the
'xrandr -q' command --- to see a list of the IDs of connected video
devices and their supported resolutions.

Example: LVDS1 1024x600
" \
   --entry-text "LVDS1 1024x600")

   if test "$LAP_ID_RES" = ""
   then
      exit
   fi

   LAP_ID=`echo "$LAP_ID_RES" | cut -d' ' -f1`
   LAP_RES=`echo "$LAP_ID_RES" | cut -d' ' -f2`

   ###############################################################
   ## Prompt for output-ID of the TV/projector screen.
   ###############################################################

   TV_ID=""

   TV_ID=$(zenity --entry --title "Enter output-ID for the TV/projector." \
   --text "\
For LAP-SCREEN-ONLY config:
Enter the output-ID to use for the TV/projector screen.
(to turn off video output to that screen)

You can use the 'SHOW-VIDEO-PORTS' FE Nautilus script --- or the
'xrandr -q' command --- to see a list of the IDs of connected video
devices.

Example: VGA1
" \
   --entry-text "VGA1")

   if test "$TV_ID" = ""
   then
      exit
   fi


   ###############################################################
   ## Issue the 'xrandr' command to stop output to the TV/projector
   ## screen and establish appropriate output to the computer.
   ###############################################################

   ## Example of using 2 'xrandr' commands:
   ## xrandr --fb $LAP_RES --output LVDS1 --auto
   ## xrandr --output VGA1 --off

   xrandr --output "$TV_ID" --off --output "$LAP_ID"  --mode "$LAP_RES"

fi
## END OF "LAP-SCREEN-ONLY" section


#######################################################################
## Handle the 'TV-and-LAP' case.
#######################################################################

if test "$VIDOUT_OPT" = "TV-and-LAP"
then

   ###############################################################
   ## Prompt for output-ID and mode (resolution) for the LAP screen.
   ###############################################################

   LAP_ID_RES=""

   LAP_ID_RES=$(zenity --entry --title "Enter output-ID and mode for the COMPUTER." \
   --text "\
For TV-and-LAP config:
Enter the output-ID and mode (resolution) to use for the COMPUTER screen.

You can use the 'SHOW-VIDEO-PORTS' FE Nautilus script --- or the
'xrandr -q' command --- to see a list of the IDs of connected video
devices and their supported resolutions.

Example: LVDS1 1024x600
" \
   --entry-text "LVDS1 1024x600")

   if test "$LAP_ID_RES" = ""
   then
      exit
   fi

   LAP_ID=`echo "$LAP_ID_RES" | cut -d' ' -f1`
   LAP_RES=`echo "$LAP_ID_RES" | cut -d' ' -f2`


   ###############################################################
   ## Prompt for output-ID and mode (resolution) for the TV screen.
   ###############################################################

   TV_ID_RES=""

   TV_ID_RES=$(zenity --entry --title "Enter output-ID and mode for the TV." \
   --text "\
For TV-and-LAP config:
Enter the output-ID and mode (resolution) to use for the TV/projector screen.

The resolution should be the same-as or close-to the resolution (mode)
you are using for the computer screen --- $LAP_RES.

You can use the 'SHOW-VIDEO-PORTS' FE Nautilus script --- or the
'xrandr -q' command --- to see a list of the IDs of connected video
devices and their supported resolutions.

Example: VGA1 1024x768
" \
   --entry-text "VGA1 1024x768")

   if test "$TV_ID_RES" = ""
   then
      exit
   fi

   TV_ID=`echo "$TV_ID_RES" | cut -d' ' -f1`
   TV_RES=`echo "$TV_ID_RES" | cut -d' ' -f2`


   ###############################################################
   ## Issue the 'xrandr' command to send output to the TV/projector
   ## screen and also send output to the computer.
   ###############################################################

   ## Example of using 2 'xrandr' commands:
   # xrandr --fb $LAP_RES --output LVDS1 --auto
   # xrandr --output VGA1 --auto --right-of LVDS1

   ## Example of using 1 'xrandr' command:
   ## xrandr --output VGA1  --mode $TV_RES3 --output LVDS1 --off
   ## Example of using 1 'xrandr' command:
   ## xrandr --output VGA1  --mode $TV_RES3 --output LVDS1 --mode $LAP_RES

   ## Example of using best settings for both monitors
   ## xrandr --output LVDS1 --preferred --output VGA1 --above LVDS1 --primary --preferred

   xrandr --output "$LAP_ID" --mode "$LAP_RES" --output "$TV_ID" --mode "$TV_RES"

fi
## END OF "TV-and-LAP" section
