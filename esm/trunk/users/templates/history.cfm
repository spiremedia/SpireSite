<cfset lcl.tbl = createWidget("tablecreator")>
<cfset lcl.tbl.setRequestObj(variables.getDataItem('requestObject'))>
<cfset lcl.tbl.addColumn('Description','description', 'alpha')>
<cfset lcl.tbl.addColumn('User','fullname', 'alpha')>
<cfset lcl.tbl.addColumn('Date','created', 'datetime')>
<cfset lcl.tbl.addColumn('Module','modulename', 'alpha')>
<cfset lcl.tbl.addColumn('Site Name','name', 'alpha')>
<cfset lcl.tbl.setQuery(variables.getDataItem('itemhistory'))>
<cfoutput>#lcl.tbl.showHTML()#</cfoutput>