#!/bin/sh
##
## SCRIPT: htm02_multi-img-files_imgsSLIDESHOW_FIT2page_echo_for-loop.sh
##
## PURPOSE: Generate a SLIDESHOW HTML page for showing a sequence of
##          user-selected image files ('.jpg' or '.png' or '.gif' or whatever)
##          fit into an area at least 300 pixels high on the page.
##
##          Controls (links) are provided on the HTML page for
##            - auto-stepping through the images, with a given delay time
##              per image
##            - manually stepping forward or backward through the images
##            - zooming the displayed image up or down, 10% at a click
##            - showing the displayed image at its original (actual) size.
##
##           This script also puts a couple of javascripts ---
##           'add-load-listener.js' and 'slideshow_fit_funcs.js' ---
##           in a 'javascripts' subdirectory of the directory containing
##           the selected image files.
##
##           This script also puts a tile image file in a 'tiles'
##           subdirectory of the directory containing the selected image files.        
##
## METHOD:  There is no prompt for a parameter.
##
##          The 'echo' command is used to put HTML statements in a '.htm' file.
##
##          This script shows the HTML file in an html-viewer of the user's choice
##          ($HTMLVIEWER), and puts the user in edit mode on the HTML file
##          using a text-editor of the user's choice ($TEXTEDITOR).
##
## HOW TO USE: In Nautilus, navigate to a directory of image files and
##             select the images to be shown. (Use Ctrl or Shift keys
##             as appropriate.)
##             Right-click and choose this script to run (name above).
##
##             This script puts the '.htm' HTML file in the directory
##             with the image files.
##
###########################################################################
## Started: 2012feb07
## Changed: 2012feb08 Change min viewport height from 450 pixels to 300.
## Changed: 2012may14 Changed script name in comments above and touched up
##                    the comments. Changed some indenting below.
###########################################################################

## FOR TESTING: (show statements as they execute)
# set -x


###################################
## Set the htm output file name.
###################################

  HTMFILE="00_slideshow_fit2page.htm"
# HTMFILE="00_SLIDESHOW_fit2page.htm"

if test -f "$HTMFILE"
then
   rm "$HTMFILE"
fi


######################################################
## ECHO SECTION 1:
## Put the 1st part of 'head' section in the HTML file.
######################################################

echo "

<!-- This file is for
     .../WebPics/xxxxxx/xxxxxx/xxxxxx/
         xxxxxx.htm
-->

<html>

<!-- 
<meta name=\"robots\" content=\"noindex, nofollow\">
-->

<meta name=\"description\" content=\"
\">

<meta name=\"keywords\" content=\"
\">

<head>

<title>
SLIDESHOW (fit to viewport) - viewport at least 300 pixels high
</title>

<!-- #### START OF JAVASCRIPT TO LOAD SLIDESHOW IMAGES INTO ### -->
<!-- #### AN ARRAY AND TO DEFINE SLIDE NEXT/PREV FUNCTIONS. ### -->

<script type="text/javascript">

// ### Put image filenames in an array. ###

var images = [" > "$HTMFILE"


#############################################################
## ECHO SECTION 2:
## Loop thru the user-selected img files making entry lines
## in the 'images' array.
############################################################

FILECNT=0

for FILENAME
do

   FILECNT=`expr $FILECNT + 1`
   
   # FILEEXT=`echo "$FILENAME" | cut -d'.' -f2`
   # if test "$FILEEXT" -ne "jpg" -a "$FILEEXT" -ne "JPG" -a
   #         "$FILEEXT" -ne "gif" -a "$FILEEXT" -ne "GIF" -a
   #         "$FILEEXT" -ne "png" -a "$FILEEXT" -ne "PNG"
   # then
   #    continue
   # fi


   ########################################
   ## Add line to the 'images' array.
   ########################################

   echo "'./$FILENAME'," >> "$HTMFILE"

done
## END OF 'for FILENAME' loop.



######################################################
## ECHO SECTION 3:
## Put the 2nd part of 'head' section and all but the
## bottom of the 'body' in the HTML file.
######################################################

echo "];

</script>

<script type=\"text/javascript\"
 src=\"./javascripts/add-load-listener.js\">
</script>


<script type=\"text/javascript\"
 src=\"./javascripts/slideshow_fit_funcs.js\">
</script>


<script type=\"text/javascript\">
//
// ### Run Load-one-image function after page loads.
// window.onload=initImg;
//
  addLoadListener(initImg);
</script>

</head>


<!-- ######### END of HEAD.   START of BODY. ############# -->

<body background=\"./tiles/tile_ripple_gray_320x200.jpg\"
      bgcolor=\"#ccccff\" onKeyDown=\"plusONE();\"
      style=\"margin-top:0px;margin-left:0px;margin-right:0px\">

<a name=\"above_TOP\"></a>

<!-- ######### TITLE BLOCK ############# -->

<table align=\"center\" border=\"3\" cellpadding=\"9\" cellspacing=\"0\"
       width=\"100%\">
<tr>


<!-- ### Provide decorative image(s) here. COMMENTED, for now. ###
<td align=\"left\" bgcolor=\"#ffffff\" style=\"border-style: none\">
<a
onmouseover=\"document['picpair0'].src='./decopics/'\"; 
onmouseout=\"document['picpair0'].src='./decopics/'\";
>
<img name=\"picpair0\" src=\"./decopics/\">
</a>
</td>
-->


<td align=\"center\" bgcolor=\"#ffffff\" style=\"border-style: none\">
<h1 align=\"center\">
SLIDESHOW of user-selected images
</h1>
<h3 align=\"center\">
Images are fit in a 'viewport' 300 pixels high.
</h3>
</td>


<!-- ### Provide decorative image(s) here. COMMENTED, for now. ###
<td align=\"right\" bgcolor=\"#ffffff\" style=\"border-style: none\">
<a
onmouseover=\"document['picpair1'].src='./decopics/'\"; 
onmouseout=\"document['picpair1'].src='./decopics/'\";
>
<img name=\"picpair1\" src=\"./decopics/\">
</a>
</td>
-->

</tr>
</table>



<!-- ################### INTRODUCTION ########################## -->

<p align=\"center\">
<table border=\"3\" cellpadding=\"9\" cellspacing=\"0\" width=\"80%\"
       bgcolor=\"#ececec\">
<tr>
<td>

<p>
<b>Introduction to the image area and slideshow controls :</b>

<p align=\"justify\">
By default, images are scaled to FIT a 'viewport' area. The 'viewport' is
an area within your HTML viewer (web browser) window, below.

<p align=\"justify\">
You have zoomIN, zoomOUT, and original-size functions
--- below, on the left, beside the image --- to over-ride the default
image-fitting function. If the image is blurred, try 'original-size'.

<p align=\"justify\">
Scroll down to position the images appropriately.
</p>

</td>
</tr>
</table>

<!-- ############################################################ -->
<!-- ##########      END OF HEADING SECTION.   ################## -->
<!-- ############################################################ -->

<!-- ############################################################ -->
<!-- #######  THE SLIDE CONTROL onClick-LINKS/BUTTONS  ########## -->
<!-- ############################################################ -->

<a name=\"above_VIEWPORT\"></a>

<table border=\"0\" align=\"center\"
       cellspacing=\"0\" cellpadding=\"4\">
  <tr>

    <td align=\"right\" valign=\"top\"><b>AutoSlideshow :</b></td>
    <td align=\"center\" valign=\"top\"><a id=\"start\" href=\"javascript:start_slideshow()\">Start</a></td>
    <td align=\"center\" valign=\"top\"><a id=\"stop\" href=\"javascript:stop_slideshow()\">Stop</a></td>
    <td align=\"center\" valign=\"top\">
        <form name=\"SLIDESHOWsecs\">
        Delay secs:
        <select onChange=\"
         delaysecs=this.options[this.selectedIndex].value;
         stop_slideshow();
         start_slideshow();\">

         <option value=\"5\">5
         <option value=\"10\">10
         <option value=\"15\">15
         <option value=\"25\">25
         <option value=\"45\">45
         <option value=\"3\">3
         <option value=\"4\">4

       </select>
       </form>
    </td>

  </tr>


</table>


<! ###### TOP IMAGE LABEL (NUMBER) AREA - at top of viewport #### -->

<p>
<div id=\"label\" align=\"center\" text=\"#ffffff\">
<span id=\"label1\"></span> of <span id=\"label2\"></span>
</div>



<!-- ###### IMAGE AREA, with controls on left ##################
            (using fixed-size *table* instead of *div*)
-->

<p align=\"left\">
<table>
<tr>

<!--- ### Make a margin at the left of the controls. ### -->
<td align=\"left\" width=\"10\">
</td>

<!--- ### Make the box of control links. ### -->
<td align=\"left\" valign=\"top\" width=\"40\">
<p>
<b>Img Step Controls :</b>
<br>
<a href=\"javascript:plusONE();\">plusONE</a>
<br>
<a href=\"javascript:minusONE();\">minusONE</a>
<br>
<a href=\"javascript:plusTEN()\">plusTEN</a>
<br>
<a href=\"javascript:minusTEN()\">minusTEN</a>
<p>
<b>Img Size Controls :</b>
<br>
<a href=\"javascript:zoomIN_20percent();\">zoomIN-20%</a>
<br>
<a href=\"javascript:zoomOUT_20percent();\">zoomOUT-20%</a>
<br>
<a href=\"javascript:orig_size();\">Original-Size</a>

<!-- ## COMMENTED ##
<br>
<a href=\"#\" onClick=\"plusONE();\">plusONE</a>
<br>
<a href=\"#\" onClick=\"minusONE();\">minusONE</a>
<br>
<a href=\"#\" onClick=\"plusTEN();\">plusTEN</a>
<br>
<a href=\"#\" onClick=\"minusTEN();\">minusTEN</a>
-->


<!-- ###### SIDE IMAGE LABEL (NUMBER) AREA - at left-side of controls box #### -->

<p>
<span id=\"label5\"></span> of <span id=\"label6\"></span>

</td>


<!-- ###### IMAGE AREA - initial size of 600x300 - right-side of viewport ### -->

<td  align=\"left\" valign=\"top\" width=\"600\" height=\"300\">
<img id=\"id_img1\">
</td>

</tr>
</table>



<!-- ###### ALTERNATIVE-DIV IMAGE AREA (COMMENTED) #################
           (using fixed-size *div* instead of a *table*)

<div style=\"width:999px; height:999px; margin:auto;\" align=\"left\">
<img id=\"id_img1\">
</div>

-->


<!-- ### ALTERNATIVE-VarTbl IMAGE AREA (COMMENTED) #################
         (using variable-size *table* instead of *div*)

<p align=\"left\">
<table>
<tr>

<td>
<span id=\"label5\"></span> of <span id=\"label6\"></span>
</td>

<td align=\"middle\">
<img align=\"middle\" id=\"id_img1\">
</td>

</tr>
</table>

-->


<! ###### BOTTOM IMAGE LABEL (NUMBER) AREA - at bottom of viewport #### -->

<div id=\"label\" align=\"center\" text=\"#ffffff\">
<span id=\"label3\"></span> of <span id=\"label4\"></span>
</div>


<! ###### INSTRUCTIONS ON USING THE CONTROLS ############# -->


<p align=\"center\" style=\"page-break-before: always\">
<table border=\"3\" cellpadding=\"9\" cellspacing=\"0\" width=\"55%\">
<tr>
<td bgcolor=\"#cccccc\">

<p>
<b>NOTES on slideshow controls usage:</b>

<p align=\"justify\">
You can use the 'plusONE' link above to advance through the
images, one image at a time.

<p align=\"justify\">
Or, click on the 'Start' link to start an automatic slideshow.
You can change the 'Delay secs' to speed up or slow down the show.

<p align=\"justify\">
Also, you can click on the 'plus' or 'minus' controls while the
auto-slideshow is going, to adjust the position of the slideshow.
Similarly, you can click on the img-size controls while the
slideshow is going.

<p align=\"justify\">
This slideshow page works with Mozilla Seamonkey and Firefox browsers.
It works with some versions of other browsers, like
Microsoft IE (Internet Explorer) and Opera. Maybe Mac Safari.

</tr>
</td>
</table>
" >>  "$HTMFILE"
## END OF echo for Controls and Image-display section of the HTML page.


####################################################
## ECHO SECTION 4:
## Write out BOTTOM of HTML file.
####################################################

echo "

<!-- ################################################### -->
<!-- ########## BOTTOM OF PAGE.  END of BODY. ########## -->
<!-- ################################################### -->

<p align=\"center\" style=\"page-break-before: always\">
<table border=\"3\" cellpadding=\"9\" cellspacing=\"0\" width=\"65%\">
<tr>
<td bgcolor=\"#cccccc\">

<p align=\"justify\">
<b>Bottom</b> of the <b>SLIDESHOW (fit to viewport)</b> page.

<p>
To return to a previously visited web page location, click on the<br>
Back button of your web browser, a sufficient number of times.<br>
OR, use the History-list option of your web browser.<br>
OR ...

<p>
<h5 align=\"center\">
<a href=\"#above_VIEWPORT\">&lt; Go to Top of Viewport, above. &gt;</a><br>
<a href=\"#above_TOP\">&lt; Go to Top of Page, above. &gt;</a><br>
</h5>

<p>
Page created 2012 xxx 00.

</tr>
</td>
</table>

<!--- ### Decorative image at bottom of page. COMMENTED, for now. ###
<p align=\"center\">
<img src=\"./decopics/yyyyyyyy.jpg\">
 -->

</body>
</html>
" >>  "$HTMFILE"


################################################################
## 1) Make subdirectory 'javascripts' in the images directory,
##    if it does not already exist, and
## 2) Copy the 'add-load-listener.js' and 'slideshow_fit_funcs.js'
##    javascripts into that 'javascripts' directory.
################################################################

CURDIR="`pwd`"

if test ! -d "$CURDIR/javascripts"
then
   mkdir "$CURDIR/javascripts"
   chmod 755 "$CURDIR/javascripts"
fi


DIR_THISSCRIPT="`dirname $0`"

if test ! -f "$CURDIR/javascripts/add-load-listener.js"
then
   cp "$DIR_THISSCRIPT/.javascripts/add-load-listener.js" \
      "$CURDIR/javascripts/add-load-listener.js"
fi

if test ! -f "$CURDIR/javascripts/slideshow_fit_funcs.js"
then
   cp "$DIR_THISSCRIPT/.javascripts/slideshow_fit_funcs.js" \
      "$CURDIR/javascripts/slideshow_fit_funcs.js"
fi


################################################################
## 1) Make subdirectory 'tiles' in the images directory,
##    if it does not already exist, and
## 2) Copy the a seamless tile file into that 'tiles' directory.
################################################################

if test ! -d "$CURDIR/tiles"
then
   mkdir "$CURDIR/tiles"
   chmod 755 "$CURDIR/tiles"
fi

if test ! -f "$CURDIR/tiles/tile_ripple_gray_320x200.jpg"
then
   cp "$DIR_THISSCRIPT/.tiles/tile_ripple_gray_320x200.jpg" \
      "$CURDIR/tiles/tile_ripple_gray_320x200.jpg"
fi


###################################
## SHOW HTML FILE in a web browser.
###################################

## . $HOME/.gnome2/nautilus-scripts/.set_VIEWERvars.shi

. $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
. $DIR_NautilusScripts/.set_VIEWERvars.shi

$HTMLVIEWER "$HTMFILE" &


##################################
## Put HTML FILE in a text editor.
##################################

$TXTEDITOR "$HTMFILE"
