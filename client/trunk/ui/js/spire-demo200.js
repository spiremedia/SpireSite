// JavaScript Document : Spire Media Inc.

jQuery(document).ready(function(){
 
//### Resize MAIN SECTION FOR SLIDER ###//
jQuery.event.add(window, "load", resizeMain2);
jQuery.event.add(window, "resize", resizeMain2);
function resizeMain2() 
{
    var h = $(window).height();
    var w = $(window).width();
	

		$("#WWD").css('height',971);
		$("#mainWhat, .ow0, .ow1, .ow2, .ow3").css('height',971);

   if (w < 1398){
	   
	   if (w > 1189){
	   var half = -(1398 - w)/2;
	   $("#scroller, #CList, #CList2").css('margin-left', half);
	   }
	   else {$("#scroller, #CList, #CList2").css('margin-left', '-104px');}
	   
	   $(".clickndrag").css('margin','15px 0 0 930px');
   
   }
   else {
	   $("#scroller, #CList, #CList2").css('margin-left','0px');
	   $(".clickndrag").css('margin','15px 0 0 1030px');
	   }
}	
	var slider = $('#slider1').bxSlider({
    controls: false, infiniteLoop: false,
  });
  // Hide ALL Emements before page loads  
  $('#main_wwd').hide();

//**** CLICK NAV 2 SLIDE***///
//### SLIDER###//	
	$(".bx-window").css('overflow','visible');
	//$("#slider1").css('position', 'absolute');
	
	$('.noweb, .nomobile').hide();
	
	
	$('#go-prev').click(function(){
    slider.goToPreviousSlide();
    return false;
  });
  
  $('#go-next').click(function(){
    slider.goToNextSlide();
    return false;
  });	
  $('.btn-wwd').click(function(){
	$('.subnav li a').removeClass('active');
    slider.goToFirstSlide();
	$(this).live();
    return false;
  });
  
  $('.btn-client').click(function(){

	$('.subnav li a').removeClass('active');
	$('.subnav li .btn-client').addClass('active');slider.goToSlide(1);
	$('.nomobile').fadeOut('slow');
    $('.noweb').fadeOut('slow');	
	$(this).live();
    return false;
  });
  $('.btn-industry').click(function(){

	$('.subnav li a').removeClass('active');
	$('.subnav li .btn-client').addClass('active');slider.goToSlide(2);
	$('.nomobile').fadeOut('slow');
    $('.noweb').fadeOut('slow');	
	$(this).live();
    return false;
  });
  
  $('.btn-ow').click(function(){

	$('.subnav li a').removeClass('active');
	 slider.goToSlide(0);
	$('.nomobile').fadeOut('slow');
    $('.noweb').fadeOut('slow');
	$(this).live();
    return false;
  });
  $('.btn-web').click(function(){
	
	$('.subnav li a').removeClass('active');
	 $('.subnav li .btn-web').addClass('active');slider.goToSlide(0);
	$('.nomobile').fadeOut('slow');
    $('.noweb').fadeIn('slow');
	$(this).live();
    return false;
  });
  $('.btn-mobile').click(function(){
	
	$('.subnav li a').removeClass('active');
	 $('.subnav li .btn-mobile').addClass('active');slider.goToSlide(0);
	$('.noweb').fadeOut('slow');
    $('.nomobile').fadeIn('slow');
	
	$(this).live();
    return false;
  });

//set width of slider
var count = $("#firstrow").children().length;
var count2 = (count*375) + 88 + 375;
$("#scroller").css('width',count2); 
 
 $('.weblink').hide();

	function showPointer() {		
	$(this).children('.weblink').fadeIn('slow');
	}			
	function hidePointer() {				
	$(this).children('.weblink').fadeOut('fast');
	}
	
	$('#scroller li').hoverIntent({					
	sensitivity: 1, // number = sensitivity threshold (must be 1 or higher)
	interval: 0,   // number = milliseconds of polling interval (we don't need this as it is initiated on click rather than hover)
	over: showPointer,  // function = onMouseOver callback (required)
	timeout: 100,   // number = milliseconds delay before onMouseOut function call
	out: hidePointer   // function = onMouseOut callback (required)	
	})



//**** SLIDER WRAPPER ADJUSTMENTS***///
//### Resize MAIN SLIDER ###//
jQuery.event.add(window, "load", resizeMain);
jQuery.event.add(window, "resize", resizeMain);
function resizeMain() 
{
    var h = $(window).height();
    var w = $(window).width();
	if ( h > 800){
		$("#main_ow, #wrapper2").css('height',(h -119));
		$("#scroller").css('height',(h -119-45));
	}
	else {
		$("#main_ow, #wrapper2").css('height',671);
		$("#scroller").css('height',(800-119-45));
		//$("#sliderInfo").css('width',1006);
	}
    
}
	
//### Resize INSTRUCTIONS below slider ###//
jQuery.event.add(window, "load", resizeSlider);
$(window).bind('resize', resizeSlider);
//$(window).trigger('resize');

function resizeSlider() 
{
    var h = $(window).innerHeight();
    var w = $(window).innerWidth();
	if ( h < 786){
		
		$("#sliderInfo").css('height',(h -62));
		$("#sliderInfo, .myScrollbarH").css('width',1026);
	}
	else {
		$("#sliderInfo").css('height',724);
		$("#sliderInfo, .myScrollbarH").css('width',1006);
	}
    
}

//**** ON SLIDER HOVER ***///
$('.clickndrag').hide();
$('#scroller').hoverIntent({					
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
	jQuery('#loading-image').fadeOut('slow', function(){
   $('#main_wwd').delay(500).fadeIn('slow', loaded);
   //$('.btn-client').delay(1000).click();
 //myScroll.refresh(); 
    return false;
  });


});
  
