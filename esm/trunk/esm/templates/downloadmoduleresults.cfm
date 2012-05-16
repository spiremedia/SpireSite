<cfset lcl.results = getDataItem("results")>
<cfset lcl.module = getDataItem("module")>
<cfoutput>
	#lcl.results#
	<p>#lcl.module.notes#</p>
	<p><a href="/unittest.cfm?refresh">Unit Test?</a></p>
</cfoutput>