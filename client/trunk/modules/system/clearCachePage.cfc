<cfcomponent name="stateMgr" extends="resources.page">
	<cffunction name="preObjectLoad">
		<cfset var lcl = structnew()>
		<cfset lcl.cnt = 0>
		<cfdirectory action="list" name="lcl.cfiles" directory="#requestObject.getVar("machineroot")#/cache/pages">
		
		<cfloop query="lcl.cfiles">
			<cfset lcl.file = "#lcl.cfiles.directory#/#lcl.cfiles.name#">
			<cfif fileexists(lcl.file)>
				<cffile action="delete" file="#lcl.file#">
				<cfset lcl.cnt = lcl.cnt + 1>
			</cfif>
		</cfloop>
		
		<cfoutput>Deleted #lcl.cnt#</cfoutput>
		
		<cfabort>
	</cffunction>
</cfcomponent>