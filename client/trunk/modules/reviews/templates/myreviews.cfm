<h4>My Tasting Notes</h4>
<cfif variables.reviews.recordcount EQ 0>
<p>You have not yet reviewed any products. To review a product, navigate to its page and use the reviews panel.</p>
</cfif>

<cfoutput query="variables.reviews">
	<div class="review">
    	<div class="reviewheader">
		<div class="reviewdate right" style="width:200px">Review Date: #dateformat(variables.reviews.created, "mmm dd, yyyy")# - #timeformat(variables.reviews.created, "hh:mm tt")#</div>
		<a href="/#variables.reviews.pathfirst#/product/#variables.reviews.urlname#">#variables.reviews.title#</a> 
		| <strong>Rating</strong> <img src="/ui/images/reviews/reviews_stars_#variables.reviews.rating#.png"></div>
		#iif(variables.reviews.active, DE(""),DE("<i>(Pending Review)</i>"))#
		<div class="reviewbody">#variables.reviews.comments#</div>
	</div>	
</cfoutput>