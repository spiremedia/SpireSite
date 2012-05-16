<cfset lcl.assetsearch = getDataItem('searchresults')>
<cfset lcl.tbl = createWidget("tablecreator")>
<cfset lcl.tbl.setRequestObj(variables.getDataItem('requestObj'))>
<cfset lcl.tbl.addColumn('Video Name','name', 'alpha','<a href="../EditVideo/?id=[id]">[name]</a>')>
<!--- <cfset lcl.tbl.addColumn('Video Group Name','videogroupname', 'alpha','[videogroups_name]')> --->
<cfset lcl.tbl.addColumn('User','fullname', 'alpha')>
<cfset lcl.tbl.addColumn('Changed Date','modified', 'datetime')>
<cfset lcl.tbl.setQuery(lcl.assetsearch)>
<cfoutput>#lcl.tbl.showHTML()#</cfoutput>
