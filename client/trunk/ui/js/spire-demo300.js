// JavaScript Document : Spire Media Inc.




jQuery(document).ready(function(){

//**** ROLLOVERS ***///
$('#firstboxes li').hover(function(){
     $(this).removeClass('fade').siblings().addClass('fade');
},function(){
     $(this).siblings().andSelf().removeClass('fade');
})


	function showBox1() {	
		$(this).animate({ lineHeight: "158px"}, { duration: "fast" });
	}			
	function hideBox1() {
		//$(this).parent.children.css({ opacity:".5" });				
		$(this).animate({  lineHeight: "148px" }, { duration: "fast" });
	}
	
	$('.whr-box1, .whr-box2, .whr-box3').hoverIntent({					
	sensitivity: 1, // number = sensitivity threshold (must be 1 or higher)
	interval: 0,   // number = milliseconds of polling interval (we don't need this as it is initiated on click rather than hover)
	over: showBox1,  // function = onMouseOver callback (required)
	timeout: 0,   // number = milliseconds delay before onMouseOut function call
	out: hideBox1   // function = onMouseOut callback (required)	
	})


//### Resize MAIN SECTION FOR SLIDER ###//
jQuery.event.add(window, "load", resizeMain2);
jQuery.event.add(window, "resize", resizeMain2);
function resizeMain2() 
{
    var h = $(window).height();
    var w = $(window).width();
	
	if ( h > 800){
		$("#WWD").css('height',(h -119));
		$("#mainWhat, .wwa0, .wwa1, .wwa2, .wwa3, .wwa4").css('height',(h -119));
	}
	else {
		$("#WWD").css('height',671);
		$("#mainWhat, .wwa0, .wwa1, .wwa2, .wwa3, .wwa4").css('height',671);
	}	
   if (w < 1398){
	   
	   if (w > 1189){
	   var half = -(1398 - w)/2;
	   $("#WHO, #people, #CAR").css('margin-left', half);
	   }
	   else {$("#WHO, #people, #CAR").css('margin-left', '-104px'); }
	   
	   $(".clickndrag").css('margin','15px 0 0 930px');
   
   }
   else {
	   $("#WHO, #people, #scrollhis, #CAR").css('margin-left','0px');
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

  $('.btn-wwa').click(function(){
	$('.subnav li a').removeClass('active');
    slider.goToFirstSlide();
	$(this).live();
    return false;
  });
  
  $('.btn-leadership').click(function(){
	$('.subnav li a').removeClass('active');
	$('.subnav li .btn-leadership').addClass('active');slider.goToSlide(1);
	$(this).live();
    return false;
  });
  $('.btn-history').click(function(){
	$('.subnav li a').removeClass('active');
	$('.subnav li .btn-history').addClass('active');slider.goToSlide(2);
	$(this).live();
    return false;
  });
  $('.btn-careers').click(function(){
	$('.subnav li a').removeClass('active');
	$('.subnav li .btn-careers').addClass('active');slider.goToSlide(3);
	$(this).live();
    return false;
  }); 


//set width of sliders
var count = $("#myList").children().length;
var count2 = (count*256) + 88 + 300;
$("#people").css('width',count2);

var count = $("#scrollhis").width();
var count2 = (count+375);
$("#scrollhis").css('width', count2);

// set wraper height and position befor slide
var h2 = $(window).innerHeight();
var w2 = $(window).width();
var inPos = count2 + w2
var outPos = - (count2 + w2)
//$('#wrapper').css('left',inPos);


//Darken
	$('.darken').hide();
	function showDark() {		
	$(this).children('.darken').fadeIn('slow');
	}			
	function hideDark() {				
	$(this).children('.darken').fadeOut('slow');
	}
	
	$('#people ul li').hoverIntent({					
	sensitivity: 1, // number = sensitivity threshold (must be 1 or higher)
	interval: 0,   // number = milliseconds of polling interval (we don't need this as it is initiated on click rather than hover)
	over: showDark,  // function = onMouseOver callback (required)
	timeout: 100,   // number = milliseconds delay before onMouseOut function call
	out: hideDark   // function = onMouseOut callback (required)	
	})

//popup
$('.pop-bgg').hide();
$('.dar-name').click(function() {	
	//slider.goToSlide(this.id);
	  //person = $(this).children('.dar-name').attr('id');
	  person = $('.dar-name').attr('id');
	 //var openNum = 'bio_1'; 
    $('div.'+ person).fadeIn('slow');
});
$('.srlink').click(function() {	
	//slider.goToSlide(this.id);
	  person = $(this).attr('id');
	 //var openNum = 'bio_1'; 
    $('div.'+ person).fadeIn('slow');
});
$('.pu-close').click(function() {
    $(this).closest('.pop-bgg').fadeOut('slow');
});



//**** SLIDER WRAPPER ADJUSTMENTS***///
//### Resize MAIN ###//
jQuery.event.add(window, "load", resizeMain);
jQuery.event.add(window, "resize", resizeMain);
function resizeMain() 
{
    var h = $(window).height();
    var w = $(window).width();
	if ( h > 800){
		$("#main_le, #wrapper").css('height',(h -119));
		$("#people").css('height',(h -119-45));
		$("#main_his").css('height',(h -119));
		$("#wrapper2, #scrollhis").css('height',(h -119-45));
	}
	else {
		$("#main_le, #wrapper").css('height',671);
		$("#people").css('height',671-45);
		$("#main_his").css('height',671);
		$("#wrapper2, #scrollhis").css('height',(800-119-45));
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
$('#people, #scrollhis').hoverIntent({					
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
	
	$('.closeSlider').click(function() {
    $('#sliderTop').slideUp('slow');
    return false;
  	});

	//showcontact
	$('#contactSlide').hide().css({visibility: "visible"}).fadeIn(2000);
		
});

jQuery(window).load(function() {
	jQuery('#loading-image').fadeOut('slow', function(){
     $('#main_wwd').delay(500).fadeIn('medium', loaded);
	 //myScroll.refresh(); 
    return false;
  });
	
});
  
