(function($) {
	$.fn.esmAccordion = function(options) {
		debug(this);
		// build main options 
		var opts = $.extend({}, $.fn.esmAccordion.defaults, options);
		// iterate 
		return this.parent().each(function() {
			$this = $(this);
			// build element specific options
			var o = $.meta ? $.extend({}, opts, $this.data()) : opts;
			$this.click(function(evt){
				
				var tgt = $(evt.target);
				if (tgt.attr('tagName') != 'DT') return;
				itm = tgt.next().eq(0);
				if (itm.css("display") == "none") itm.css("display", "block");
				else itm.css("display", "none");
				debug(tgt)
				tgt.toggleClass("selected");
				
			});
			focusselectedlinkinnav();
		});
	};
	// private
	function debug($obj) {
		if (window.console && window.console.log)
			window.console.log('accordion selection count: ' + $obj.size());
	};
	
	// public
	//$.fn.hilight.format = function(txt) {
	//};

	// defaults
	$.fn.esmAccordion.defaults = {
		
	};
})(jQuery);

(function($) {
	$.fn.esmPanel = function(options) {
		debug(this);
		
		// build main options 
		var opts = $.extend({}, $.fn.esmPanel.defaults, options);
		// iterate 
		return this.each(function() {
			$this = $(this);

			// build element specific options
			var o = $.meta ? $.extend({}, opts, $this.data()) : opts;
			$this.click(function(evt){
				
				var tgt = $(evt.target);
		
				if (! (tgt.attr('tagName') == "SPAN" && tgt.parent().attr("tagName") == 'DT')) return;
	
				//evt.stopPropagation();
				//loop thru each dldt and make dt's hidden
				$(this).children().each(function(){
					itm = $(this);
					if (itm.attr("tagName") == "DT") itm.removeClass("selected");
					if (itm.attr("tagName") == "DD") itm.css("display","none");
				});
				
				//find the clickd and make it live
				tgt = tgt.parent();
				tgt.addClass("selected");
				tgt.next().eq(0).show();
			});
		});
	};
	// private
	function debug($obj) {
		if (window.console && window.console.log)
			window.console.log('panel selection count: ' + $obj.size());
	};
	
	// public
	//$.fn.hilight.format = function(txt) {
	//};

	// defaults
	$.fn.esmPanel.defaults = {
		
	};
})(jQuery);