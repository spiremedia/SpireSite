// JavaScript Document
jQuery(document).ready(function(){


//use mousewheel to scroll horizontal only
  //$("body").mousewheel(function(event, delta) { this.scrollLeft -= (delta * 30); event.preventDefault();});
   
	$('.btn-start, .btn-backarw').hide();
	$('#mwwa2').hide();

//define element end scroll points
	var endOne = 1398;//maximum scroll
	var endTwo = endOne + 2048 ;
	var endThree = endTwo + 2600;
	var endFour = endThree + 1398;
	
//on event scroll, change up the buttons
	$(window).scroll(function () {
$.doTimeout( 'scroll', 250, function(){		
	var curPos = $(window).scrollLeft();
	if ( 0 <= curPos && curPos < endOne){
	//show fwd only
	$('.btn-start').fadeOut('fast');
	$('.btn-backarw').fadeOut('fast');
	$('.btn-fwdarw').fadeIn('fast');
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
	$('.btn-fwdarw').fadeIn('fast');
  	}
	if ( endThree <= curPos && curPos < endFour){
	var nextPos = endTwo;
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
	});
	
	$(".btn-backarw").click(function() {  
  	var curPos = $(window).scrollLeft();
  	//if between 0 ad endOne next is two
	if ( 0 <= curPos && curPos < endOne){
	$('.subnav li a').removeClass('active');
	var nextPos = 0;
	$('.btn-wwa').trigger('click');
  	}
	//if between endOne and endTwo next is three
	if ( endOne <= curPos && curPos < endTwo){
	$('.subnav li a').removeClass('active');
	var nextPos = 0;
		//1398+1024
		if ( curPos >= 2422){
		$.scrollTo( endOne+'px', 600, { axis:'x' });
		$('.subnav li .btn-leadership').addClass('active');
		}
		else{
		$('.btn-wwa').trigger('click');
		}
  	}
	if ( endTwo <= curPos && curPos < endThree){
	$('.subnav li a').removeClass('active');
	var nextPos = endOne;
		if ( curPos >= 4111 && curPos < 4801){
			$.scrollTo( endTwo+'px', 600, { axis:'x' });
			$('.subnav li .btn-history').addClass('active');
		}
		else if ( curPos >= 4801){ 
			$.scrollTo( '4111px', 600, { axis:'x' });
			$('.subnav li .btn-history').addClass('active');
		}
		else{
		$('.btn-leadership').trigger('click');
		}
	
  	}
	if ( endThree <= curPos && curPos < endFour){
	$('.subnav li a').removeClass('active');
	$('.subnav li .btn-history').addClass('active');
	var nextPos = endTwo;
	$('.btn-history').trigger('click');
  	}
	//$.scrollTo( nextPos+'px', 600, { axis:'x' });
	});	
	
   $(".btn-fwdarw").click(function() {  
  	var curPos = $(window).scrollLeft();
  	//if between 0 ad endOne next is two
	if ( 0 <= curPos && curPos < endOne){
	$('.subnav li a').removeClass('active');
	$('.subnav li .btn-leadership').addClass('active');
	var nextPos = endOne;
	$('.btn-leadership').trigger('click');
  	}
	//if between endOne and endTwo next is three
	if ( endOne <= curPos && curPos < endTwo){
		$('.subnav li a').removeClass('active');	
	var nextPos = endTwo;
		if ( curPos >= 2422){
		$('.btn-history').trigger('click');
		}
		else{
		$.scrollTo( '2422px', 600, { axis:'x' });
		$('.subnav li .btn-leadership').addClass('active');
		}
  	} 
	if ( endTwo <= curPos && curPos < endThree){
	$('.subnav li a').removeClass('active');
	
	var nextPos = endThree;
		// 3446 + 665 and  1355
		if ( curPos >= 4111 && curPos < 4801){
			$.scrollTo( '4801px', 600, { axis:'x' });
			$('.subnav li .btn-history').addClass('active');
		}
		else if ( curPos >= 4801){ 
			$('.btn-careers').trigger('click');
		}
		else{
		$.scrollTo( '4111px', 600, { axis:'x' });
		$('.subnav li .btn-history').addClass('active');
		}
	
  	}
	if ( endThree <= curPos && curPos < endFour){
	$('.subnav li a').removeClass('active');
	$('.subnav li .btn-careers').addClass('active');
	var nextPos = endFour;
	$('.btn-careers').trigger('click');
  	}
	//$.scrollTo( nextPos+'px', 600, { axis:'x' });
	});


//**** NORMAL NAV CLICK TO SLIDE/SHOW***///
  $('.btn-wwa').click(function(){
	$('.subnav li a').removeClass('active');
    $.scrollTo( '0px', 600, { axis:'x' });
	$(this).live();
	//$.loadHash({ varHash: '' });
	return false;
  });
  
  $('.btn-leadership').click(function(){
	$('.subnav li a').removeClass('active');
	$('.subnav li .btn-leadership').addClass('active');
	$.scrollTo( endOne+'px', 600, { axis:'x' });
	$(this).live();
	//$.loadHash({ varHash: 'leadership' });
	return false;
  });
  $('.btn-history').click(function(){
	$('.subnav li a').removeClass('active');
	$('.subnav li .btn-history').addClass('active');
	$.scrollTo( endTwo+'px', 600, { axis:'x' });
	$(this).live();
	//$.loadHash({ varHash: 'history' });
	return false;
  });
  $('.btn-careers').click(function(){
	$('.subnav li a').removeClass('active');
	$('.subnav li .btn-careers').addClass('active');
	$.scrollTo( endThree+'px', 600, { axis:'x' });
	$(this).live();    
	return false;
  }); 

function loadHash(varHash)
{
  if(varHash != undefined) {
    var strBrowser = navigator.userAgent.toLowerCase();

    if (strBrowser.indexOf('chrome') > 0 || strBrowser.indexOf('safari') > 0) {
        this.location.href = "#" + varHash;
    }
    else {
        this.window.location.hash = "#" + varHash;
    }
  }
}


//**** SET WIDTHS ***///
var mainWidth = $('#mwwa2').width();	
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
		var mainHeight = $('#mwwa2').height();
		var mhPlus = mainHeight + (119*2);
		var mhLarge = h - (119*2);
		
		var newPadding = (w-1182) / 2;
		
	   if (w < 1182){
		   $("#mwwa2").css('padding-left',0);
		   $("#mwwa2").css('padding-right',0);
		   //var nowPadding = 0;
	   }
	   else {
			$("#mwwa2").css('padding-left',newPadding);
			$("#mwwa2").css('padding-right',newPadding);
			//var nowPadding = newPadding;
		   }
		if (h > mhPlus){
		   $('#main').css('height',mhLarge);
	   }
	   else {
			$("#main").css('height',mainHeight);
		   }
	}	

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
	
//**** LEADERSHIP***///
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
  	
  	$('.contactFooter').click(function() {
    $('#sliderTop').slideToggle('slow');
	$('.default').dropkick();
    return false;
  	});

	//showcontact
	$('#contactSlide').hide().css({visibility: "visible"}).fadeIn(2000);

//**** CHECK URL***///
	 if(window.location.hash === "#leadership"){
	  setTimeout(function() { //alert('hello');
	$('.btn-leadership').trigger('click');
	  },1000);}
	  if(window.location.hash === "#history"){
	  setTimeout(function() { 
	$('.btn-history').trigger('click');
	  },1000); }
	  if(window.location.hash === "#careers"){
	  setTimeout(function() { 
	$('.btn-careers').trigger('click');
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
     $('#mwwa2').delay(500).fadeIn('medium');
    return false;
  });  
});