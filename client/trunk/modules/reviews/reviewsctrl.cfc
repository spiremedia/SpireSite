<cfcomponent name="rewviewsformctrl">

	<cffunction name="init">
		<cfargument name="data" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="pageRef" required="true">
		<cfargument name="name" required="true">
		<cfargument name="module" required="true">
		<cfargument name="moduleaction" required="true">
		
		<cfsavecontent variable="jsFunc">
			<script language="javascript">
                function highlighticon(chosen)
                {
                    for(var i=1;i<=5;i++)
                    { //mark any icons equal to or less than currently chosen icon, unhighlight the rest
                        if(i<=chosen)
						{
							document.getElementById('ratingicon_'+i.toString()).src='/ui/images/cart/ratingicon.png';	
						}else{
							document.getElementById('ratingicon_'+i.toString()).src='/ui/images/cart/unchosen_icon.png';		
						}
                    }
                    //set hidden field to this value
                    document.getElementById('rating').value=chosen;
                }
            </script>
        </cfsavecontent>
		
		<cfif structkeyexists(pageref, "addtoheader")>
            <cfset pageref.addtoheader('#jsFunc#')>
		</cfif>
		
		<cfreturn createObject("component", "modules.reviews.forms.review").init(requestObject)>

	</cffunction>

</cfcomponent>