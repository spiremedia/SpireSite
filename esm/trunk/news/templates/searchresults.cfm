
	<cfset lcl.assetsearch = getDataItem('searchresults')>
	<cfset lcl.tbl = createWidget("tablecreator")>
	<cfset lcl.tbl.setRequestObj(variables.getDataItem('requestObj'))>
	<cfset lcl.tbl.addColumn('News Name','name', 'alpha','<a href="../editNews/?id=[id]">[name]</a>')>
	<cfset lcl.tbl.addColumn('Title','title', 'alpha')>
	<cfset lcl.tbl.addColumn('Show Date','startdate', 'datetime')>
	<cfset lcl.tbl.addColumn('Hide Date','enddate', 'datetime')>
	<cfset lcl.tbl.setQuery(lcl.assetsearch)>
	<cfoutput>#lcl.tbl.showHTML()#</cfoutput>
