<cfcomponent name="video gallery item model" output="false" extends="resources.abstractmodel">

	<cffunction name="init">
		<cfargument name="requestObj" required="true">
		<cfargument name="userobj" required="true">
		
		<cfset variables.requestObj = arguments.requestObj>
		<cfset variables.userObj = arguments.userObj>
			
		<cfset setTableMetaData('{	
			"tableName":"videos",
			"fields":{
				"name":{"type":"varchar","maxlen":50,"validation":"notblank,maxlength","label":"Name"},
				"title":{"type":"varchar","maxlen":255,"validation":"notblank,maxlength","label":"Title"},
				"description":{"type":"varchar","maxlen":500,"validation":"notblank,maxlength","label":"Description"},
				"videofilename":{"type":"varchar","maxlen":100},
				"thmbfilename":{"type":"varchar","maxlen":100},
				"vidlength":{"type":"varchar","maxlen":50,"validation":"notblank,maxlength"},
				"changedby":{"type":"varchar","maxlen":35},
				"deleted":{"type":"bit","default":0},
				"created":{"type":"date"},
				"modified":{"type":"date"}
			},
			"habtm":{"videos.videogroups":{}}
		}')>
		
		<cfset variables.directoryname = "videos">
		<cfset variables.directorypath = variables.requestObj.getVar("machineroot") &  'docs/' & directoryname & '/'>
				
		<cfreturn this>
	</cffunction>
	
	<cffunction name="uploadImageFileInfo" output="false">
		<cfargument name="info" required="true">
		<cfset var lcl = structNew()>
		<cfset var mainfile = ''>
		<cfset var uploaddirectory = variables.directorypath & info.id>
		<cfset lcl.success = 0>
		<cfset lcl.reason = "File not uploaded.">
		
		<cfif requestObj.isFormUrlVarSet(info.filename) AND len(trim(requestObj.getFormUrlVar(info.filename)))>
				
			<cfif NOT directoryexists(uploaddirectory)>
				<cfdirectory action="create" directory="#uploaddirectory#" mode="664">
			</cfif>
			
			<cfset lcl.params = structNew()>
			<cfset StructInsert(lcl.params, 'target', '#variables.directoryname#/#info.id#')>
			<cfset StructInsert(lcl.params, 'sitepath', variables.requestObj.getVar('machineroot'))>
			<cfset StructInsert(lcl.params, 'file', info.filename)>
			<cfif structkeyexists(info, 'alloweableExtensions')>
				<cfset StructInsert(lcl.params, 'alloweableExtensions', info.alloweableExtensions)>
			</cfif>
			<cfif structkeyexists(variables.itemdata, info.filename)>
				<cfset StructInsert(lcl.params, 'filetodelete', variables.itemdata[info.filename])>
			</cfif>

			<cfset mainfile = createObject('component','utilities.fileuploadandsave').init(argumentCollection = lcl.params)>

			<cfif NOT mainfile.success()>
				<cfset lcl.reason = "File not uploaded. #mainfile.reason()#">
				<cfreturn lcl>
			</cfif>
			
			<cfset variables.itemdata[info.filename] = mainfile.savedName()>
	
			<cfset this.save()>
			<cfset variables.observeEvent('upload #info.filename#', this)>
			<cfset lcl.success = 1>
		</cfif>
		<cfreturn lcl>
	</cffunction>
	
	<cffunction name="resizeImage" output="false">
		<cfargument name="info" required="true">
		<cfargument name="maxwidth" required="true">
		<cfargument name="maxheight" required="true">
		<cfargument name="imgmanipulation" required="true">

		<cfset var filename = variables.directorypath & variables.itemdata.id & "/" & variables.itemdata[info.filename]>
	
		<cfif NOT fileexists(filename)>
			<cfthrow message="Image not found to resize ""#filename#""">
		</cfif>

		<cfset imgmanipulation.resizetomax(filename, maxwidth, maxheight, filename)>
		
	</cffunction>
	
	<cffunction name="validateDelete" output="false">
		
		<cfset var me = "">			
		<cfset var vdtr = this.getValidator()>
		
		<!--- verify the Image group does not have children Images --->	
		<cfquery name="me" datasource="#variables.requestObj.getvar('dsn')#">
			SELECT DISTINCT g.name 
			FROM videostovideogroups v2g, videogroups g
			WHERE v2g.videogroupid = g.id
			AND v2g.videoid = <cfqueryparam value="#this.getId()#" cfsqltype="cf_sql_varchar">
			AND g.deleted = 0
		</cfquery>
		
		<cfif me.recordcount>
			<cfset vdtr.addError('id', 'This video belongs to video group "#me.name#". Please remove it from there first.')>
		</cfif>
	
	</cffunction>
	
	
</cfcomponent>
	