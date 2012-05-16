<cfset lcl.assetsearch = getDataItem('searchresults')>
<cfset lcl.tbl = createWidget("tablecreator")>
<cfset lcl.tbl.setRequestObj(variables.getDataItem('requestObj'))>
<cfset lcl.tbl.addColumn('Asset Name','name', 'alpha','<a href="/assets/editAsset/?id=[id]">[name]</a>')>
<cfset lcl.tbl.addColumn('Asset Group Name','assetgroups_name', 'alpha')>
<cfset lcl.tbl.addColumn('User','fullname', 'alpha')>
<cfset lcl.tbl.addColumn('Changed Date','modified', 'datetime')>
<cfset lcl.tbl.setQuery(lcl.assetsearch)>
<cfoutput>#lcl.tbl.showHTML()#</cfoutput>
