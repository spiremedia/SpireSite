// JavaScript Document : Spire Media Inc.

//## reload page ##//
function OperaReload() { window.History.Forward(1);}

//## iScroll 4 ##//
var myScroll;
function loaded() {
	myScroll = new iScroll('wrapper3', {
		snap: false, bounce: false,
		momentum: true, hideScrollbar: false,
		hScrollbar: true, scrollbarClass: 'myScrollbar', fadeScrollbar: true, vScroll: false
	 });	 
	 //myScroll = new iScroll('wrapper', { scrollbarClass: 'myScrollbar' });
}
document.addEventListener('DOMContentLoaded', loaded, false);

jQuery(document).ready(function(){

var count = $("#scrollweb").width();
var count2 = (count+375);
$("#scrollweb").css('width', count2);

// set wraper height and position befor slide
var h2 = $(window).innerHeight();
var w2 = $(window).width();
var inPos = count2 + w2
var outPos = - (count2 + w2)
//$('#wrapper').css('left',inPos);

// set starting position of webslider, if referred by n
	//get current url and set page ahead of it
var pathname = window.location.pathname.toLowerCase().replace(/^https?:\/\//gi, '').split('/')[2];

	if (pathname === 'web-50cent.html') { var nexturl = 'web-carepilot.html';}
	if (pathname === 'web-carepilot.html') { var nexturl = 'web-corepower.html';}
	if (pathname === 'web-corepower.html') { var nexturl = 'web-corn.html';}
	if (pathname === 'web-corn.html') { var nexturl = 'web-denverwater.html';}
	if (pathname === 'web-denverwater.html') { var nexturl = 'web-dish.html';}
	if (pathname === 'web-dish.html') { var nexturl = 'web-firstdata.html';}
	if (pathname === 'web-firstdata.html') { var nexturl = 'web-intermountain.html';}
	if (pathname === 'web-intermountain.html') { var nexturl = 'web-sorin.html';}
	if (pathname === 'web-sorin.html') { var nexturl = 'web-swisslog.html';}
	if (pathname === 'web-swisslog.html') { var nexturl = 'web-wayin.html';}
	if (pathname === 'web-wayin.html') { var nexturl = 'web-50cent.html';}

var referrer = document.referrer.toLowerCase().replace(/^https?:\/\//gi, '').split('/')[2];
 if(referrer === nexturl){	 
	 $('#wrapper3').css('left', outPos);
	 $('#BGSITE').css('left', outPos);
	 }
else { 
	//donothing 
	}

//### Resize MAIN ###//
jQuery.event.add(window, "load", resizeMain);
jQuery.event.add(window, "resize", resizeMain);
function resizeMain() 
{
    var h = $(window).height();
    var w = $(window).width();
	if ( h > 800){
		$("#main_ww").css('height',(h -119));
		$("#wrapper, #scrollweb").css('height',(h -119-45));
		var marBot1 = h -(119+45+512);
		$(".ww_text").css('bottom' ,marBot1 + 80);
		$(".ww-social").css('bottom' ,marBot1 + 20);
		
		
	}
	else {
		$("#main_ww").css('height',671);
		$("#wrapper, #scrollweb").css('height',(800-119-45));
		var marBot1 = 800 - (119+45+512);
		$(".ww_text").css('bottom' ,marBot1 + 80);
		$(".ww-social").css('bottom' ,marBot1 + 20);
		
	}
    
}
	
//### LOAD/UNLOAD Animations ###//
$("a").live("click", function(){
  var href = $(this).attr("href");
  var linktype = $(this).attr('rel');
  
  if (linktype === 'new-window'){
	  window.open(href);
  }
  else {
  var animDuration = 1000;
	//if btn-prev clicked, slide out to right
	var btnclass = $(this).parent().attr("class");;
	if (btnclass === 'btn-prev'){
	$('#wrapper3').animate({'left': -outPos + 'px'},500, 'easeInOutQuart');
	$('#BGSITE').animate({'left': -outPos + 'px'},1500, 'easeInOutQuart');
  setTimeout(function () {
    window.location = href;
  }, animDuration);		
	}
	else {
  // Do animation here; duration = animDuration.
	$('#wrapper3').animate({'left': outPos + 'px'},500, 'easeInOutQuart');
	$('#BGSITE').animate({'left': outPos + 'px'},1500, 'easeInOutQuart');
  setTimeout(function () {
    window.location = href;
  }, animDuration);
  
	}//end else
  
	}

  return false; // prevent user navigation away until animation's finished
});
   
//**** ON SLIDER HOVER ***///
$('.clickndrag').hide();
$('#scrollweb').hoverIntent({					
	sensitivity: 1, // number = sensitivity threshold (must be 1 or higher)
	interval: 200,   // number = milliseconds of polling interval (we don't need this as it is initiated on click rather than hover)
	over: handlerIn,  // function = onMouseOver callback (required)
	timeout: 100,   // number = milliseconds delay before onMouseOut function call
	out: handlerOut   // function = onMouseOut callback (required)	
	})
function handlerIn() 
{ $(".clickndrag").fadeIn("medium");}

function handlerOut() 
{ $(".clickndrag").fadeOut("medium");}

//**** UNIVERSAL NO EDITS***///
//### CONTACT SLIDER ###//	
	//Hide slider
	$('#sliderTop').hide();
	$('.tabLogo').click(function() {
    $('#sliderTop').slideToggle('slow');
	$('.default').dropkick();
    return false;
  	});
  	
  	$('.contactFooter').click(function() {
    $('#sliderTop').slideToggle('slow');
	$('.default').dropkick();
    return false;
  	});
	
	$('.closeSlider').click(function() {
    $('#sliderTop').slideUp('slow');
    return false;
  	});

	//showcontact
	$('#contactSlide').hide().css({visibility: "visible"}).fadeIn(2000);
		
});

jQuery(window).load(function() {
	jQuery('#loading-image').fadeOut('fast', function() {
        // Animation complete
	//onload
//var desired_part = document.referrer.pathname.substr(1);

	$('#wrapper3').animate({'left':'0px'},1000, 'easeInOutQuart');
	$('#BGSITE').animate({'left':'-88px'},500, 'easeInOutQuart');		


	
	

      });
});