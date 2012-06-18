// JavaScript Document : Spire Media Inc.
jQuery(document).ready(function(){

// ### Plax Graphic ### //	
	$('#plax-dot-1').plaxify({"xRange":250, "yRange":200, "invert":true})
	$('#plax-dot-2').plaxify({"xRange":300,"yRange":0, "invert":false})
	$('#plax-dot-3').plaxify({"xRange":100,"yRange":50, "invert":true})
	$('#plax-dot-4').plaxify({"xRange":300,"yRange":250, "invert":true})
	$('#plax-dot-5').plaxify({"xRange":100,"yRange":200, "invert":false})
	$('#plax-dot-6').plaxify({"xRange":50,"yRange":10, "invert":true})
	$('#plax-dot-7').plaxify({"xRange":200,"yRange":0, "invert":true})
	$('#plax-dot-8').plaxify({"xRange":500,"yRange":300, "invert":false})
	$('#plax-dot-9').plaxify({"xRange":600,"yRange":100, "invert":true})
	$('#plax-dot-10').plaxify({"xRange":100,"yRange":100, "invert":true})
	$('#plax-dot-11').plaxify({"xRange":400,"yRange":300, "invert":true})
	$('#plax-dot-12').plaxify({"xRange":200,"yRange":250, "invert":false})
	$('#plax-dot-13').plaxify({"xRange":100,"yRange":300, "invert":true})
	$('#plax-dot-14').plaxify({"xRange":350,"yRange":20, "invert":true})
	$('#plax-dot-15').plaxify({"xRange":250,"yRange":0, "invert":false})
	$('#plax-dot-16').plaxify({"xRange":450,"yRange":100, "invert":true})
	$('#plax-dot-17').plaxify({"xRange":200,"yRange":300, "invert":true})
	$('#plax-dot-18').plaxify({"xRange":100,"yRange":200, "invert":true})
	$('#plax-dot-19').plaxify({"xRange":75,"yRange":50, "invert":false})
	$('#plax-step-1').plaxify({"xRange":10,"yRange":10, "invert":true})
	$('#plax-step-2').plaxify({"xRange":30,"yRange":20, "invert":true})
	$('#plax-step-3').plaxify({"xRange":50,"yRange":30, "invert":true})
	$('#plax-step-4').plaxify({"xRange":70,"yRange":40, "invert":true})
	$('#plax-step-5').plaxify({"xRange":90,"yRange":50, "invert":false})
	$('#plax-step-6').plaxify({"xRange":110,"yRange":60, "invert":true})
	$('#plax-step-7').plaxify({"xRange":130,"yRange":70, "invert":true})
	$('#plax-step-8').plaxify({"xRange":150,"yRange":50, "invert":true})
	$('#plax-step-9').plaxify({"xRange":130,"yRange":70, "invert":true})
	$('#plax-step-10').plaxify({"xRange":120,"yRange":90, "invert":false})
	$('#plax-step-11').plaxify({"xRange":150,"yRange":100, "invert":true})
	$('#plax-step-12').plaxify({"xRange":70,"yRange":40, "invert":true})
	$('#plax-step-13').plaxify({"xRange":50,"yRange":100, "invert":true})
	$('#plax-crane').plaxify({"xRange":40, "yRange":0, "invert":true})
	$.plax.enable({ "activityTarget": $('#shell')})
	
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