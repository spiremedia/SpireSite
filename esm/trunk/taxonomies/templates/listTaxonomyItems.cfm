<cfset lcl.list = variables.getDataItem('taxonomylist')>
<cfset lcl.tbl = createWidget("tablecreator")>
<cfset lcl.tbl.setRequestObj(requestObj)>
<cfset lcl.tbl.addColumn('Name','name', 'alpha','<a href="/taxonomies/editTaxonomyitem/?taxid=#requestObj.getFormUrlVar('id')#&id=[id]">[name]</a>')>
<cfset lcl.tbl.addColumn('User','fullname', 'alpha')>
<cfset lcl.tbl.addColumn('Date','created', 'datetime')>
<cfset lcl.tbl.setQuery(lcl.list)>
<cfoutput>#lcl.tbl.showHTML()#</cfoutput>
