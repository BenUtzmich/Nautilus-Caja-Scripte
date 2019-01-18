function addLoadListener(fn)
{
// from book 'The Javascript Anthology' Chap1 p.15 (sitepoint.com)

    //    alert("Entering addLoadListener.");

  if (typeof window.addEventListener != 'undefined')
  {

    //    alert("Checking window.addEventListener -- for Mozilla.");

    window.addEventListener('load', fn, false);
  }
  else if (typeof document.addEventListener != 'undefined')
  {

    //    alert("Checking document.addEventListener -- for Opera.");

    document.addEventListener('load', fn, false);
  }
  else if (typeof window.attachEvent != 'undefined')
  {

    //    alert("Checking window.attachEvent -- for MS-IE.");

    window.attachEvent('onload', fn);

  }
  else
  {
    var oldfn =window.onload;
    if (typeof window.onload != 'function')
    {
      window.onload = fn;
    }
    else
    {
      window.onload = function()
      {
        oldfn();
        fn();
      };
    }
  }

     //   alert("Exiting addLoadListener.");


}