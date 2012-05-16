<cfoutput>Most recent #getDataItem('reviewsmodulename')# reviews: <br /><br /></cfoutput>

<cfset lcl.search = getDataItem('searchresults')>
<cfset lcl.tbl = createWidget("tablecreator")>
<cfset lcl.tbl.setRequestObj(variables.getDataItem('requestObj'))>
<cfif getDataItem('reviewsmodulename') neq ''>
	<cfset lcl.tbl.addColumn('Item','itemname', 'alpha','<a href="../editReview/?id=[id]&reviewsmodulename=[modulename]">[itemname]</a>')>
<cfelse>
	<cfset lcl.tbl.addColumn('Review Type','modulename', 'alpha','<a href="../editReview/?id=[id]&reviewsmodulename=[modulename]">[modulename]</a>')>
</cfif>
<cfset lcl.tbl.addColumn('Reviewer Name','reviewername', 'alpha')>
<cfset lcl.tbl.addColumn('Rating','rating', 'alpha')>
<cfset lcl.tbl.addColumn('Submitted','created', 'datetime')>
<cfset lcl.tbl.addColumn('Published','active', 'boolean')>
<cfset lcl.tbl.setQuery(lcl.search)>
<cfoutput>#lcl.tbl.showHTML()#</cfoutput>