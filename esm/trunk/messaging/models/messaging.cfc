<cfcomponent name="messaging Model" output="false" extends="resources.abstractmodel">

	<cffunction name="init">
		<cfargument name="requestObj" required="true">
		<cfargument name="userObj" required="true">
		<cfset variables.requestObj = arguments.requestObj>
		<cfset variables.userObj = arguments.userObj>
		<cfset setTableMetaData('{
			"FIELDS":{
				"subject":{"VALIDATION":"maxlength,notblank","LABEL":"Subject","MAXLEN":100,"TYPE":"varchar"},
				"modified":{"LABEL":"Modified","TYPE":"date"},
				"name":{"VALIDATION":"maxlength,notblank","LABEL":"Name","MAXLEN":50,"TYPE":"varchar"},
				"textcontent":{"VALIDATION":"maxlength,notblank","LABEL":"Textcontent","MAXLEN":8000,"TYPE":"varchar"},
				"moduleowner":{"VALIDATION":"maxlength,notblank","LABEL":"Moduleowner","MAXLEN":50,"TYPE":"varchar"},
				"created":{"LABEL":"Created","TYPE":"date"},
				"changedby":{"VALIDATION":"maxlength,notblank","LABEL":"Changedby","MAXLEN":35,"TYPE":"varchar"}},"TABLENAME":"messaging"}')>
		<cfreturn this>
	</cffunction>
	
</cfcomponent>
