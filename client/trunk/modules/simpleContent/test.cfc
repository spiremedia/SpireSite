<cfcomponent displayname="MyCFCTest" extends="mxunit.framework.TestCase">
		
	<cffunction name="setUp" returntype="void" access="public">
		<cfset variables.requestObject = request.requestObject>         
	</cffunction>
    
	<!-- used in both loadController & testinout (PhilS) -->
	<cfset variables.title = "test">
	<cfset variables.str = "hello">
	
    <cffunction name="loadController" access="private">
    	<cfargument name="str">
        <cfset var data = structnew()>
        <cfset data.content = arguments.str>
    	<cfset variables.controller = createObject("component","modules.simplecontent.controller").init(
			title=#variables.title#,
			data=data,
			requestObject=variables.requestObject,
			pageRef = "hi",
			name = "default"
		)>
    </cffunction>
    
    <cffunction name="teardown" returntype="void" access="public">
	
	</cffunction>
	
    <cffunction name="testinout">
        <cfset var out = "">
    	<cfset loadController(str)>
		<cfset out = variables.controller.showHTML()>
        <cfset assertequals(expected="{html={#variables.str#},title={#variables.title#}}",actual=out)>
    </cffunction>
       
</cfcomponent>