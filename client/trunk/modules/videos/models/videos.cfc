<cfcomponent name="Videos model" extends="resources.abstractModel">
	
	<cffunction name="init">
		<cfargument name="requestObject">
		<cfset variables.requestObject = arguments.requestObject>
		<!--- <cfset this.startOrm("videos")> --->
		<cfreturn this>
	</cffunction>
	
	<cffunction name="getGroupVideos">
		<cfargument name="id" required="true">
		<cfset var q = "">
		<cfquery name="q" datasource="#requestObject.getVar("dsn")#">
			SELECT videos.id, thmbfilename, title, description, videofilename, vidlength
			FROM videos
			INNER JOIN videostovideogroups v2vg ON (videos.id = v2vg.videoid AND v2vg.videogroupid = <cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_varchar">)
			WHERE videos.deleted = 0
			ORDER BY sortkey
		</cfquery>
		<cfreturn q>
	</cffunction>
	
</cfcomponent>