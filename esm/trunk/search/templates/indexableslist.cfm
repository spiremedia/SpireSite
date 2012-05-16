<cfif variables.isDataItemSet('searchresults')>
	<cfset lcl.tbl = createWidget("tablecreator")>
	<cfset lcl.tbl.setRequestObj(requestObj)>
	<cfset lcl.tbl.addColumn('Title','Title', 'alpha','<a href="../viewIndexable/?id=[id]">[title]</a>')>
	<cfset lcl.tbl.addColumn('Created','created', 'datetime')>
	<cfset lcl.tbl.addColumn('Last Indexed','lastindexed', 'datetime')>
	<cfset lcl.tbl.addColumn('Has Error','hasError', 'alpha')>
	<!---><cfset lcl.tbl.addColumn('Modified','modified', 'date')>--->
	<cfset lcl.tbl.setQuery(getDataItem('searchresults'))>
	<cfoutput>#lcl.tbl.showHTML()#</cfoutput>
</cfif>