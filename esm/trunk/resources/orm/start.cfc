<cfcomponent name="factory">
	<cffunction name="init">
		<cfargument name="requestObj" required="true">
		<cfargument name="userObj" required="true">
		<cfparam name="sqlengine" default="mssql">
		<cfreturn createObject('component', 'resources.orm.#sqlengine#').init(requestObj, userObj)>
	</cffunction>
</cfcomponent>