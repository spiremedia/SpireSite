<cfoutput>
<p>A list of available modules to download.</p>
<cfset lcl.modules = getDataItem("modulesavailable")>

<cfloop query="lcl.modules">
<p>
<b>#title#</b>
<cfif directoryexists(requestObj.getVar("machineroot") & '/' & listlast(rsslink,"="))>
	Already installed.
<cfelse>
	<a href="../InstallDownloadableModule/?moduletoinstall=#listlast(rsslink,"=")#">Install Now</a>
</cfif>
<br>
#content#
</p>
</cfloop>
</cfoutput>