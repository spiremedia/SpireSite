<cfcomponent name="product search view" extends="resources.abstractSearchResultView">
	<cffunction name="showhtml">
		<cfset var lcl = structnew()>
		<cfoutput>		
		<cfsavecontent variable="lcl.html">
		<div class="page-search-result">
			<h4><a href="/#variables.data.key#">#variables.data.title#</a></h4>
			<div class="details">
				#variables.data.description#
			</div><!--- end details --->
		</div><!--- end pss --->
		</cfsavecontent>
		</cfoutput>
		<cfreturn lcl.html>
	</cffunction>
</cfcomponent>