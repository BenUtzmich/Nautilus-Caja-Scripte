#!/bin/sh
##
## Nautilus
## SCRIPT: cap07_anyfile_Xscreen-DEVaudio_toMPG2_xvidcap_xtermQuit_PRELIM.sh
##
## PURPOSE: Capture X-window activity to an '.mpg' movie file ---
##          video AND audio --- using 'xvidcap'.
##
## METHOD:  COULD use 'zenity --info' to show info on how this utility works.
##
##          Uses 'zenity --entry' to prompt for a 'delay time' to allow time
##          to setup for recording video.
##
##          Runs 'xvidcap' with container, video-codec, audio-codec parms:
##               '--format mpeg2'  and '--codec mpeg2' and '--aucodec mp2'
##          along with other parms such as '--fps 25' and '--audio_in /dev/???'.
##
##          Shows the captured '.mpg' file in a movie player.
##
##      NOTES on 'xvidcap' parms:
##            May need to be careful about the combination of video and
##            audio codecs (and their parameters) that we use, in order
##            to get a good output file.
##
##            May need to set the --cap-geometry' parameter. See the MOVIESIZE
##            variable near the top of this script. I have it set to capture
##            an entire 1024x768 screen.
##
##  REFERENCES: man xvidcap (see its text at the bottom of this script)
##          and
##            do web searches on keywords such as 'xvidcap audio_in codec'
##            or 'ffmpeg x11grab mpeg'.
##          and
##            See http://ubuntuforums.org/showthread.php?t=717842
##            for 'padsp xvidcap' hint.
##
## HOW TO USE: In Nautilus, select ANY file in ANY directory.
##             Then right-click and choose this script to run (name above).
##
##             The delay-time that the user supplied will determine when
##             the 'ffmpeg' command will start in the 'xterm' window.
##
##             The user ends the recording by entering 'q' in the terminal
##             in which 'ffmpeg' is running.
##
################################################################################
## Started: 2011apr20
## Changed: 2011may02 Add $USER to $FILEOUT name.
## Changed: 2012may24 Changed script name in comments above and touched up
##                    the comments. Changed some indenting below.
##############################################################################

## FOR TESTING: (display statements that execute)
# set -x

## COULD be used with the '--cap_geometry' parm of 'xvidcap'?
# MOVIESIZE="1024x768+0+0"

###############################
## Prepare the output filename.
###############################

FILEOUT="/tmp/${USER}_xvidcap_out.mpg"

if test -f "$FILEOUT"
then
   rm -f "$FILEOUT"
fi

############################################################
## Set the delay time (in secs) before video capture starts.
############################################################

DELAYSECS=""

DELAYSECS=$(zenity --entry \
   --title "DelayTime (secs) to capture start - to $FILEOUT" \
   --text "Enter delay-time in seconds:
This allows some setup time before xvidcap starts capturing the screen.
" \
   --entry-text "3")

## Capture geometry: $MOVIESIZE is hardcoded in a variable of this script.

## An xterm will open showing xvidcap msgs during startup and capture.
## Enter Ctl-c in the xterm to stop recording.

if test "$DELAYSECS" = ""
then
   exit
fi

sleep $DELAYSECS



#####################################################
## Capture the X11 screen activities with 'xvidcap'.
#####################################################
## fps values of 10, 15, and 29 gave error popup in an xvidcap GUI window.
## fps 25 seems to work.
##
## Still need to determine a working /dev device (audio, dsp, or whatever).
##
##############################################################################
##  padsp starts the specified program and redirects its access to OSS com-
##  patible audio devices (/dev/dsp and auxiliary devices) to a  PulseAudio
##  sound server.
#############################################################################

# xterm -bg black -fg white -hold -geometry 80x48+500+250 -e \

padsp xvidcap -v --mf --file "$FILEOUT" --format mpeg2 --codec mpeg2 --fps 25 \
          --audio yes --audio_in /dev/audio --aucodec mp2 \
          --audio_bits 64000 --audio_rate 44100 --audio_channels 1 \
          --gui yes

## -v

##          --audio_bits 64000 --audio_rate 44100

## 2011APR20 Can't get this to capture audio.

## See http://ubuntuforums.org/showthread.php?t=717842
## for 'padsp xvidcap' hint.

#####################################################################
## SOME POSSIBLE /dev devices (on my machine, 2011apr)
## $ ls -l /dev |grep audio
## crw-rw----+ 1 root audio    14,  12 2011-04-20 13:57 adsp (causes crash, lots of lib msgs)
## crw-rw----+ 1 root audio    14,   4 2011-04-20 13:57 audio (no audio capture)
## crw-rw----+ 1 root audio    14,  20 2011-04-20 13:57 audio1 (no audio capture)
## crw-rw----+ 1 root audio    14,   3 2011-04-20 13:57 dsp (no audio capture)
## crw-rw----+ 1 root audio    14,  19 2011-04-20 13:57 dsp1 (no audio capture)
## crw-rw----+ 1 root audio    14,   0 2011-04-20 13:57 mixer (causes crash, lots of lib msgs)
## crw-rw----+ 1 root audio    14,  16 2011-04-20 13:57 mixer1 (causes crash, lots of lib msgs)
## crw-rw----+ 1 root audio    14,  32 2011-04-20 13:57 mixer2 (causes crash, lots of lib msgs)
## crw-rw----+ 1 root audio    14,   1 2011-04-20 13:57 sequencer (err msg: Soundcard does not support 16 bit sample format)
## crw-rw----+ 1 root audio    14,   8 2011-04-20 13:57 sequencer2 (causes crash, lots of lib msgs)
#####################################################################

####################################################################
## Could still try other devices, like /dev/snd/controlC1
## /dev/snd
## $ ls -l
## total 0
## drwxr-xr-x  2 root root       60 2011-04-20 13:57 by-id
## drwxr-xr-x  2 root root      100 2011-04-20 13:57 by-path
## crw-rw----+ 1 root audio 116,  8 2011-04-20 13:57 controlC0
## crw-rw----+ 1 root audio 116, 13 2011-04-20 13:57 controlC1
## crw-rw----+ 1 root audio 116, 11 2011-04-20 13:57 controlC2
## crw-rw----+ 1 root audio 116,  7 2011-04-20 13:57 hwC0D0
## crw-rw----+ 1 root audio 116, 10 2011-04-20 13:57 hwC2D0
## crw-rw----+ 1 root audio 116,  6 2011-04-20 23:11 pcmC0D0c
## crw-rw----+ 1 root audio 116,  5 2011-04-20 23:10 pcmC0D0p
## crw-rw----+ 1 root audio 116,  4 2011-04-20 14:00 pcmC0D1p
## crw-rw----+ 1 root audio 116, 12 2011-04-20 14:00 pcmC1D0c
## crw-rw----+ 1 root audio 116,  9 2011-04-20 14:00 pcmC2D3p
## crw-rw----+ 1 root audio 116,  3 2011-04-20 13:57 seq
## crw-rw----+ 1 root audio 116,  2 2011-04-20 13:57 timer
##
## ./by-id:
## total 0
## lrwxrwxrwx 1 root root 12 2011-04-20 13:57 usb-046d_0807_D47C4B60-02 -> ../controlC1
## 
## ./by-path:
## total 0
## lrwxrwxrwx 1 root root 12 2011-04-20 13:57 pci-0000:00:12.2-usb-0:6:1.2 -> ../controlC1
## lrwxrwxrwx 1 root root 12 2011-04-20 13:57 pci-0000:00:14.2 -> ../controlC0
## lrwxrwxrwx 1 root root 12 2011-04-20 13:57 pci-0000:01:05.1 -> ../controlC2
#############################################################################

#####################################################################
## Meaning of the 'popular' xvidcap parms:
##
## -v               = verbose
## --mf or --sf     = multi-frame or single-frame mode
## --file file-name-pattern  OR   - 
## --fps integer    = frames per second (can be decimal in certain cases)
## --cap_geometry geometry
## --rescale size-percentage
## --quality quality-percentage
## --source x11|shm
## --time maximum-duration-in-seconds
## --frames maximum-frames
## --start_no initial-frame-number
## --continue yes|no 
## --gui yes|no
## --auto
##
## --format output-file-format
## --format-help
##   $ xvidcap --format-help
##   xvidcap, ver 1.1.7, (c) rasca, berlin 1997,98,99, khb (c) 2003 - 07
##   Available file formats: xwd, pgm, ppm, png, jpg, avi, divx, asf, flv1,
##   swf, dv, mpeg, mpeg2, vob, mov
##
## --codec video-codec
## --codec-help
##   $ xvidcap --codec-help
##   xvidcap, ver 1.1.7, (c) rasca, berlin 1997,98,99, khb (c) 2003 - 07
##   Available codecs for single-frame capture: pgm, ppm, png, jpeg, mpeg1
##   Available codecs for multi-frame capture: mjpeg, mpeg4, ms_div2,
##   ms_div3, ffv1, flash_video, flash_sv, dv, mpeg2, svq1
##
## --audio yes|no 
## --aucodec audio-codec
## --aucodec-help
##   $ xvidcap --aucodec-help
##   xvidcap, ver 1.1.7, (c) rasca, berlin 1997,98,99, khb (c) 2003 - 07
##   Available audio codecs for multi-frame capture: mp2, mp3, vorbis,
##   ac3, pcm16
##
## --audio_in audio-capture-device OR - 
##
## --audio_bits audio-bit-rate (default 64000)
## --audio_rate audio-sample-rate (default 44100 Hz)
## --audio_channels audio-channels
##
## See 'xvidcap' man help at bottom of this script.
#####################################################################

######################################
## Show the movie file, if it exists.
######################################

if test ! -f "$FILEOUT"
then
   exit
fi

# MOVIEPLAYER="/usr/bin/vlc"
# MOVIEPLAYER="/usr/bin/mplayer"
# MOVIEPLAYER="/usr/bin/gmplayer -vo xv"
# MOVIEPLAYER="/usr/bin/totem"
  MOVIEPLAYER="/usr/bin/ffplay -stats"

xterm -fg white -bg black -hold -geometry 90x48+100+100 \
      -e $MOVIEPLAYER "$FILEOUT"


###############################################################
## Use a user-specified MOVIEPLAYER.  someday?
################################################################

#  . $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
#  . $DIR_NautilusScripts/.set_VIEWERvars.shi

#  $MOVIEPLAYER "$FILEOUT" &

exit

#############################
## 'xvidcap' man help follows.
#############################

NAME
       XVidCap - Record X11 screen portions to video

SYNOPSIS
       xvidcap [-v] [ --mf | --sf ] [--file file name pattern |- ] [--fps
	       frames per second] [--cap_geometry geometry] [--rescale size
	       percentage] [--quality quality percentage] [--source x11|shm ]
	       [--time maximum duration in seconds] [--frames maximum frames]
	       [--start_no initial frame number] [--continue yes|no ] [--gui
	       yes|no ] [--auto] [--codec video codec] [--codec-help]
	       [--format output file format] [--format-help] [--audio yes|no ]
	       [--aucodec audio codec] [--aucodec-help] [--audio_in audio
	       capture device |- ] [--audio_bits audio bit rate] [--audio_rate
	       audio sample rate] [--audio_channels audio channels]

INTRODUCTION
       xvidcap is a tool that captures movement on a selected area of  an  X11
       screen to files. It can operate in two distinct modes: (1) single-frame
       capture or (2) multi-frame capture. In single-frame capture mode  xvid-
       cap  takes  a  configurable  number of screenshots per second and saves
       them to individual files. In  multi-frame  capture  mode  xvidcap  also
       takes  a number of screenshots per second, but encodes them to a single
       video in real time.  Audio capture is only available  with  multi-frame
       formats.

       Recording  in  single-frame  capture mode may be more convenient if you
       wish to preprocess the images before encoding, or  if  you  need  other
       video  codecs  xvidcap does not support. Individual images can later be
       encoded with tools like ffmpeg, mencoder, or transcode.

       For  help,  feature   requests,	 or   bug-reports   please   turn   to
       http://www.sourceforge.net/projects/xvidcap/

OPTIONS
       This  program  follows the usual GNU command line syntax, with long op-
       tions starting with two dashes (--).  A summary of options is  included
       below.

       -v     Runs xvidcap in verbose mode. This will provide more information
	      about user settings, input and output codecs, performance and so
	      forth.  Messages like '"missing XX milli secs .."' while captur-
	      ing mean you are	missing  frames  due  to  lack	of  ressources
	      (dropped	frames).  This	results in a video that will play back
	      too quickly. Note though, that verbose mode slows  down  xvidcap
	      and  may	actually  be  causing frame drops. Try running without
	      verbose mode and watch the frame drop monitor.

       --mf | --sf
	      xvidcap tries to be smart about what capture mode you  want.  If
	      you  specify --file test.avi xvidcap will assume you want multi-
	      frame capture.  You can explicitly specify capture mode  on  the
	      command  line  with  this switch. If, for example, you have your
	      settings properly configured and saved with multi-frame  capture
	      as  the default mode, calling xvidcap --sf will start xvidcap in
	      single-frame capture mode with all stored settings. The  default
	      is multi-frame capture.

       --file file name pattern
	      File  name  or  pattern to use for saving the captured frames. A
	      file name pattern contains printf()-like	formatting  (ref.  man
	      printf)  information  to	make the file name incrementable, e.g.
	      --file out-%02d.xwd.  This is necessary  for  single-frame  cap-
	      ture. xvidcap will replace the first printf() format string with
	      the number of the frame currently captured.  Thus, in the  exam-
	      ple  given,  it  will  write  to	files  out-00.xwd, out-01.xwd,
	      out-02.xwd, etc. The frame number to start with can be specified
	      with --start_no, see above.

	      Multi-frame capture does not need a file pattern. If you specify
	      one nonetheless like --file mymovie-%d.mpeg for example, xvidcap
	      will  replace  the  format string with the number of the current
	      recording session (always starting the count  from  zero).  This
	      will  enable  you  to manually in-/decrement that number, or use
	      the autocontinue feature	(ref.  --continue  below)  effectively
	      creating a series of video files.

       --fps frames per second
	      Specifies  the  number of frames to be captured per second. This
	      parameter accepts floating point values, which allows  for  very
	      low  capture rates like e.g. --fps 0.5 to record one frame every
	      2 seconds. This is only possible in  single-frame  mode.	Codecs
	      used  for  multi-frame  modes  usually only accept certain frame
	      rates as valid. Note that fractional frame rates for codecs like
	      MPEG1  which only accept very specific fractions are disabled in
	      this version due to an inconsistency with fractional timing  be-
	      tween  xvidcap and libavcodec. Only integer frames rates will be
	      accepted here.

       --cap_geometry geometry
	      Specify the geometry as for  e.  g.  xterm,  i.  e.  like  this:
	      widthxheight+x-position+y-position

	      This  overrides  the  default  width  and  height of the capture
	      frame. Use the picker button of the GUI rather than this command
	      line  option to adjust the frame size to a given window. Capture
	      sizes below 20 x 20 don't seem to work  well  with  most	multi-
	      frame capture codecs.

       --rescale size percentage
	      Rescale the output to a percentage of the original input. A val-
	      ue of 25, e. g.  makes the output size  be  25  percent  of  the
	      original input area. Rescaling does not work with XWD output.

       --quality quality percentage
	      Specify  a  value between 0 and 100 to define the quality encod-
	      ing. The default value is 90. Note that the effect  of  a  value
	      below 100 has changed in version 1.1.5.

       --source x11|shm
	      Enable  or disable the usage of the X11 shared memory extension.
	      For shared memory support both client and server have to run  on
	      the  same  host.	If shared memory support is available, xvidcap
	      will use it by default. If your X server and client do  not  run
	      on  the same machine, you need to disable it by passing --source
	      x11.

       --time maximum duration in seconds
	      Specifies the maximum time to capture, a value of 0  will  cause
	      xvidcap  to  capture  until stopped interactively. For any other
	      value any recording session will stop  automatically  after  the
	      specified  number  of  seconds.  This  parameter	conflicts with
	      --frames (see below). If both are given xvidcap will  stop  cap-
	      turing  when  either applies. The program accepts floating point
	      values, e.g. 2.5.

       --frames maximum frames
	      Stops capturing after the specified number of  frames  are  cap-
	      tured.  If  0  xvidcap will capture until stopped interactively,
	      ref. --time above.

       --start_no initial frame number
	      Defines the start number which  should  be  used	for  numbering
	      files. The default value is 0.This parameter is used for single-
	      frame capture only.  The numbering of movie files for --continue
	      always starts at zero.

       --continue yes|no
	      When  multi-frame capture is selected, maximum recording time or
	      frames are specified, and the output filename  is  incrementable
	      (see  --file  below), xvidcap can automatically continue to cap-
	      ture to a new file when one exceeds the maximum  recording  time
	      or  number  of  frames. This will change the behaviour of --time
	      and --frames because recording will not stop  at	the  specified
	      limits,  but  rather start a new video file. The feature is esp.
	      useful if you want to automatically split  your  recording  into
	      chunks  of e. g. five minutes. If no argument --continue is giv-
	      en, xvidcap defaults to no.  Because single-frame capture  needs
	      an  incrementable  filename to count the individual frames, this
	      feature is disabled for single-frame capture.

       --gui yes|no
	      Start xvidcap with or without control GUI overriding  what's  in
	      the  preferences	file.  Running	without GUI will automatically
	      start a single capture session. It  can  be  stopped  by	either
	      specifying one of --time or --frames, or by hitting CTRL-C.

       --auto xvidcap  supports  automatic  detection of parameters for output
	      format, video- and audio codec. If any  of  those  settings  are
	      saved  as  fixed	values	in the stored preferences, they can be
	      overriden by specifying the parameter auto to any of  the  argu-
	      ments --format, --codec, or --aucodec. This argument is a short-
	      hand for setting all three to automatic detection.

       --codec video codec
	      Override preferences and automatic codec selection with the  ex-
	      plicitly specified codec.

       --codec-help
	      List valid codecs.

       --format output file format
	      Override preferences and automatic format selection with the ex-
	      plicitly specified file format.

       --format-help
	      List valid file formats.

AUDIO OPTIONS
       The following options relate to audio capture which is  available  with
       multi-frame output formats only. There audio streams can either be cap-
       tured from a compatible audio device  (e.g.  /dev/dsp)  or  from  STDIN
       (ref. --audio_in below).

       --audio yes|no
	      Enable  or  disable  audio  capture  using default parameters or
	      those saved to the preferences file. If supported  this  is  en-
	      abled by default for multi-frame capture.

       --aucodec audio codec
	      Override	preferences and automatic codec selection with the ex-
	      plicitly specified audio codec.

       --aucodec-help
	      List valid audio codecs.

       --audio_in audio capture device|-
	      Capture audio from the specified device or from stdin. The  lat-
	      ter  allows  for	dubbing  a captured video using a command line
	      like the following. The default is /dev/dsp.

	      cat some.mp3 | xvidcap --audio_in -

       --audio_bits audio bit rate
	      Set the desired bit rate. The default is 64000  bit.  Note  that
	      when using STDIN input the input file will be resampled as need-
	      ed.

       --audio_rate audio sample rate
	      Set the desired sample rate. The default is 44100 Hz. Note  that
	      when using STDIN input the input file will be resampled as need-
	      ed.

       --audio_channels audio channels
	      Set the desired number of channels. The default is 2 for stereo.
	      Any value above 2 is probably only useful with STDIN input and a
	      5-channel AC audio input file or very good  and  rare  recording
	      equipment.
