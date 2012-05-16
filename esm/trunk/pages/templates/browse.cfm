<cfoutput>
	#getDataItem('list')#

	<script>
		$(function(){
			$("##browseContent").click(function(evt){
				var tgt = $(evt.target);
				
				if (tgt.hasClass("empty")) {
					addStopSign(); 
					$(".nav", tgt.next()).load(
						"/pages/getMenuSection/", 
						{
							"pageid":tgt.attr("id").substr(0,35), 
							"selectedid":""
						}, 
						function(){removeStopSign();}
					);
					tgt.removeClass("empty")
				}
			})
		});
	</script>
</cfoutput>
