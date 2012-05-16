<cfset lcl.history = variables.getDataItem('history')>
<cfset lcl.tbl = createWidget("tablecreator")>
<cfset lcl.tbl.setRequestObj(requestObj)>
<cfset lcl.tbl.addColumn('Description','description', 'alpha')>
<cfset lcl.tbl.addColumn('User','fullname', 'alpha')>
<cfset lcl.tbl.addColumn('Date','actiondate', 'datetime')>
<cfset lcl.tbl.setQuery(lcl.history)>
<cfoutput>#lcl.tbl.showHTML()#</cfoutput>
