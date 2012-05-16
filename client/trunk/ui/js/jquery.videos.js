
(function($) {
	$.fn.videos = function(options) {
		var opts = $.extend({}, $.fn.videos.defaults, options);
		
		return this.each(function() {
			$this = $(this);
			
			var sobj = {
				ref : $this,
				next : function(){
					var crnt = $("#videolist .current", this.ref).next();
					if (crnt.length == 0) crnt = $("#videolist .video:first", this.ref);
					this.to(crnt);
				},
				prev : function(){
					var crnt = $("#videolist .current", this.ref).prev();
					if (crnt.length == 0) crnt = $("#videolist .video:last", this.ref);
					this.to(crnt);
				},
				to : function(itm){
					$("#videolist .video", this.ref).removeClass("current");
					itm.addClass('current');
					//$("#videoplayer #player", this.ref).html("Playing : " + itm.attr("ref"));
					$("#videoplayer #currenttitle", this.ref).html($("h4", itm).html());
					$("#videoplayer #currentdescription", this.ref).html($("p.videodescription", itm).html() );
					
					//alert( $(".videoplayercontent").height() );
					
					//$("#videolist").height($("#videoplayer").height());					
					
					try{
						document.getElementById("player2").update(itm.attr("ref"));
					} catch(e){}
				}
			};
			
			/* add events */
			$("#vidcontrols a:first", $this).click(function(){sobj.prev();return false;});
			$("#vidcontrols a:last", $this).click(function(){sobj.next();return false;});
			$("#videolist .video", $this).click(function(){	sobj.to($(this))});

			/* setup first */
			sobj.to($("#videolist .video", $this).eq(0));
		});
	};

	$.fn.videos.defaults = {
		//$vid 
	};

})(jQuery);