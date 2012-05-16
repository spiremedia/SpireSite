<cfif variables.isDataItemSet('searchResults')>
	<cfset lcl.results = getDataItem('searchResults')>
	<cfset lcl.tbl = createWidget("tablecreator")>
	<cfset lcl.tbl.setRequestObj(requestObj)>
	<cfset lcl.tbl.addColumn('Name','name', 'alpha','<a href="/messaging/editMessaging/?id=[id]">[name]</a>')>
	<cfset lcl.tbl.addColumn('Modified','modified', 'date')>
	<cfset lcl.tbl.setQuery(lcl.results)>
	<cfoutput>#lcl.tbl.showHTML()#</cfoutput>
</cfif>
