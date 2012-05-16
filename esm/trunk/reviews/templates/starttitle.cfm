<cfset lcl.reviewsmodulename = ''>
<cfif isDataItemSet('reviewsmodulename')>
	<cfset lcl.reviewsmodulename = getDataItem('reviewsmodulename')>
</cfif>
<cfoutput>Welcome to the #lcl.reviewsmodulename# reviews area</cfoutput>