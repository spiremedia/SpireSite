<cfcomponent name="textlogger">
	<!--- this module writes text files to the folder /tmp/ in the format [type][datetimestamp][guid].log --->
	<cffunction name="init">
		<cfargument name="requestObject" required="true">
    	<cfset variables.requestObject = arguments.requestObject>
    	<cfreturn this>
    </cffunction>
    
    <cffunction name="log">
    	<cfargument name="type" required="true">
		<cfargument name="message" required="true">
		<cfset var lcl = structnew()>
		<cfset lcl.filename = 	arguments.type & 
								dateformat(now(), "yyyymmdd") & 
								'-' & 
								timeformat(now(), "hhmmss") & 
								'-' & 
								createuuid() & 
								".log">
		<cfset lcl.filename = requestObject.getVar('machineroot') & '/tmp/' & lcl.filename>
		
		<cffile action="write" file="#lcl.filename#" output="#message#">
		
		<cfreturn true>
    </cffunction>

</cfcomponent>