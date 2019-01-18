#!/bin/sh
##
## Nautilus
## SCRIPT: 10_anyfile_SHOW-TABLES_ASCII-Control-Codes-Pasteable_dec-hex-oct_txtviewer.sh
##
## PURPOSE: This script generates a text file containing one-byte
##          ASCII control codes, with short text description
##          beside each code.
##
##          You can paste codes from this file into your text files,
##          if you do not know how to enter control codes with your
##          text editor. For example ...
##
##          I have not been able to find/Google (2010aug) any
##          information on how to enter control codes when using the
##          'gedit' editor.
##          
##          With the old, Motif-based 'nedit' editor, you can, for example,
##          enter the <Esc> code (hex 1b or decimal 27) by using the
##          'Edit, Insert Ctrl Code' menu pull-down to enter decimal 27,
##          after positioning the cursor where you want the code
##          inserted.
##
##          BUT, with this text file, it DOES NOT MATTER WHICH TEXT
##          EDITOR YOU USE --- you can simply copy-and-paste control
##          codes from this text file into the text file you are editing.
##
## METHOD: This script shows the text file with a textfile-viewer of
##         the user's choice.
##
## HOW TO USE: In Nautilus, select ANY file in ANY directory.
##             Then right-click and choose this script to run (name above).
##
#############################################################################
## Created: 2010aug26
## Changed: 2011may02 Added $USER to a temp filename.
## Changed: 2011may11 Get 'nautilus-scripts' directory via an include script.
## Changed: 2012may11 Changed script name in comments above and touched up
##                    the comments. Changed some indenting below.
############################################################################

## FOR TESTING: (show statements as they execute)
#  set -x


############################################
## Prepare the output filename.
##
## If the current directory is NOT writable,
## put the output file in /tmp.
############################################

FILEOUT="${USER}_ascii_control_codes_pasteable.txt"

THISDIR="`pwd`"

## FOR TESTING:
#   zenity -info -text "THISDIR = $THISDIR"

if test ! -w "$THISDIR"
then
   FILEOUT="/tmp/$FILEOUT"
fi

if test -f "$FILEOUT"
then
   rm -f "$FILEOUT"
fi


#######################################
## Put (echo) the text into $FILEOUT.
#######################################

echo "\
###################
ASCII CONTROL CODES - for decimal 0 thru 31 (hex 00 thru 1F ; octal 000 thru 037)
###################

** The ONE-BYTE control codes below can be pasted into text files. **

For example, the Escape code (corresponding to decimal 27) is handy to paste into
files such as script files that send control codes and commands to printers.

The control codes are in the FIRST BYTE (character) of each line, below.

The NUL code (octal 000) was causing a problem in getting the rest of the
lines into this file, so the first byte of the NUL line is simply a space,
NOT the NUL control code (hex 00 or 8 zero bits). [The NUL code is interpreted
as an end-of-file indicator by some programs/commands.]

----------------------------------------------------------------------------------

NOTE:
      The control codes will display differently in different editors or
      text display utilities.

-----
gedit:

      If you bring up this text file in the 'gedit' Gnome text editor,
      the ONE-byte control codes show as a little square, the size of
      ONE character.
      For example:
      The one-byte 'escape-code' (corresponding to decimal 27, hex 1B),
      shows as a little square --- with '0 0' in a tiny little first row
      within the square and '1 B' in the tiny second row.

      In 'gedit', there are a few codes for which you will not see the
      'little square'. You will see that the 'line-feed' and 'carriage-return'
      lines appear as if a blank line is above them --- and the columns of
      text are shifted to the left.

      Also in 'gedit', the 'horizontal tab'  line has the columns of text
      shifted to the right --- and no little square.

      Because such shifts and blank lines make it difficult to tell just where
      the control code was, a period (.) was put on the right of each control
      code. So the control code is (or was) just to the left of that period
      (or on the blank/null line just above the period).

-----
nedit:

      In the 'nedit' text editor, the ONE-byte 'escape-code' is rendered
      as the FIVE characters '<esc>'.

      The other codes are also shown as 2 or 3 characters with a less-than
      sign on the left and a greater-than sign on the right.

      The 'horizontal-tab' and the 'line-feed' lines appear like they did
      in 'gedit'. (See above.)

------
Tcl-Tk:

      In the text widget of a Tcl-Tk file browser, like in 'xpg' of the FE
      (Freedom Environment) system, the ONE-byte control codes are rendered
      as FOUR characters. Example: the 'escape-code' is rendered as
      '\x1b'. In other words, each control code is rendered as '\x'
      (back-slash and lower-case x) followed by a 2 character hex code.

      In the text widget of Tcl-Tk, there are a few exceptions. Some codes
      are rendered as back-slash and a lower-case letter:
          - The BEL code is rendered as 'back-slash, then a'.
          - The BS (backspace) code is rendered as 'back-slash, then b'.
          - The VT (vertical tab) code is rendered as 'back-slash, then v'.
          - The FF (form feed) code is rendered as 'back-slash, then f'.

      The 3 codes 'line-feed', 'carriage-return', and 'horizontal-tab' are
      special cases.  You will see that the 'line-feed' and 'carriage-return'
      lines appear as if a blank line is above them --- and the columns of
      text are shifted to the left.

      Also in a Tcl-Tk text widget, the 'horizontal tab'  line has the
      columns of text shifted to the right.

      Because such shifts and blank lines make it difficult to tell just where
      the control code was, a period (.) was put on the right of each control
      code. So the control code is (or was) just to the left of that period
      (or on the blank/null line just above the period).

------
kwrite:

      The 'kwrite' window comes up slower than the others, the first time
      that 'kwrite' is invoked in a session. When the 'kwrite' window appears,
      it shows the control codes in column one as little one character symbols
      --- for example, some of them look like musical notes --- one symbol looks
      an eighth note, one looks like a quarter note, one looks like a pair of
      eighth notes.

      The line-feed, carriage-return, and horizontal-tab characters are
      shown like 'gedit' (see above) and the Tcl-Tk text widget.

----------------------------------------------------------------------------------

Ctl         Deci
Code  Octal mal   Hex   Description
----  ----- ----  ---   ----------------------
 .    000   0     00    NUL
\001.   001   1     01    SOH (start of heading)
\002.   002   2     02    STX (start of text)
\003.   003   3     03    ETX (end of text)
\004.   004   4     04    EOT (end of transmission)
\005.   005   5     05    ENQ (enquiry)
\006.   006   6     06    ACK (acknowledge)
\007.   007   7     07    BEL (bell)
\010.   010   8     08    BS  (backspace)
\011.   011   9     09    HT  (horizontal tab)
\012.   012   10    0A    LF  (new line)
\013.   013   11    0B    VT  (vertical tab)
\014.   014   12    0C    FF  (form feed)
\015.   015   13    0D    CR  (carriage ret)
\016.   016   14    0E    SO  (shift out)
\017.   017   15    0F    SI  (shift in)
\020.   020   16    10    DLE (data link escape)
\021.   021   17    11    DC1 (device control 1)
\022.   022   18    12    DC2 (device control 2)
\023.   023   19    13    DC3 (device control 3)
\024.   024   20    14    DC4 (device control 4)
\025.   025   21    15    NAK (negative ack.)
\026.   026   22    16    SYN (synchronous idle)
\027.   027   23    17    ETB (end of trans. blk)
\030.   030   24    18    CAN (cancel)
\031.   031   25    19    EM  (end of medium)
\032.   032   26    1A    SUB (substitute)
\033.   033   27    1B    ESC (escape)
\034.   034   28    1C    FS  (file separator)
\035.   035   29    1D    GS  (group separator)
\036.   036   30    1E    RS  (record separator)
\037.   037   31    1F    US  (unit separator)
" > "$FILEOUT"


#########################
## Show the output file.
#########################

## . $HOME/.gnome2/nautilus-scripts/.set_VIEWERvars.shi

. $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
. $DIR_NautilusScripts/.set_VIEWERvars.shi

$TXTVIEWER  "$FILEOUT"


#########################################################################
## The following statement keeps this script from completing,
## so that the script can be tested --- with output to stdout and
## stderr showing in a terminal --- when using Nautilus
## 'Open > Run in a Terminal'. NOTE: Since xpg runs as a 'background'
## process, the terminal window would, without the statement below,
## immediately close after xpg shows the file, killing 'xpg' in the process.
## (Also could use 'xpg -f'.)
##
## Comment this line, to deactivate it.
#########################################################################
#   read ANY_KEY_to_exit
