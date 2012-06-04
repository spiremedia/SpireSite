// JavaScript Document
jQuery(document).ready(function(){

//use mousewheel to scroll horizontal only
  //$("body").mousewheel(function(event, delta) { this.scrollLeft -= (delta * 30); event.preventDefault();});
   
	$('.btn-start, .btn-backarw').hide();
	$('#mw2').hide();

	var endOne = 3180;//maximum scroll
	var endTwo = endOne + 1398 ;
	var endThree = endTwo + 1398;
	
//on event scroll, change up the buttons
	$(window).scroll(function () {
$.doTimeout( 'scroll', 250, function(){		
	var curPos = $(window).scrollLeft();
	if ( 0 <= curPos && curPos < endOne){
	//show fwd only
	$('.btn-start').fadeOut('fast');
	$('.btn-fwdarw').fadeIn('fast');
		if ( curPos >= 1125){
		$('.btn-backarw').fadeIn('fast');
		}
		else{
		$('.btn-backarw').fadeOut('fast');
		}
  	}
	//if between endOne and endTwo next is three
	if ( endOne <= curPos && curPos < endTwo){
	var nextPos = 0;
	$('.btn-start').fadeIn('fast');
	$('.btn-backarw').fadeIn('fast');
	$('.btn-fwdarw').fadeIn('fast');
  	}
	if ( endTwo <= curPos && curPos < endThree){
	var nextPos = endOne;
	$('.btn-start').fadeIn('fast');
	$('.btn-backarw').fadeIn('fast');
	$('.btn-fwdarw').fadeOut('fast');
  	}

	
	//$('#header, #footer').animate({'padding-left': $(this).scrollLeft()}, 400);
	//$('#controlBox').animate({'left': $(this).scrollLeft()}, 400);
	//$('#header, #footer').animate({ 'padding-left': curPos },400);
	//$('#controlBox').animate({ 'left': curPos },400);
	
});	
	});
	

//click start
   $(".btn-start").click(function() {
	$.scrollTo('0px', 600, { axis:'x' });
	$('.btn-ow').trigger('click');
	});
	
	$(".btn-backarw").click(function() {  
  	var curPos = $(window).scrollLeft();
  	//if between 0 ad endOne next is two
	if ( 0 <= curPos && curPos < endOne){
	var nextPos = 0;
	$('.btn-ow').trigger('click');
  	}
	//if between endOne and endTwo next is three
	if ( endOne <= curPos && curPos < endTwo){
	var nextPos = 0;
	$('.btn-ow').trigger('click');
  	}
	if ( endTwo <= curPos && curPos < endThree){
	var nextPos = endOne;
	$('.btn-client').trigger('click');
  	}
	$.scrollTo( nextPos+'px', 300, { axis:'x' });//keep.  scrolls backwards
	});	
	
   $(".btn-fwdarw").click(function() {  
  	var curPos = $(window).scrollLeft();
  	//if between 0 ad endOne next is two
	if ( 0 <= curPos && curPos < endOne){
	var nextPos = endOne;
		if ( curPos >= 1125){
			$('.btn-client').trigger('click');
		}
		else{
			$.scrollTo( '1125px', 300, { axis:'x' });
		}
  	}
	//if between endOne and endTwo next is three
	if ( endOne <= curPos && curPos < endTwo){
		var nextPos = endTwo;
		$('.btn-industry').trigger('click');
  	} 
	//$.scrollTo( nextPos+'px', 600, { axis:'x' });
	});


//**** NORMAL NAV CLICK TO SLIDE/SHOW***///
  $('.btn-client').click(function(){
	  
	$('.subnav li a').removeClass('active');
	$('.subnav li .btn-client').addClass('active');
	$.scrollTo( endOne+'px', 600, { axis:'x' });
	$('.nomobile').fadeOut('slow');
    $('.noweb').fadeOut('slow');	
	$(this).live();
    return false;
  });
  $('.btn-industry').click(function(){

	$('.subnav li a').removeClass('active');
	$('.subnav li .btn-client').addClass('active');
	$.scrollTo( endTwo+'px', 600, { axis:'x' });
	$('.nomobile').fadeOut('slow');
    $('.noweb').fadeOut('slow');	
	$(this).live();
    return false;
  });
  
  $('.btn-ow').click(function(){

	$('.subnav li a').removeClass('active');
	 $.scrollTo( '0px', 600, { axis:'x' });
	$('.nomobile').fadeOut('slow');
    $('.noweb').fadeOut('slow');
	$(this).live();
    return false;
  });
  $('.btn-web').click(function(){
	
	$('.subnav li a').removeClass('active');
	 $('.subnav li .btn-web').addClass('active');
	 $.scrollTo( '0px', 600, { axis:'x' });
	$('.nomobile').fadeOut('slow');
    $('.noweb').fadeIn('slow');
	$(this).live();
    return false;
  });
  $('.btn-mobile').click(function(){
	
	$('.subnav li a').removeClass('active');
	 $('.subnav li .btn-mobile').addClass('active');
	 $.scrollTo( '0px', 600, { axis:'x' });
	$('.noweb').fadeOut('slow');
    $('.nomobile').fadeIn('slow');
	
	$(this).live();
    return false;
  });
	
//**** SET WIDTHS ***///
var mainWidth = $('#mw2').width();	
//$('#hContainer, #fContainer').css('width',mainWidth);

	/* *  Simple image gallery. Uses default settings */
	$('.fancybox').fancybox();	
	$('.popup, .popupWeb').hide();
	jQuery.event.add(window, "load", resizeMain2);
	jQuery.event.add(window, "resize", resizeMain2);
	function resizeMain2() 
	{
		var h = $(window).height();
		var w = $(window).width();	
		var mainHeight = $('#mw2').height();
		var mhPlus = mainHeight + 119 + 119;
		var mhLarge = h - (119*2);
		
		var newPadding = (w-1182) / 2;
		
	   if (w < 1182){
		   $("#mw2").css('padding-left',0);
		   $("#mw2").css('padding-right',0);
		   //var nowPadding = 0;
	   }
	   else {
			$("#mw2").css('padding-left',newPadding);
			$("#mw2").css('padding-right',newPadding);
			//var nowPadding = newPadding;
		   }
		if (h > mhPlus){
		   $('#main').css('height',mhLarge);
	   }
	   else {
			$("#main").css('height',mainHeight);
		   }
	}	


	
//**** WEB/MOBILE***///
	$('.noweb, .nomobile').hide();
//**** PROJECT HOVER ***///
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

//**** CHECK URL***///
	 if(window.location.hash === "#web"){
	  setTimeout(function() { //alert('hello');
		$('.btn-web').trigger('click');
	  },1000);}
	 if(window.location.hash === "#mobile"){
	  setTimeout(function() { 
		$('.btn-mobile').trigger('click');
	  },1000); }
	 if(window.location.hash === "#client-list"){
	  setTimeout(function() { 
		$('.btn-client').trigger('click');
	  },1000);}
	 if(window.location.hash === "#industry-list"){
	  setTimeout(function() { 
		$('.btn-industry').trigger('click');
	  },1000);}
	  
	  if(window.location.hash === "#denver-water"){
	  setTimeout(function() { 
		$('.btn-denver-water').trigger('click');
	  },1000);}
	  if(window.location.hash === "#corn"){
	  setTimeout(function() { 
		$('.btn-corn').trigger('click');
	  },1000);}
	  if(window.location.hash === "#first-data"){
	  setTimeout(function() { 
		$('.btn-first-data').trigger('click');
	  },1000);}
	  if(window.location.hash === "#50-cent"){
	  setTimeout(function() { 
		$('.btn-50-cent').trigger('click');
	  },1000);}
	  if(window.location.hash === "#pueblo"){
	  setTimeout(function() { //alert('hello');
		$('.btn-pueblo').trigger('click');
	  },1000);}
	  if(window.location.hash === "#wayin"){
	  setTimeout(function() { //alert('hello');
		$('.btn-wayin').trigger('click');
	  },1000);}
	  if(window.location.hash === "#dish"){
	  setTimeout(function() { //alert('hello');
		$('.btn-dish').trigger('click');
	  },1000);}
	  if(window.location.hash === "#care-pilot"){
	  setTimeout(function() { //alert('hello');
		$('.btn-care-pilot').trigger('click');
	  },1000);}
	  if(window.location.hash === "#core"){
	  setTimeout(function() { //alert('hello');
		$('.btn-core').trigger('click');
	  },1000);}
	  if(window.location.hash === "#swiss"){
	  setTimeout(function() { //alert('hello');
		$('.btn-swiss').trigger('click');
	  },1000);}
	  if(window.location.hash === "#intermountain"){
	  setTimeout(function() { //alert('hello');
		$('.btn-intermountain').trigger('click');
	  },1000);}
	  if(window.location.hash === "#mobile-day"){
	  setTimeout(function() { //alert('hello');
		$('.btn-mobile-day').trigger('click');
	  },1000);}
	  

});
$(document).keydown(function(e){  
	//37 - left,  38 - up, 39 - right, 40 - down 
   //if left key check for active sublink then apply click
    if (e.keyCode == 37) { 
		//if arwbutton visible do click
		var action = $(".btn-backarw").css('display');
		if ( action === 'none'){
		   //donothing
		}
		else { $(".btn-backarw").trigger('click');}
       return false;
    }
   //if right key  check for active sublink then apply click
    if (e.keyCode == 39) { 
		//if arwbutton visible do click
		var action = $(".btn-fwdarw").css('display');
		if ( action === 'none'){
		   //donothing
		}
		else { $(".btn-fwdarw").trigger('click');}
       return false;
    }	
});

jQuery(window).load(function() {
	jQuery('#loading-image').fadeOut('slow', function(){
     $('#mw2').delay(500).fadeIn('medium');
    return false;
  });  
});