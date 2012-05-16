<cfcomponent name="zip">

	<cffunction name="init">
		<!---<cfargument name="requestObject" required="true">
		<cfset variables.requestObject = arguments.requestObject>--->
		<cfreturn this>
	</cffunction>
	
	<cffunction name="setZipPath">
		<cfargument name="zippath" required="true">
		<cfset variables.zippath = arguments.zippath>
	</cffunction>
    
	<cffunction name="iszipfile">
		<cftry>
			<cfset list()>
		    <cfcatch>
			    <cfdump var=#cfcatch#><cfabort>
			    <cfreturn false>
			</cfcatch>
		</cftry>
		<cfreturn true>
	</cffunction>
	
	<cffunction name="list">
	   	<cfargument name="more" default="#structnew()#">
	   	
	    <cfset var ocoll = structnew()>
		<cfset var alloweables = "filter,recurse,showdirectory">
		<cfset var optionitem = "">
		<cfset var rs = "">
		
		<cfset ocoll.action = "list">
		<cfset ocoll.file = "#variables.zippath#">
		<cfset ocoll.name = "rs">	
		<cfset ocoll.showdirectory = "yes">
				
		<cfloop list="#alloweables#" index="optionitem">
			<cfif structkeyexists(arguments.more, optionitem)>
				<cfset ocoll[optionitem] = arguments.more[optionitem]>
			</cfif>
		</cfloop>
		
    	<cfzip attributecollection = "#ocoll#"/>
	
		<cfreturn rs>
	</cffunction>
	
	<cffunction name="hasfile">
		<cfargument name="internalpath">
		<!--- figure out how to search here --->
		<cfreturn true>
	</cffunction>
	
	<cffunction name="unzip">
		<cfargument name="destination" required="true">
		<cfargument name="more" default="#structnew()#">
		
		<cfset var ocoll = structnew()>
		<cfset var alloweables = "entrypath,filter,overwrite,recurse,storepath">
		<cfset var optionitem = "">
		
		<cfset ocoll.action = "unzip">
		<cfset ocoll.destination = "#arguments.destination#">
		<cfset ocoll.file = "#variables.zippath#">
		<cfset ocoll.overwrite = "yes">	
		
		<cfloop list="#alloweables#" index="optionitem">
			<cfif structkeyexists(arguments.more, optionitem)>
				<cfset ocoll[optionitem] = arguments.more[optionitem]>
			</cfif>
		</cfloop>
		
    	<cfzip attributecollection = "#ocoll#"/>
	</cffunction>
	
	<cffunction name="zip">
		<cfargument name="source" required="true">
		<cfargument name="more" default="#structnew()#">
		
		<cfset var ocoll = structnew()>
		<cfset var alloweables = "filter,overwrite,prefix,recurse,storepath">
		<cfset var optionitem = "">
		
		<cfset ocoll.action = "zip">
		<cfset ocoll.file = "#variables.zippath#">
		<cfset ocoll.source = "#arguments.source#">
		<cfset ocoll.overwrite = "yes">	
		
		<cfloop list="#alloweables#" index="optionitem">
			<cfif structkeyexists(arguments.more, optionitem)>
				<cfset ocoll[optionitem] = arguments.more[optionitem]>
			</cfif>
		</cfloop>
		
    	<cfzip attributecollection = "#ocoll#"/>
	</cffunction>

</cfcomponent>