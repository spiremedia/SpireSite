/* ------------------------------------------------------------------------
	Class: prettyPhoto
	Use: Lightbox clone for jQuery
	Author: Stephane Caron (http://www.no-margin-for-errors.com)
	Version: 2.2.2
------------------------------------------------------------------------- */
	jQuery.noConflict();
	jQuery.fn.prettyPhoto = function(settings) {
		// global Variables
		var isSet = false; /* Total position in the array */
		var setCount = 0; /* Total images in the set */
		var setPosition = 0; /* Position in the set */
		var arrayPosition = 0; /* Total position in the array */
		var hasTitle = false;
		var caller = 0;
		var doresize = true;
		var imagesArray = [];
	
		jQuery(window).scroll(function(){ _centerPicture(); });
		jQuery(window).resize(function(){ _centerPicture(); _resizeOverlay(); });
		jQuery(document).keyup(function(e){
			switch(e.keyCode){
				case 37:
					if (setPosition == 1) return;
					changePicture('previous');
					break;
				case 39:
					if (setPosition == setCount) return;
					changePicture('next');
					break;
				case 27:
					close();
					break;
			};
	    });
 
	
		settings = jQuery.extend({
			animationSpeed: 'normal', /* fast/slow/normal */
			padding: 40, /* padding for each side of the picture */
			opacity: 0.35, /* Value betwee 0 and 1 */
			showTitle: true, /* true/false */
			allowresize: true, /* true/false */
			counter_separator_label: '/' /* Teh separator for the gallery counter 1 "of" 2 */
		}, settings);
	
		jQuery(this).each(function(){
			imagesArray[imagesArray.length] = this;
			jQuery(this).bind('click',function(){
				open(this); return false;
			});
		});
	
		function open(el) {
			caller = jQuery(el);
		
			// Find out if the picture is part of a set
			theRel = jQuery(caller).attr('rel');
			galleryRegExp = /\[(?:.*)\]/;
			theGallery = galleryRegExp.exec(theRel);
		
			// Find out the type of content
			contentType = "image";
			if(jQuery(caller).attr('href').indexOf('.swf') > 0){ hasTitle = false; contentType = 'flash'; };
		
			// Calculate the number of items in the set, and the position of the clicked picture.
			isSet = false;
			setCount = 0;
			for (i = 0; i < imagesArray.length; i++){
				if(jQuery(imagesArray[i]).attr('rel').indexOf(theGallery) != -1){
					setCount++;
					if(setCount > 1) isSet = true;

					if(jQuery(imagesArray[i]).attr('href') == jQuery(el).attr('href')){
						setPosition = setCount;
						arrayPosition = i;
					};
				};
			};
		
			_buildOverlay(isSet);

			// Display the current position
			jQuery('div.pictureHolder p.currentTextHolder').text(setPosition + settings.counter_separator_label + setCount);

			// Position the picture in the center of the viewing area
			_centerPicture();
		
			jQuery('div.pictureHolder #fullResImageContainer').hide();
			jQuery('.loaderIcon').show();

			// Display the correct type of information
			(contentType == 'image') ? _preload() : _writeFlash();
		};
	
		showimage = function(width,height,containerWidth,containerHeight,contentHeight,contentWidth,resized){
			jQuery('.loaderIcon').hide();
			var scrollPos = _getScroll();

			if(jQuery.browser.opera) {
				windowHeight = window.innerHeight;
				windowWidth = window.innerWidth;
			}else{
				windowHeight = jQuery(window).height();
				windowWidth = jQuery(window).width();
			};

			jQuery('div.pictureHolder .content').animate({'height':contentHeight,'width':containerWidth},settings.animationSpeed);

			projectedTop = scrollPos['scrollTop'] + ((windowHeight/2) - (containerHeight/2));
			if(projectedTop < 0) projectedTop = 0 + jQuery('div.prettyPhotoTitle').height();

			// Resize the holder
			jQuery('div.pictureHolder').animate({
				'top': projectedTop,
				'left': ((windowWidth/2) - (containerWidth/2)),
				'width': containerWidth
			},settings.animationSpeed,function(){
				jQuery('#fullResImage').attr({
					'width':width,
					'height':height
				});

				jQuery('div.pictureHolder').width(containerWidth);
				jQuery('div.pictureHolder .hoverContainer').height(height).width(width);

				// Show the nav elements
				_shownav();

				// Fade the new image
				jQuery('div.pictureHolder #fullResImageContainer').fadeIn(settings.animationSpeed);
			
				// Fade the resizing link if the image is resized
				if(resized) jQuery('a.expand,a.contract').fadeIn(settings.animationSpeed);
			});
		};
	
		function changePicture(direction){
			if(direction == 'previous') {
				arrayPosition--;
				setPosition--;
			}else{
				arrayPosition++;
				setPosition++;
			};

			// Allow the resizing of the images
			if(!doresize) doresize = true;

			// Fade out the current picture
			jQuery('div.pictureHolder .hoverContainer,div.pictureHolder .details').fadeOut(settings.animationSpeed);
			jQuery('div.pictureHolder #fullResImageContainer').fadeOut(settings.animationSpeed,function(){
				jQuery('.loaderIcon').show();
			
				// Preload the image
				_preload();
			});

			_hideTitle();
			jQuery('a.expand,a.contract').fadeOut(settings.animationSpeed,function(){
				jQuery(this).removeClass('contract').addClass('expand');
			});
		};
	
		function close(){
			jQuery('div.pictureHolder,div.prettyPhotoTitle').fadeOut(settings.animationSpeed, function(){
				jQuery('div.prettyPhotoOverlay').fadeOut(settings.animationSpeed, function(){
					jQuery('div.prettyPhotoOverlay,div.pictureHolder,div.prettyPhotoTitle').remove();
				
					// To fix the bug with IE select boxes
					if(jQuery.browser.msie && jQuery.browser.version == 6){
						jQuery('select').css('visibility','visible');
					};
				});
			});
		};
	
		function _checkPosition(){
			// If at the end, hide the next link
			if(setPosition == setCount) {
				jQuery('div.pictureHolder a.next').css('visibility','hidden');
				jQuery('div.pictureHolder a.arrow_next').addClass('disabled').unbind('click');
			}else{ 
				jQuery('div.pictureHolder a.next').css('visibility','visible');
				jQuery('div.pictureHolder a.arrow_next.disabled').removeClass('disabled').bind('click',function(){
					changePicture('next');
					return false;
				});
			};
		
			// If at the beginning, hide the previous link
			if(setPosition == 1) {
				jQuery('div.pictureHolder a.previous').css('visibility','hidden');
				jQuery('div.pictureHolder a.arrow_previous').addClass('disabled').unbind('click');
			}else{
				jQuery('div.pictureHolder a.previous').css('visibility','visible');
				jQuery('div.pictureHolder a.arrow_previous.disabled').removeClass('disabled').bind('click',function(){
					changePicture('previous');
					return false;
				});
			};
		
			// Change the current picture text
			jQuery('div.pictureHolder p.currentTextHolder').text(setPosition + settings.counter_separator_label + setCount);
		
			(isSet) ? $c = jQuery(imagesArray[arrayPosition]) : $c = jQuery(caller);

			if($c.attr('title')){
				jQuery('div.pictureHolder .description').show().html(unescape($c.attr('title')));
			}else{
				jQuery('div.pictureHolder .description').hide().text('');
			};
		
			if($c.find('img').attr('alt') && settings.showTitle){
				hasTitle = true;
				jQuery('div.prettyPhotoTitle .prettyPhotoTitleContent').html(unescape($c.find('img').attr('alt')));
			}else{
				hasTitle = false;
			};
		};
	
		function _fitToViewport(width,height){
			hasBeenResized = false;
		
			jQuery('div.pictureHolder .details').width(width); /* To have the correct height */
			jQuery('div.pictureHolder .details p.description').width(width - parseFloat(jQuery('div.pictureHolder a.close').css('width'))); /* So it doesn't overlap the button */
		
			// Get the container size, to resize the holder to the right dimensions
			contentHeight = height + parseFloat(jQuery('div.pictureHolder .details').height()) + parseFloat(jQuery('div.pictureHolder .details').css('margin-top')) + parseFloat(jQuery('div.pictureHolder .details').css('margin-bottom'));
			contentWidth = width;
			containerHeight = height + parseFloat(jQuery('div.prettyPhotoTitle').height()) + parseFloat(jQuery('div.pictureHolder .top').height()) + parseFloat(jQuery('div.pictureHolder .bottom').height());
			containerWidth = width + settings.padding;
		
			// Define them in case there's no resize needed
			imageWidth = width;
			imageHeight = height;

			if(jQuery.browser.opera) {
				windowHeight = window.innerHeight;
				windowWidth = window.innerWidth;
			}else{
				windowHeight = jQuery(window).height();
				windowWidth = jQuery(window).width();
			};
		
			if( ((containerWidth > windowWidth) || (containerHeight > windowHeight)) && doresize && settings.allowresize) {
				hasBeenResized = true;
			
				if((containerWidth > windowWidth) && (containerHeight > windowHeight)){
					// Get the original geometry and calculate scales
					var xscale =  (containerWidth + 200) / windowWidth;
					var yscale = (containerHeight + 200) / windowHeight;
				}else{
					// Get the original geometry and calculate scales
					var xscale = windowWidth / containerWidth;
					var yscale = windowHeight / containerHeight;
				}

				// Recalculate new size with default ratio
				if (yscale>xscale){
					imageWidth = Math.round(width * (1/yscale));
					imageHeight = Math.round(height * (1/yscale));
				} else {
					imageWidth = Math.round(width * (1/xscale));
					imageHeight = Math.round(height * (1/xscale));
				};
			
				// Define the new dimensions
				contentHeight = imageHeight + parseFloat(jQuery('div.pictureHolder .details').height()) + parseFloat(jQuery('div.pictureHolder .details').css('margin-top')) + parseFloat(jQuery('div.pictureHolder .details').css('margin-bottom'));
				contentWidth = imageWidth;
				containerHeight = imageHeight + parseFloat(jQuery('div.prettyPhotoTitle').height()) + parseFloat(jQuery('div.pictureHolder .top').height()) + parseFloat(jQuery('div.pictureHolder .bottom').height());
				containerWidth = imageWidth + settings.padding;
			
				jQuery('div.pictureHolder .details').width(contentWidth); /* To have the correct height */
				jQuery('div.pictureHolder .details p.description').width(contentWidth - parseFloat(jQuery('div.pictureHolder a.close').css('width'))); /* So it doesn't overlap the button */
			};

			return {
				width:imageWidth,
				height:imageHeight,
				containerHeight:containerHeight,
				containerWidth:containerWidth,
				contentHeight:contentHeight,
				contentWidth:contentWidth,
				resized:hasBeenResized
			};
		};
	
		function _centerPicture(){
			//Make sure the gallery is open
			if(jQuery('div.pictureHolder').size() > 0){
			
				var scrollPos = _getScroll();
			
				if(jQuery.browser.opera) {
					windowHeight = window.innerHeight;
					windowWidth = window.innerWidth;
				}else{
					windowHeight = jQuery(window).height();
					windowWidth = jQuery(window).width();
				};
			
				if(doresize) {
					projectedTop = (windowHeight/2) + scrollPos['scrollTop'] - (jQuery('div.pictureHolder').height()/2);
					if(projectedTop < 0) projectedTop = 0 + jQuery('div.prettyPhotoTitle').height();
					
					jQuery('div.pictureHolder').css({
						'top': projectedTop,
						'left': (windowWidth/2) + scrollPos['scrollLeft'] - (jQuery('div.pictureHolder').width()/2)
					});
			
					jQuery('div.prettyPhotoTitle').css({
						'top' : jQuery('div.pictureHolder').offset().top - jQuery('div.prettyPhotoTitle').height(),
						'left' : jQuery('div.pictureHolder').offset().left + (settings.padding/2)
					});
				};
			};
		};
	
		function _shownav(){
			if(isSet) jQuery('div.pictureHolder .hoverContainer').fadeIn(settings.animationSpeed);
			jQuery('div.pictureHolder .details').fadeIn(settings.animationSpeed);

			_showTitle();
		};
	
		function _showTitle(){
			if(settings.showTitle && hasTitle){
				jQuery('div.prettyPhotoTitle').css({
					'top' : jQuery('div.pictureHolder').offset().top,
					'left' : jQuery('div.pictureHolder').offset().left + (settings.padding/2),
					'display' : 'block'
				});
			
				jQuery('div.prettyPhotoTitle div.prettyPhotoTitleContent').css('width','auto');
			
				if(jQuery('div.prettyPhotoTitle').width() > jQuery('div.pictureHolder').width()){
					jQuery('div.prettyPhotoTitle div.prettyPhotoTitleContent').css('width',jQuery('div.pictureHolder').width() - (settings.padding * 2));
				}else{
					jQuery('div.prettyPhotoTitle div.prettyPhotoTitleContent').css('width','');
				};
			
				jQuery('div.prettyPhotoTitle').animate({'top':(jQuery('div.pictureHolder').offset().top - 22)},settings.animationSpeed);
			};
		};
	
		function _hideTitle() {
			jQuery('div.prettyPhotoTitle').animate({'top':(jQuery('div.pictureHolder').offset().top)},settings.animationSpeed,function() { jQuery(this).css('display','none'); });
		};
	
		function _preload(){
			// Hide the next/previous links if on first or last images.
			_checkPosition();
		
			// Set the new image
			imgPreloader = new Image();
		
			// Preload the neighbour images
			nextImage = new Image();
			if(isSet) nextImage.src = jQuery(imagesArray[arrayPosition + 1]).attr('href');
			prevImage = new Image();
			if(isSet && imagesArray[arrayPosition - 1]) prevImage.src = jQuery(imagesArray[arrayPosition - 1]).attr('href');

			jQuery('div.pictureHolder .content').css('overflow','hidden');
		
			if(isSet) {
				jQuery('div.pictureHolder #fullResImage').attr('src',jQuery(imagesArray[arrayPosition]).attr('href'));
			}else{
				jQuery('div.pictureHolder #fullResImage').attr('src',jQuery(caller).attr('href'));
			};

			imgPreloader.onload = function(){
				var correctSizes = _fitToViewport(imgPreloader.width,imgPreloader.height);
				imgPreloader.width = correctSizes['width'];
				imgPreloader.height = correctSizes['height'];
			
				// Need that small delay for the anim to be nice
				setTimeout('showimage(imgPreloader.width,imgPreloader.height,'+correctSizes["containerWidth"]+','+correctSizes["containerHeight"]+','+correctSizes["contentHeight"]+','+correctSizes["contentWidth"]+','+correctSizes["resized"]+')',500);
			};
		
			(isSet) ? imgPreloader.src = jQuery(imagesArray[arrayPosition]).attr('href') : imgPreloader.src = jQuery(caller).attr('href');
		};
	
		function _getScroll(){
			scrollTop = window.pageYOffset || document.documentElement.scrollTop || 0;
			scrollLeft = window.pageXOffset || document.documentElement.scrollLeft || 0;
			return {scrollTop:scrollTop,scrollLeft:scrollLeft};
		};
	
		function _resizeOverlay() {
			jQuery('div.prettyPhotoOverlay').css({
				'height':jQuery(document).height(),
				'width':jQuery(window).width()
			});
		};
	
		function _writeFlash(){
			flashParams = jQuery(caller).attr('rel').split(';');
			jQuery(flashParams).each(function(i){
				// Define the width and height
				if(flashParams[i].indexOf('width') >= 0) flashWidth = flashParams[i].substring(flashParams[i].indexOf('width') + 6, flashParams[i].length);
				if(flashParams[i].indexOf('height') >= 0) flashHeight = flashParams[i].substring(flashParams[i].indexOf('height') + 7, flashParams[i].length);
				if(flashParams[i].indexOf('flashvars') >= 0) flashVars = flashParams[i].substring(flashParams[i].indexOf('flashvars') + 10, flashParams[i].length);
			});
		
			jQuery('.pictureHolder #fullResImageContainer').append('<embed width="'+flashWidth+'" height="'+flashHeight+'" pluginspage="http://www.macromedia.com/shockwave/download/index.cgi?P1_Prod_Version=ShockwaveFlash" type="application/x-shockwave-flash" wmode="opaque" name="prettyFlash" flashvars="'+flashVars+'" allowscriptaccess="always" bgcolor="#FFFFFF" quality="high" src="'+jQuery(caller).attr('href')+'"/>');
			jQuery('#fullResImage').hide();
		
			contentHeight = parseFloat(flashHeight) + parseFloat(jQuery('div.pictureHolder .details').height()) + parseFloat(jQuery('div.pictureHolder .details').css('margin-top')) + parseFloat(jQuery('div.pictureHolder .details').css('margin-bottom'));
			contentWidth = parseFloat(flashWidth)+ parseFloat(jQuery('div.pictureHolder .details').width()) + parseFloat(jQuery('div.pictureHolder .details').css('margin-left')) + parseFloat(jQuery('div.pictureHolder .details').css('margin-right'));
			containerHeight = contentHeight + parseFloat(jQuery('div.pictureHolder .top').height()) + parseFloat(jQuery('div.pictureHolder .bottom').height());
			containerWidth = parseFloat(flashWidth) + parseFloat(jQuery('div.pictureHolder .content').css("padding-left")) + parseFloat(jQuery('div.pictureHolder .content').css("padding-right")) + settings.padding;
		
			setTimeout('showimage('+flashWidth+','+flashHeight+','+containerWidth+','+containerHeight+','+contentHeight+','+contentWidth+')',500);
		};
	
		function _buildOverlay(){
		
			// Build the background overlay div
			backgroundDiv = "<div class='prettyPhotoOverlay'></div>";
			jQuery('body').append(backgroundDiv);
			jQuery('div.prettyPhotoOverlay').css('height',jQuery(document).height()).bind('click',function(){
				close();
			});
		
			// Basic HTML for the picture holder
			pictureHolder = '<div class="pictureHolder"><div class="top"><div class="left"></div><div class="middle"></div><div class="right"></div></div><div class="content"><a href="#" class="expand" title="Expand the image">Expand</a><div class="loaderIcon"></div><div class="hoverContainer"><a class="next" href="#">next</a><a class="previous" href="#">previous</a></div><div id="fullResImageContainer"><img id="fullResImage" src="" /></div><div class="details clearfix"><a class="close" href="#">Close</a><p class="description"></p><div class="nav"><a href="#" class="arrow_previous">Previous</a><p class="currentTextHolder">0'+settings.counter_separator_label+'0</p><a href="#" class="arrow_next">Next</a></div></div></div><div class="bottom"><div class="left"></div><div class="middle"></div><div class="right"></div></div></div>';
		
			// Basic html for the title holder
			titleHolder = '<div class="prettyPhotoTitle"><div class="prettyPhotoTitleLeft"></div><div class="prettyPhotoTitleContent"></div><div class="prettyPhotoTitleRight"></div></div>';

			jQuery('body').append(pictureHolder).append(titleHolder);

			jQuery('.pictureHolder,.titleHolder').css({'opacity': 0});
			jQuery('a.close').bind('click',function(){ close(); return false; });
			jQuery('a.expand').bind('click',function(){
			
				// Expand the image
				if(jQuery(this).hasClass('expand')){
					jQuery(this).removeClass('expand').addClass('contract');
					doresize = false;
				}else{
					jQuery(this).removeClass('contract').addClass('expand');
					doresize = true;
				};
			
				_hideTitle();
				jQuery('div.pictureHolder .hoverContainer,div.pictureHolder #fullResImageContainer').fadeOut(settings.animationSpeed);
				jQuery('div.pictureHolder .details').fadeOut(settings.animationSpeed,function(){
					_preload();
				});
			
				return false;
			});
		
			jQuery('.pictureHolder .previous,.pictureHolder .arrow_previous').bind('click',function(){
				changePicture('previous');
				return false;
			});
		
			jQuery('.pictureHolder .next,.pictureHolder .arrow_next').bind('click',function(){
				changePicture('next');
				return false;
			});

			jQuery('.hoverContainer').css({
				'margin-left': settings.padding/2
			});
		
			// If it's not a set, hide the links
			if(!isSet) {
				jQuery('.hoverContainer,.nav').hide();
			};


			// To fix the bug with IE select boxes
			if(jQuery.browser.msie && jQuery.browser.version == 6){
				jQuery('select').css('visibility','hidden');
			};

			// Then fade it in
			jQuery('div.prettyPhotoOverlay').css('opacity',0).fadeTo(settings.animationSpeed,settings.opacity, function(){
				jQuery('div.pictureHolder').css('opacity',0).fadeIn(settings.animationSpeed,function(){
					// To fix an IE bug
					jQuery('div.pictureHolder').attr('style','left:'+jQuery('div.pictureHolder').css('left')+';top:'+jQuery('div.pictureHolder').css('top')+';');
				});
			});
		};
	};