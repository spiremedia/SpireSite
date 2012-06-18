// JavaScript Document : Spire Media Inc.
///resize slider height
jQuery(document).ready(function(){

// click year make active

	$('a.xtrig').click(function() {
		$(this).parent().addClass('active');
		$(this).parent().siblings('.mnyBox').removeClass('active');
    return false;
  	});
	
//**** UNIVERSAL NO EDITS***///
//### CONTACT SLIDER ###//	
	//Hide slider
	$('#sliderTop').hide();

//If IE ELSE
 if ( $.browser.msie ) {	
	//if ie <=8  use fade
	var browserNum = parseInt($.browser.version, 10);
	if ( browserNum <= 8 ){
		$('.tabLogo').click(function() {
    		$('#sliderTop').fadeToggle();
		$('.default').dropkick(); 
    		return false;
  	});
	
    $('.closeSlider').click(function() {
	$(this).parent().fadeOut();
    	//$(this).slideUp();
	//alert( $.browser.version );
    return false;
  	});
	
}
else {
	 //else use slide
	$('.tabLogo').click(function() {
    $('#sliderTop').slideToggle('slow');
	$('.default').dropkick();
    return false;
  	});
	
	$('.closeSlider').click(function() {
    $('#sliderTop').slideUp('slow');
	//alert( $.browser.version );
    return false;
  	});
			 
	}
 } else {
	 //else use slide
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
 }

	//showcontact
	$('#contactSlide').hide().css({visibility: "visible"}).fadeIn(2000);

//### END FOOTER SLIDER ###//
		
});

jQuery(window).load(function() {
	jQuery('#loading-image').fadeOut('fast');
	
});