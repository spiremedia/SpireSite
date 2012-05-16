<cfcomponent name="factory">
	<cffunction name="init">
		<cfargument name="requestObject" required="true">
		<cfargument name="tablename" required="true">

		<cfset var orm = "">
		<cfset var filename = "">
		<cfset var tableinfo = "">

		<cfset filename = requestObject.getVar("machineroot") & "/cache/orm/" & tablename & ".cfm">
		
		<cfparam name="sqlengine" default="mssql">

		<cfset orm = createObject('component', 'resources.orm.#sqlengine#').init(requestObject)>
		
		<cfif NOT fileexists(filename) OR requestObject.getVar("debug", 0)>
			<cfset tableinfo = createObject('component', 'resources.orm.tablestruct').get(orm, tablename)>
			<cffile action="write" file="#filename#" output="<cfset tableinfo='#SerializeJSON(tableinfo)#'/>">
		<cfelse>
			<cfinclude template="../../cache/orm/#tablename#.cfm">
			<cfset tableinfo = DeserializeJson(tableinfo)>
		</cfif>
	
		<cfset orm.setTableData(tableinfo)>
	
		<cfreturn orm>
	</cffunction>
</cfcomponent>