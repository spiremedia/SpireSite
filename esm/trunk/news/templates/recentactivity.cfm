<cfset lcl.tbl = createWidget("tablecreator")>
<cfset lcl.tbl.setRequestObj(variables.getDataItem('requestObj'))>
<cfset lcl.tbl.addColumn('Description','description', 'alpha')>
<cfset lcl.tbl.addColumn('User','fullname', 'alpha')>
<cfset lcl.tbl.addColumn('Date','created', 'datetime')>
<cfset lcl.tbl.setQuery(variables.getDataItem('recentactivity'))>
<cfoutput>#lcl.tbl.showHTML()#</cfoutput>