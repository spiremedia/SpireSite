
(function($){  
	$.fn.esmclick = function(options){
		return this.each(function(){
		
			var i = new Object();
			i.name = $(this).attr('name');
			i.value = $(this).attr('value');
			i.id = $(this).attr('id');
			i.type = $(this).attr('rel');
			i.url = options.link;
			//sd.info = info;
			if (typeof(options.useForm) == "number"){//requests from form module
				var itm = $(this).parent(); 
			} else {//all other requests
				var $parent = $(this).parent();
				var offsets = $parent.offset();
				var itm = $("<img src='/ui/esm/images/editbtn.png' class='esmClick'/>");
				itm.attr("id", i.id + "_esmclick")
				itm.css("top", (offsets.top) + "px");
				itm.css("left", (offsets.left - 10) + "px");
			}
			itm.click(function(){
				//load the window
				var popupWin = window.open(
				 	i.url.replace('|action|',(i.id == '' || i.type == 'block') ? "add" : "edit") + (i.id == '' ? "" : '&id=' + i.id ) + '&name=' + i.name + '&template=' + escape(i.value) + '&type=' + i.type,
					'optionsWin',
					'width=900,height=500,toolbar=0,resizable=1,scrollbars=1,screenX=0,screenY=0,top=0,left=0'
				);
		
				if ( !document.all && window.focus ) popupWin.focus();
			});
			$(itm).appendTo("body");
		});
	}, 
	$.fn.esmclickresize = function(options){
		return this.each(function(){
			var i = new Object();
			i.name = $(this).attr('name');
			var $parent = $(this).parent();
			//alert($parent.attr("innerHTML"));
			var offsets = $parent.offset();
			var itm = $("#" + i.name + "_esmclick");
			itm.css("top", (offsets.top) + "px");
			itm.css("left", (offsets.left - 10) + "px");
		});
	};
})(jQuery);  

jQuery.noConflict();
jQuery(window).resize(function(){
	jQuery('.contentObjectMarker').esmclickresize();
});

