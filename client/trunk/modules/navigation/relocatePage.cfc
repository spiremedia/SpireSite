<cfcomponent name="relocation for no js" extends="resources.page">
	<cffunction name="preObjectLoad">
		<cfif requestObject.isFormUrlVarSet("loc")>
			<cflocation url="#requestObject.getFormUrlVar("loc")#" addtoken="false">
		<cfelse>
			<cflocation url="/404/?blanknavrelocation" addtoken="false">
		</cfif>
	</cffunction>
</cfcomponent>