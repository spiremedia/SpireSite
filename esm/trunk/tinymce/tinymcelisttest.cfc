<cfcomponent displayname="assetTest" extends="mxunit.framework.TestCase">
	
	<cffunction name="setup">
		<cfset variables.httpObj = createObject('component','login.logintest').getLoggedInSAUser()>
	</cffunction>
	
    <cffunction name="InterfaceTest">
		<cfset var l = structnew()>
		<cfset var response = "">
				
		<cfset variables.httpObj.setPath('/tinymce/showJSPageList/')>
	
		<cfset response = variables.httpObj.load()>
		
		<cfset assertfalse(condition=(response.is302relocate()),message="sa logged in but can't see js page list")>
		<cfset asserttrue(condition=(response.getStatus() EQ '200'),message="error while viewing js page list")>
		
		<cfset variables.httpObj.setPath('/tinymce/showJSImageList/')>
	
		<cfset response = variables.httpObj.load()>
		
		<cfset assertfalse(condition=(response.is302relocate()),message="sa logged in but can't see js page list")>
		<cfset asserttrue(condition=(response.getStatus() EQ '200'),message="error while viewing js page list")>
	</cffunction>
	
</cfcomponent>
		