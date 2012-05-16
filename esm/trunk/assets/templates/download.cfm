<cfset lcl.info = getDataItem('Info')>
<cfset lcl.link = getDataItem('link')>
<cfif right(lcl.link, 1) EQ "/">
	<p>No file has been uploaded</p>
<cfelse>
<cfoutput>
	<p><a href="#lcl.link#" target="_blank">#lcl.info.getName()#</a></p>
</cfoutput>
</cfif>