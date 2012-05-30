/**
 * Header animation js
 */
$(document).ready(function() {
  
  // hover event that fires the animations
  // $('#shell').hover(function() {
  $('#shell').mouseenter(function(){
    
    // step through the images and delay each wave instance
    $('#shell .header-wave').each(function(index){
      // delay each img
      $(this).delay(index *100).animate({
        left: '-=15px',
        top: '-=3px'
      }, 250, 'linear');        
      $(this).animate({
        left: '+=15px',
        top: '+=3px'
      });
    }); // end wave of images
  
    // extra image animations for effect
    $('#shell .header-wave-extra').each(function(index){
      // delay each img
      $(this).delay(index *200).animate({
        left: '-=25px',
        top: '-=10px'
      }, 500);
      $(this).animate({
        left: '+=25px',
        top: '+=10px'
      }, 500);
    }); // end wave of extra images
    
    // make the stars shimmer
    $('#shell .header-dot').each(function(){
      $(this).animate({
        opacity: 0.5,
        left: '+=1px',
        top: '+=1px'
      }, 500, function(){
        $(this).animate({
          opacity: 1,
          left: '-=1px',
          top: '-=1px'
        }, 500);
      });
    }); // end of stars animation
  
  }); // end hover event

}); // close jQuery function