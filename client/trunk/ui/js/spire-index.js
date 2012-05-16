// JavaScript Document : Spire Media Inc.
jQuery(document).ready(function(){


//### Clients Slider ###//
	//Hide slider
	$('.boxClients').hide();

//load clientslider
var slider = $('#sliderClient').bxSlider({
    controls: false
});
$('#prevClient').click(function(){
    slider.goToPreviousSlide();
    return false;
});
$('#nextClient').click(function(){
    slider.goToNextSlide();
    return false;
});

//onclick load client slider
$('.lc-box').click(function() {
	//slider.goToSlide(this.id);
	 var pos = $(this).attr('id');
	$('.logoClients').fadeOut('slow');
	 
    $('.boxClients').fadeIn('slow', function() {
        // Animation complete 
	slider.goToSlide(pos);
      });

    //goPos(pos);
	
    return false;
  	});

//close client slider
$('.btn-closeic').click(function() {
	 var pos = $(this).attr('id');
	$('.boxClients').fadeOut('slow');	 
    $('.logoClients').fadeIn('slow');
    return false;
  	});

//### Resize MAIN INDEX ###//


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

//### FOOTER SLIDER ###//	

		
});

jQuery(window).load(function() {
	jQuery('#loading-image').fadeOut('fast');
});