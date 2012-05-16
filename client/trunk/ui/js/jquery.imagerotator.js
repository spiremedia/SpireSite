
(function($) {
	$.fn.imagerotator = function(options) {

		var defaults = {
			interval: 1500,
			isPaused: false
		};
			
		return this.each(function() {
			$this = $(this);
			/* preload */
			var plis = new Array();
			for (var i in options){
				if (i == parseInt(i)){
					var tmpimg = new Image();
					tmpimg.src = options[i].PATH;
					tmpimg.alt = options[i].NAME;
					plis.push(tmpimg);
				}
			}

			/* create object to track state */
			var sobj = {
				pli : plis,
				ref : $this,
				opts : options,
				movedir : function(dir){
					var c = this.getCurrent();
					if (c == -1 || c == this.opts.length-1) c = 0;
					else c++;

					$(".imageHolder img", this.ref).attr("src", this.pli[c].src)
													.attr("alt", this.pli[c].alt)
													.css('z-index', '-1');

					if (this.opts[c].RELOCATE == '') {
						$(".imageHolder", this.ref).css("cursor", "default");
					}	else {
						$(".imageHolder", this.ref).css("cursor", "pointer");
					} 
					$("#controls img", this.ref).attr("src", "/ui/images/rotatorbtn.png");
					$("#controls a[rel="+c+"] img", this.ref).attr("src", "/ui/images/rotatorbtn_on.png");
				},
				moveto : function(idx){
					$(".imageHolder img", this.ref).attr("src", this.pli[idx].src)
													.attr("alt", this.pli[idx].alt)
													.css('z-index', '-1');

					if (this.opts[idx].RELOCATE == '') {
						$(".imageHolder", this.ref).css("cursor", "default");
					}	else {
						$(".imageHolder", this.ref).css("cursor", "pointer");
					} 
					$("#controls img", this.ref).attr("src", "/ui/images/rotatorbtn.png");
					$("#controls a[rel="+idx+"] img", this.ref).attr("src", "/ui/images/rotatorbtn_on.png");
				},
				go : function(){
					var c = this.getCurrent();
					if (this.opts[c].RELOCATE != "") location.href = this.opts[c].RELOCATE;
				},
				getCurrent : function(){
					var img = $(".imageHolder img", this.ref);
					var imgpath = img.attr("src");
					var c = -1;
					
					for (var i in this.opts){
						//alert(i);
						try {
							if (imgpath.indexOf(this.opts[i].PATH) != -1) c = i;
						} catch(e){
							//alert(e);
						}
					}
					if (c == -1) c = 0;
					return c;
				}
			};
			
			/* add events */
			setInterval(function(){if (!defaults.isPaused) sobj.movedir("+");return false;},defaults.interval); 
			
			//events for controls
			$("#controls a", $this).click(function(){sobj.moveto($(this).attr("rel"));return false;});
			//$("#controls a:first", $this).click(function(){sobj.movedir("+");return false;});
			//$("#controls a:last", $this).click(function(){sobj.movedir("-");return false;});
			
			//events for image and container
			$(".imageHolder", $this).bind("click", function(){sobj.go();});
			//$(".imageHolder", $this).bind("click", function(){sobj.go();});

			$(".imageHolder", $this).bind("mouseenter",function(){
				defaults.isPaused = true;
				return false;
			});
			$this.bind("mouseleave",function(){
				defaults.isPaused = false;
			});
		
			
			//if (sobj.opts && sobj.opts[sobj.getCurrent()].RELOCATE != '') {
			//	$(".imageHolder", $this).css("cursor", "pointer");
			//}
		});
	};
})(jQuery);