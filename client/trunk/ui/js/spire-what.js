// JavaScript Document : Spire Media Inc.
jQuery(document).ready(function(){
 
//### FEATURED ROLLOVERS ###//	
	
	//Hide Rollovers
	$('.wwd0-on').hide();
	
$('#firstboxes li').hover(function(){
     $(this).removeClass('fade').siblings().addClass('fade');
},function(){
     $(this).siblings().andSelf().removeClass('fade');
})


	function showBox1() {	
		$(this).animate({ lineHeight: "282px"}, { duration: "fast" });
	}			
	function hideBox1() {
		//$(this).parent.children.css({ opacity:".5" });				
		$(this).animate({  lineHeight: "270px" }, { duration: "fast" });
	}
	
	$('.box1, .box2, .box3, .box4').hoverIntent({					
	sensitivity: 1, // number = sensitivity threshold (must be 1 or higher)
	interval: 0,   // number = milliseconds of polling interval (we don't need this as it is initiated on click rather than hover)
	over: showBox1,  // function = onMouseOver callback (required)
	timeout: 0,   // number = milliseconds delay before onMouseOut function call
	out: hideBox1   // function = onMouseOut callback (required)	
	})
	
		
//### Resize MAIN ###//
jQuery.event.add(window, "load", resizeMain);
jQuery.event.add(window, "resize", resizeMain);
function resizeMain() 
{
    var h = $(window).height();
    var w = $(window).width();
	var largest = 671;
	var minWindow = largest + (119*2);
	
	if ( h > minWindow){
		$("#WWD").css('height',(h - (119*2)));
		//$("#mainWWD").css('margin-top',(-(h -119)));
		$("#mainWhat, .bg0, .bg1, .bg2, .bg3, .bg4").css('height',(h - (119*2)));
		//$("#wwd-0, #wwd-1, #wwd-2, #wwd-3, #wwd-4").css('height',(h -119 -45));
		//$("#sliderInfo").css('width',1026);
	}
	else {
		$("#WWD").css('height',largest);
		//$("#mainWWD").css('margin-top',(-(671)));
		$("#mainWhat, .bg0, .bg1, .bg2, .bg3, .bg4").css('height',largest);
		//$("#wwd-0, #wwd-1, #wwd-2, #wwd-3, #wwd-4").css('height',671 -45);
		//$("#sliderInfo").css('width',1006);
	}
	
	if ( w < 1398){
	var halfW = (w-758)/2;
	var halfW2 = (w-974)/2;
	
	var lastwidth = -(1398 - w);
		
		if (w > 1182 ){ $("#WWD").css('width', w); }
		 else { $("#WWD").css('width','1182px'); }
		
		
			 
		 if (halfW > 210 ){ $("#wwd-0").css('padding-left', halfW); }
		 else { $("#wwd-0").css('padding-left', '210px'); }
		 
		 if (halfW2 > 104 ){ $("#wwd-1, #wwd-2, #wwd-3, #wwd-4").css('padding-left', halfW2); }
		 else { $("#wwd-1, #wwd-2, #wwd-3, #wwd-4").css('padding-left', '104px'); }
		 
		//$("#main_wwd").css('margin-left', lastwidth); 
		//$("#sliderInfo").css('width',1026);
	}
	else {
		$("#WWD").css('width',w-17);
		
		$("#wwd-0").css('padding','45px 320px 0' );
		 $("#wwd-1, #wwd-2, #wwd-3, #wwd-4").css('padding', '45px 212px 0');
		 //$("#main_wwd").css('margin-left', 'auto'); 
		 
		 
		 
		 
	}
	
    
}
	

	
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
     $('#slider1').delay(500).fadeIn('medium', goto);
    return false;
  });
  
  
function goto(){

		 if(window.location.hash === "#ux-design"){
	  setTimeout(function() { //alert('hello');
	$('.btn-uxd').trigger('click');
	  },1000);}
	  if(window.location.hash === "#visual-design"){
	  setTimeout(function() { 
	$('.btn-vd').trigger('click');
	  },1000); }
	  if(window.location.hash === "#web-development"){
	  setTimeout(function() { 
	$('.btn-wd').trigger('click');
	  },1000);}
	  if(window.location.hash === "#mobile-development"){
	  setTimeout(function() { 
	$('.btn-md').trigger('click');
	  },1000); }
}
	  
});

  $(document).ready(function(){

	var slider = $('#slider1').bxSlider({
    controls: false, infiniteLoop: false,
  });
  
  $('#slider1').hide();
  $('.sla-left-off .btn-wwd2, .sla-left-off .btn-uxd2, .sla-left-off .btn-vd2, .sla-left-off .btn-wd2').hide();
  $('.sla-right-off .btn-vd2, .sla-right-off .btn-wd2, .sla-right-off .btn-md2').hide();
  $('.btn-wwd3').hide();  
  
//### SLIDER###//	
	$(".bx-window").css('overflow','visible');
	//$("#slider1").css('position', 'absolute');
	
	$('#go-prev').click(function(){
    slider.goToPreviousSlide();
    return false;
  });
  
  $('#go-next').click(function(){
    slider.goToNextSlide();
    return false;
  });	
  $('.btn-wwd, .btn-wwd2, .btn-wwd3').click(function(){
		$('.sla-left-off .btn-wwd2, .sla-left-off .btn-uxd2, .sla-left-off .btn-vd2, .sla-left-off .btn-wd2').hide();
		$('.sla-right-off .btn-uxd2, .sla-right-off .btn-vd2, .sla-right-off .btn-wd2, .sla-right-off .btn-md2').hide();
		$('.btn-wwd3').hide(); 
		$('.sla-right-off .btn-uxd2').fadeIn();
		
	$('.subnav li a').removeClass('active');
    slider.goToFirstSlide();
	$(this).live();
    return false;
  });
  
  $('.btn-uxd, .btn-uxd2').click(function(){
	//if ($(this).is('.btn-uxd2')){
		//hide all show prev and next
		$('.sla-left-off .btn-wwd2, .sla-left-off .btn-uxd2, .sla-left-off .btn-vd2, .sla-left-off .btn-wd2').hide();
		$('.sla-right-off .btn-uxd2, .sla-right-off .btn-vd2, .sla-right-off .btn-wd2, .sla-right-off .btn-md2').hide();
		$('.btn-wwd3').show(); 
		$('.sla-left-off .btn-wwd2').fadeIn();
		$('.sla-right-off .btn-vd2').fadeIn();
		//$(this).parent().removeClass('sla-on');
		//$('.sla-right-off').addClass('sla-on');
	//} 
	$('.subnav li a').removeClass('active');
	$('.subnav li .btn-uxd').addClass('active');slider.goToSlide(1);
	$(this).live();
    return false;
  });
  $('.btn-vd, .btn-vd2').click(function(){
		$('.sla-left-off .btn-wwd2, .sla-left-off .btn-uxd2, .sla-left-off .btn-vd2, .sla-left-off .btn-wd2').hide();
		$('.sla-right-off .btn-uxd2, .sla-right-off .btn-vd2, .sla-right-off .btn-wd2, .sla-right-off .btn-md2').hide();
		$('.btn-wwd3').show();
		$('.sla-left-off .btn-uxd2').fadeIn();
		$('.sla-right-off .btn-wd2').fadeIn();
	$('.subnav li a').removeClass('active');
	$('.subnav li .btn-vd').addClass('active');slider.goToSlide(2);
	$(this).live();
    return false;
  });
  $('.btn-wd, .btn-wd2').click(function(){
		$('.sla-left-off .btn-wwd2, .sla-left-off .btn-uxd2, .sla-left-off .btn-vd2, .sla-left-off .btn-wd2').hide();
		$('.sla-right-off .btn-uxd2, .sla-right-off .btn-vd2, .sla-right-off .btn-wd2, .sla-right-off .btn-md2').hide();
		$('.btn-wwd3').show();
		$('.sla-left-off .btn-vd2').fadeIn();
		$('.sla-right-off .btn-md2').fadeIn();
	$('.subnav li a').removeClass('active');
	$('.subnav li .btn-wd').addClass('active');slider.goToSlide(3);
	$(this).live();
    return false;
  });
  $('.btn-md, .btn-md2').click(function(){
		$('.sla-left-off .btn-wwd2, .sla-left-off .btn-uxd2, .sla-left-off .btn-vd2, .sla-left-off .btn-wd2').hide();
		$('.sla-right-off .btn-uxd2, .sla-right-off .btn-vd2, .sla-right-off .btn-wd2, .sla-right-off .btn-md2').hide();
		$('.btn-wwd3').show();
		$('.sla-left-off .btn-wd2').fadeIn();
	$('.subnav li a').removeClass('active');
	$('.subnav li .btn-md').addClass('active');slider.goToSlide(4);
	$(this).live();
    return false;
  });

//ACCORDIONS


	$('.heading').click(function() {
		//when click heading add class current to parent and slidedown
		if($(this).hasClass('current')) {
			//slide up all hiddens and remove all currents
			$('.hidden').slideUp('fast');
			$('.acBox').removeClass('acBox-on');
			$('.heading').removeClass('current');
			$(this).next('.hidden').slideUp('fast');

		} else {
			$('.hidden').slideUp('fast');
			$('.heading').removeClass('current');
			$('.acBox').removeClass('acBox-on');
			$(this).parent().addClass('acBox-on');
			$(this).addClass('current');
			$(this).next('.hidden').slideDown('fast',function() {
			});
		}
		return false;
	});
  
  });
  
$(document).keydown(function(e){  
	//37 - left,  38 - up, 39 - right, 40 - down 
   //if left key check for active sublink then apply click
    if (e.keyCode == 37) { 
		if ($('.subnav li .btn-uxd').hasClass("active")){
	   $('.btn-wwd2').trigger('click');
		}
		if ($('.subnav li .btn-vd').hasClass("active")){
	   $('.btn-uxd').trigger('click');
		}
		if ($('.subnav li .btn-wd').hasClass("active")){
	   $('.btn-vd').trigger('click');
		}
		if ($('.subnav li .btn-md').hasClass("active")){
	   $('.btn-wd').trigger('click');
		}
       return false;
    }
   //if right key  check for active sublink then apply click
    if (e.keyCode == 39) { 

			if ($('.subnav li .btn-uxd').hasClass("active")){
		   $('.btn-vd').trigger('click');
			}
			if ($('.subnav li .btn-vd').hasClass("active")){
		   $('.btn-wd').trigger('click');
			}
			if ($('.subnav li .btn-wd').hasClass("active")){
		   $('.btn-md').trigger('click');
			}
			if ($('.subnav li .btn-md').hasClass("active")){
		   //do nothing
			}

		else { $('.btn-uxd').trigger('click');}

       return false;
    }	
});