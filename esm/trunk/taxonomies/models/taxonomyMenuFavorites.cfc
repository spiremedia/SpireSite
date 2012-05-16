<cfcomponent name="taxonomyMenuFavorites Model" output="false" extends="resources.abstractmodel">

	<cffunction name="init">
		<cfargument name="requestObj" required="true">
		<cfargument name="userObj" required="true">
		<cfset variables.requestObj = arguments.requestObj>
		<cfset variables.userObj = arguments.userObj>
		<cfset setTableMetaData('{
	
	"FIELDS":{
		"modified":{"LABEL":"Modified","TYPE":"date"},
		"taxonomyMenuItemId":{"VALIDATION":"maxlength,notblank","LABEL":"Taxonomy Menu Item Id","MAXLEN":35,"TYPE":"varchar"},
		"created":{"LABEL":"Created","TYPE":"date"},
		"taxonomyItemId":{"VALIDATION":"maxlength,notblank","LABEL":"Taxonomy Item Id","MAXLEN":35,"TYPE":"varchar"},
		"changedby":{"VALIDATION":"maxlength,notblank","LABEL":"Changedby","MAXLEN":35,"TYPE":"varchar"}},"TABLENAME":"taxonomyMenuFavorites"}')>
		<cfreturn this>
	</cffunction>
	
</cfcomponent>
