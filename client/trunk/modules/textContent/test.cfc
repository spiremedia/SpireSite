<cfcomponent displayname="MyCFCTest" extends="mxunit.framework.TestCase">
		
	<cffunction name="setUp" returntype="void" access="public">
		<cfset variables.requestObject = request.requestObject>         
	</cffunction>
    
    <cffunction name="loadController" access="private">
    	<cfargument name="str">
        <cfset var data = structnew()>
        <cfset data.content = arguments.str>
    	<cfset variables.controller = createObject("component","modules.textcontent.controller").init(
			title="test title",
			data=data,
			requestObject=variables.requestObject,
			pageRef = "hi",
			name = "default"
		)>
    </cffunction>
    
    <cffunction name="teardown" returntype="void" access="public">
	
	</cffunction>
	
    <cffunction name="testinout">
    	<cfset var str = "hello">
        <cfset var out = "">
    	<cfset loadController(str)>
		<cfset out = variables.controller.showHTML()>
>
		<!--- Tina - changed 'out' to 'out.HTML' --->
        <cfset assertequals(expected=str,actual=out.HTML)>
    </cffunction>
       
</cfcomponent>