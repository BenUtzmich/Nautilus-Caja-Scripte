// This Javascript file provides 'slideshow' functions and requires
// an array 'images' to have been loaded with image filenames.
//
// The functions deal with an image defined by an img-statement
// of the form        <img id="id_img1">
//
// Call on this code in a <head> section of an HTML page.
//
// -----------------
// This file defines the variables:
//      imgindex, topindex, delaysecs, pid_slideshow
// and defines the functions:
//     initImg, plusONE, minusONE, plusTEN, minusTEN,
//     start_slideshow, stop_slideshow,
//     zoomIN_20percent, zoomOUT_20percent, orig_size
//
// These 1st 5 functions set 'innerHTML' of span elements with IDs
//       label1, ... , label6
// for 3 'span' statements of the form
//   <span id="label1"></span> of <span id="label2"></span>
//   <span id="label3"></span> of <span id="label4"></span>
//   <span id="label5"></span> of <span id="label6"></span>
// 

var imgindex = 0;
var topindex = images.length - 1;

var delaysecs = 5;
var pid_slideshow = null;


// ## FUNCTION to INITIALIZE image (and labels), on page load
// ## --- for a  "addLoadListener(initImg);"  statement
// ## --- which is an enhancment of "window.onload=initImg;".
//
function initImg(){
  // document.id_img1.src = './' + images[imgindex];
  
  document.getElementById('id_img1').src = images[imgindex];

  // ## The following works in Mozilla&Firefox but not MS-IE.
  // document.id_img1.src = images[imgindex];

  document.getElementById('label1').innerHTML=String(imgindex + 1);
  document.getElementById('label2').innerHTML=images.length.toString(10);
  document.getElementById('label3').innerHTML=String(imgindex + 1);
  document.getElementById('label4').innerHTML=images.length.toString(10);
  document.getElementById('label5').innerHTML=String(imgindex + 1);
  document.getElementById('label6').innerHTML=images.length.toString(10);
}


// ## FUNCTION to 'SHAPE' the image according to the passed-in variables
// ## --- w and h.
//
function shapeImg(w,h){
      
  // alert("Starting shapeImg");

    img.width = w ;
    img.height = h ;

    //  alert("shapeImg: New imgW = " + img.width );
    //  alert("shapeImg: New imgH = " + img.height );

}


// ## onClick-FUNCTION to switch image ONE count FORWARD
// ## --- for a
// ##    "<a href="#" onClick="plusONE();">
// ## statement.
//
function plusONE(){
  imgindex += 1
  while (imgindex>topindex){ imgindex = imgindex - images.length }

  // OLD:
  // document.getElementById('id_img1').src = images[imgindex];

  img = document.getElementById('id_img1');

  var newimg = new Image();

  newimg.onload = function()
  {
     img.src = newimg.src;
     shapeImg(newimg.width , newimg.height);
     // alert("plusONE: img.width = " + img.width );
     // alert("plusONE: img.height = " + img.height );
  }

  newimg.src = images[imgindex];

  document.getElementById('label1').innerHTML=String(imgindex + 1);
  document.getElementById('label3').innerHTML=String(imgindex + 1);
  document.getElementById('label5').innerHTML=String(imgindex + 1);
}


// ## onClick-FUNCTION to switch image ONE count BACKWARD
// ## --- for a
// ##    "<a href="#" onClick="minusONE();">
// ## statement.
//
function minusONE(){
  imgindex -= 1
  while (imgindex<0){ imgindex = imgindex + images.length }

       // alert("minusONE: augmented imgindex to " + imgindex );

  // OLD:
  // document.getElementById('id_img1').src = images[imgindex];

  img = document.getElementById('id_img1');

  var newimg = new Image();

  newimg.onload = function()
  {
      // alert("Starting minusONE - newimg.onload");

     img.src = newimg.src;
     shapeImg(newimg.width , newimg.height);
     // alert("minusONE: img.width = " + img.width );
     // alert("minusONE: img.height = " + img.height );
  }

      // alert("minusONE: loading newimg.src with " + images[imgindex] );

  newimg.src = images[imgindex];


  document.getElementById('label1').innerHTML=String(imgindex + 1);
  document.getElementById('label3').innerHTML=String(imgindex + 1);
  document.getElementById('label5').innerHTML=String(imgindex + 1);
}


// ## onClick-FUNCTION to switch image TEN counts FORWARD
// ## --- for a
// ##    "<a href="#" onClick="plusTEN();">
// ## statement.
//
function plusTEN(){
  imgindex += 10
  while (imgindex>topindex){ imgindex = imgindex - images.length }

  // OLD:
  // document.getElementById('id_img1').src = images[imgindex];
  
  img = document.getElementById('id_img1');

  var newimg = new Image();

  newimg.onload = function()
  {
     img.src = newimg.src;
     shapeImg(newimg.width , newimg.height);
     // alert("plusTEN: img.width = " + img.width );
     // alert("plusTEN: img.height = " + img.height );
  }

  newimg.src = images[imgindex];


  document.getElementById('label1').innerHTML=String(imgindex + 1);
  document.getElementById('label3').innerHTML=String(imgindex + 1);
  document.getElementById('label5').innerHTML=String(imgindex + 1);
}


// ## onClick-FUNCTION to switch image TEN counts BACKWARD
// ## --- for a
// ##    "<a href="#" onClick="minusTEN();">
// ## statement.
//
function minusTEN(){
  imgindex -= 10
  while (imgindex<0){ imgindex = imgindex + images.length }

  // OLD:
  // document.getElementById('id_img1').src = images[imgindex];
  
  img = document.getElementById('id_img1');

  var newimg = new Image();

  newimg.onload = function()
  {
     img.src = newimg.src;
     shapeImg(newimg.width , newimg.height);
     // alert("minusTEN: img.width = " + img.width );
     // alert("minusTEN: img.height = " + img.height );
  }

  newimg.src = images[imgindex];

  document.getElementById('label1').innerHTML=String(imgindex + 1);
  document.getElementById('label3').innerHTML=String(imgindex + 1);
  document.getElementById('label5').innerHTML=String(imgindex + 1);
}


// ## FUNTION to START THE SLIDESHOW of the images
// ## --- for a
// ##    "<a href="#" onClick="start_slideshow();">
// ## statement.
//
function start_slideshow() {
   //     alert("Entering start_slideshow. PID = " + pid_slideshow);

   if (pid_slideshow != null) {clearInterval(pid_slideshow);}
   pid_slideshow=window.setTimeout('cueNextSlide()', delaysecs * 1000);

    //    alert("Exiting start_slideshow. PID = " + pid_slideshow);
}


// ## FUNTION to QUEUE UP NEXT SLIDE.
// ## Called by start_slideshow function.
//
function cueNextSlide()
{
   //   alert("Entering cueNextSlide. PID = " + pid_slideshow);

   document.getElementById('id_img1').onerror = function ()
   {
      alert('Failed to load image number ' + imgindex);
   };

   imgindex += 1
   while (imgindex>topindex){ imgindex = imgindex - images.length }

   // OLD:
   // document.getElementById('id_img1').src = images[imgindex];
  
   img = document.getElementById('id_img1');

   var newimg = new Image();

   newimg.onload = function()
   {
     img.src = newimg.src;
     shapeImg(newimg.width , newimg.height);
     // alert("cueNextSlide: img.width = " + img.width );
     // alert("cueNextSlide: img.height = " + img.height );
   }

   newimg.src = images[imgindex];


   document.getElementById('label1').innerHTML=String(imgindex + 1);
   document.getElementById('label3').innerHTML=String(imgindex + 1);
   document.getElementById('label5').innerHTML=String(imgindex + 1);

   pid_slideshow=window.setTimeout('cueNextSlide()', delaysecs * 1000);

   //   alert("Exiting start_slideshow. PID = " + pid_slideshow);
}


// ## FUNCTION -- SECOND VERSION of the cueNextSlide function.
// ## See pp. 170-175 of book 'The Javascript Anthology'.
//
function cueNextSlide2() {
   //   alert("Entering cueNextSlide. PID = " + pid_slideshow);

   var nextimg = new Image();

   nextimg.onerror = function ()
   {
      alert('Failed to load next image');
   };

   nextimg.onload = function ()
   {
      document.getElementById('id_img1').src = nextimg.src;

      // document.getElementById('id_img1').width  = nextimg.width;
      // document.getElementById('id_img1').height = nextimg.height;

      document.getElementById('label1').innerHTML=String(imgindex + 1);
      document.getElementById('label3').innerHTML=String(imgindex + 1);
      document.getElementById('label5').innerHTML=String(imgindex + 1);

      window.setTimeout('cueNextSlide()', delaysecs * 1000);
   };

  imgindex += 1
  while (imgindex>topindex){ imgindex = imgindex - images.length }

  nextimg.src = images[imgindex];


   //   alert("Exiting start_slideshow. PID = " + pid_slideshow);
}


// ## FUNCTION to  STOP THE SLIDESHOW.
// ## --- for a
// ##    "<a href="#" onClick="stop_slideshow();">
// ## statement.
//
function stop_slideshow() {
    //    alert("Entering stop_slideshow. PID = " + pid_slideshow);
    clearTimeout(pid_slideshow);
    //    alert("Exiting stop_slideshow. PID = " + pid_slideshow);
}


// ## onClick-FUNCTION to zoomOUT-20%
// ## --- for a
// ##    <a href="javascript:zoomOUT_20percent();">
// ## statement.
//
function zoomOUT_20percent(){
      
  // alert("Starting zoomOUT_20percent");
  
  img = document.getElementById('id_img1');
  imgW = img.width ;
  imgH = img.height ;

  var newimg = new Image();

  newimg.onload = function()
  {
     img.src = newimg.src;
     img.width = imgW / 1.2 ;
     img.height = imgH / 1.2 ;
     // alert("zoomOUT_20percent: img.width = " + img.width );
     // alert("zoomOUT_20percent: img.height = " + img.height );
  }

  newimg.src = images[imgindex];

}



// ## onClick-FUNCTION to zoomIN-20%
// ## --- for a
// ##    <a href="javascript:zoomIN_20percent();">
// ## statement.
//
function zoomIN_20percent(){
      
  // alert("Starting zoomIN_20percent");
  
  img = document.getElementById('id_img1');
  imgW = img.width ;
  imgH = img.height ;

  var newimg = new Image();

  newimg.onload = function()
  {
     img.src = newimg.src;
     img.width = imgW * 1.2 ;
     img.height = imgH * 1.2 ;
     // alert("zoomIN_20percent: img.width = " + img.width );
     // alert("zoomIN_20percent: img.height = " + img.height );
  }

  newimg.src = images[imgindex];

}


// ## onClick-FUNCTION to original-size
// ## --- for a
// ##    <a href="javascript:orig_size();">
// ## statement.
//
function orig_size(){
      
  // alert("Starting orig_size");
  
  img = document.getElementById('id_img1');

  var newimg = new Image();

  newimg.onload = function()
  {
     img.src = newimg.src;
     img.width = newimg.width ;
     img.height = newimg.height ;
     // alert("orig_size: img.width = " + img.width );
     // alert("orig_size: img.height = " + img.height );
  }

  newimg.src = images[imgindex];

}
