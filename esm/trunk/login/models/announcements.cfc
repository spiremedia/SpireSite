<cfcomponent name="announcement model" output="false" extends="resources.abstractmodel">
	<cffunction name="init">
		<cfargument name="requestObj" required="true">
		<cfargument name="userobj" required="true">
		
		<cfset variables.requestObj = arguments.requestObj>
		<cfset variables.userobj = arguments.userobj>
		<cfset variables.itemdata = structnew()>
		
		<cfset setTableMetaData('{	
			"tableName":"announcements",
			"fields":{
				"name":{"type":"varchar","maxlen":200,"validation":"notblank,maxlength","label":"Title"},
				"htmlText":{"type":"longvarchar","label":"Announcement"},
				"active":{"type":"bit","default":1},
				"changedby":{"type":"varchar","maxlen":35},
				"itemdate":{"type":"date","validation":"notblank,isvaliddate","label":"Display Date"},
				"created":{"type":"date"},
				"modified":{"type":"date"},
				"siteid":{"type":"varchar","maxlen":35}
				}
			}')>
		<cfreturn this>
	</cffunction>

</cfcomponent>
	