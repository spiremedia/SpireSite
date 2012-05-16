<cfcomponent name="registry" output="false">

	<cffunction name="init" outpout="false">
		<cfset variables.v = structnew()>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="setvar" output="false">
		<cfargument name="name">
		<cfargument name="value">
		
		<cfset variables.v[name] = value>
	</cffunction>
	
	<cffunction name="getvar" output="false">
		<cfargument name="name" required="true">
		<cfargument name="dflt">
				
		<cfif not structkeyexists(variables.v, name)>
			<cfif structkeyexists(arguments, "dflt")>
				<cfreturn arguments.dflt>
			</cfif>
			<cfthrow message="'#name#' not set in request">
		</cfif>
		
		<cfreturn variables.v[name]>
	</cffunction>
	
	<cffunction name="removevar" output="false">
		<cfargument name="name">
			
		<cfset structdelete(variables.v, name)>	
	</cffunction>
	
	<cffunction name="isvarset" outpout="false">
		<cfargument name="name">
		<cfreturn structkeyexists(variables.v, name)>
	</cffunction>
	
	<cffunction name="getAllVars"  output="false">
		<cfreturn variables.v>
	</cffunction>
	
	<cffunction name="dump">
		
		<cfdump var=#variables.v#>
		<cfabort>
	</cffunction>
	
</cfcomponent>