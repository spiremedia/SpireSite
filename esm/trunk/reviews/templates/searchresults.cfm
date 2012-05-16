<cfset lcl.search = getDataItem('searchresults')>
<cfset lcl.tbl = createWidget("tablecreator")>
<cfset lcl.tbl.setRequestObj(variables.getDataItem('requestObj'))>
<cfset lcl.tbl.addColumn('Item','itemname', 'alpha','<a href="../editReview/?id=[id]&reviewsmodulename=[modulename]">[itemname]</a>')>
<cfset lcl.tbl.addColumn('Reviewer Name','reviewername', 'alpha')>
<cfset lcl.tbl.addColumn('Submitted','created', 'datetime')>
<cfset lcl.tbl.addColumn('Published','active', 'boolean')>
<cfset lcl.tbl.setQuery(lcl.search)>
<cfoutput>#lcl.tbl.showHTML()#</cfoutput>
