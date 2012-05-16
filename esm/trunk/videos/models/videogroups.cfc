<cfcomponent name="Video Groups" output="false" extends="resources.abstractmodel">

	<cffunction name="init">
		<cfargument name="requestObj" required="true">
		<cfargument name="userobj" required="true">
		<cfset variables.requestObj = arguments.requestObj>
		<cfset variables.userobj = arguments.userobj>
		
		<cfset setTableMetaData('{	
			"tableName":"videoGroups",
			"fields":{
				"name":{"type":"varchar","maxlen":50,"validation":"notblank,maxlength","label":"Name"},
				"title":{"type":"varchar","maxlen":255,"validation":"notblank,maxlength","label":"Title"},
				"description":{"type":"varchar","maxlen":500,"validation":"notblank,maxlength","label":"Description"},
				"changedby":{"type":"varchar","maxlen":35},
				"deleted":{"type":"bit","default":0},
				"created":{"type":"date"},
				"modified":{"type":"date"}
			},
			"habtm":{"videos.videos":{}}
		}')>
		
		<cfreturn this>
	</cffunction>
	
	<cffunction name="validateDelete">
		
		<cfset var me = "">		
		<cfset var vdtr = this.getValidator()>
		
		<!--- verify the asset is not included on a page --->		
		<cfquery name="me" datasource="#variables.requestObj.getvar('dsn')#" result="m">
			SELECT DISTINCT spv.pagename 
			FROM pageObjects_view pov, sitepages_view spv
			WHERE pov.module = 'Videos'
			AND spv.id = pov.pageid
			AND pov.data like <cfqueryparam value="%#this.getId()#%" cfsqltype="cf_sql_varchar">
		</cfquery>

		<cfif me.recordcount>
			<cfset vdtr.addError('assetgroupid', 'This video group is embedded on page "#me.pagename#". Please remove it from there before deleting.')>
		</cfif>

	</cffunction>

</cfcomponent>
	