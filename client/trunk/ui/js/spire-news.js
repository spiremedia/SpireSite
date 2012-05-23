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
	jQuery('#loading-image').fadeOut('fast');
	
});