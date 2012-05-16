<cfcomponent displayname="assetTest" extends="mxunit.framework.TestCase">
	
	<cffunction name="setup">
		<cfset variables.httpObj = createObject('component','login.logintest').getLoggedInSAUser()>
	</cffunction>
	
    <cffunction name="InterfaceTest">
		<cfset var l = structnew()>
		<cfset var response = "">
				
		<cfset variables.httpObj.setPath('/assets/tinymceUpload/')>
	
		<cfset response = variables.httpObj.load()>
		
		<cfset assertfalse(condition=(response.is302relocate()),message="sa logged in but can't see uploader")>
		<cfset asserttrue(condition=(response.getStatus() EQ '200'),message="error while viewing uploader")>
		
	</cffunction>
	
</cfcomponent>		