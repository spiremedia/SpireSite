var blank = new Image();
blank.src = '/ui/images/blank.gif';

jQuery.noConflict();
jQuery(document).ready(function() {
   var ie6Browser = (/MSIE ((5\.5)|6)/.test(navigator.userAgent) && navigator.platform == "Win32");
   if (ie6Browser) {
     // get all pngs on page
     jQuery('img[src$=.png]').each(function() {
       if (!this.complete) {
         this.onload = function() { fixPng(this) };
       } else {
         fixPng(this);
       }
     });
   }
 });

jQuery.fn.tables = function(options) {
	return this.each(function() {
		$this = jQuery(this);
		jQuery("th:last", $this).addClass("last");
		jQuery("th:first", $this).addClass("first");
		if (jQuery("th", $this).length == 1) {
			var th = jQuery("th", $this);
			th.html("<div>" +  th.html() + "</div>");
			th.css("padding",0);
			jQuery("div", th).eq(0).css("padding","10px 14px 14px").css("border-right","1px solid white")
		}
		jQuery("th", $this).eq(0).parent().next().addClass("first");
		jQuery("tr:even", $this).addClass("alt");
		jQuery("tr:last", $this).addClass("last");
		jQuery("tr", $this).each(function(){
			var $this = jQuery(this);
			jQuery("td:first", $this).addClass("first");
			jQuery("td:last", $this).addClass("last");
		});
		jQuery("th br", $this).parent().addClass("twolines");		
	});
};

 
 function fixPng(png) {
   // get src
   var src = png.src;
   // set width and height
   if (!png.style.width) { png.style.width = jQuery(png).width(); }
   if (!png.style.height) { png.style.height = jQuery(png).height(); }
   // replace by blank image
   png.onload = function() { };
   png.src = blank.src;
   // set filter (display original image)
   png.runtimeStyle.filter = "progid:DXImageTransform.Microsoft.AlphaImageLoader(src='" + src + "',sizingMethod='scale')";
 }
