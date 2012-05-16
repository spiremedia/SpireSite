<cfset lcl.search = getDataItem('searchresults')>
<cfset lcl.tbl = createWidget("tablecreator")>
<cfset lcl.tbl.setRequestObj(variables.getDataItem('requestObject'))>
<cfset lcl.tbl.addColumn('Event Name','name', 'alpha','<a href="/events/editEvent/?id=[id]">[name]</a>')>
<cfset lcl.tbl.addColumn('Title','title', 'alpha')> 
<cfset lcl.tbl.addColumn('Start Date','startdate', 'datetime')>
<cfset lcl.tbl.addColumn('End Date','enddate', 'datetime')>
<cfset lcl.tbl.setQuery(lcl.search)>
<cfoutput>#lcl.tbl.showHTML()#</cfoutput>
