<cfcomponent name="asset model" output="false" extends="resources.abstractmodel">

	<cffunction name="init">
		<cfargument name="requestObj" required="true">
		<cfargument name="userobj" required="true">
		
		<cfset variables.requestObj = arguments.requestObj>
		<cfset variables.userobj = arguments.userobj>
		<cfset variables.itemdata = structnew()>
		
		<cfset setTableMetaData('{	
			"tableName":"assets",
			"fields":{
				"name":{"type":"varchar","maxlen":50,"validation":"notblank,maxlength","label":"Name"},
				"filename":{"type":"varchar","maxlen":100,"validation":"notblank,maxlength","label":"File Name"},
				"previewfilename":{"type":"varchar","maxlen":100,"label":"Preview File Name"},
				"description":{"type":"varchar","maxlen":255,"validation":"maxlength","label":"Description"},
				"assetgroupid":{"type":"varchar","validation":"notblank","label":"Asset Group Id"},
				"filesize":{"type":"integer","label":"File Size"},
				"active":{"type":"bit","default":1},
				"changedby":{"type":"varchar","maxlen":35},
				"deleted":{"type":"bit","default":0},
				"startdate":{"type":"date"},
				"enddate":{"type":"date"},
				"created":{"type":"date"},
				"modified":{"type":"date"}
			},
			"belongsTo":{"assets.assetGroups":{}}
		}')>
		<cfset variables.assetdirectoryname = "assets">
		<cfset variables.assetdirectorypath = variables.requestObj.getVar("machineroot") &  'docs/' & assetdirectoryname & '/'>
		<cfreturn this>
	</cffunction>
	<!---
	<cffunction name="getAssets" output="false">
		<cfset var sg = "">
	
		<!--- disabled for easy --->
		<!---<cfif 1 EQ 1 OR  variables.userobj.issuper()>--->
			<!--- superuser can see all assets in all asset groups --->
			<cfquery name="sg" datasource="#variables.requestObj.getvar('dsn')#">
				SELECT 
					assetid AS id, assetname AS name, filename, description, previewfilename, changeddate, changedby, active, startdate, enddate, assetgroupname
				FROM assetsInAssetGroup_join
				ORDER BY assetgroupname, name
			</cfquery>
		<!---<cfelse>
			<!--- user can see only assets in asset groups in their content groups --->
			<cfquery name="sg" datasource="#variables.request.getvar('dsn')#">
				SELECT 
					assetid AS id, assetname AS name, filename, description, previewfilename, changeddate, changedby, active, startdate, enddate, assetgroupname
				FROM assetsInContentGroupUsers_join
				WHERE userid = <cfqueryparam value="#variables.userObj.getUserId()#" cfsqltype="cf_sql_varchar"> 
				ORDER BY assetgroupname, name
			</cfquery>
		</cfif>--->
		
		<cfreturn sg/>
	</cffunction>
	--->
	<cffunction name="getClientModuleAssets" output="false">
		<cfset var sg = "">
	
		<!---<cfif variables.userobj.issuper()>--->
			<!--- superuser can see all assets in all asset groups --->
			<cfquery name="sg" datasource="#variables.requestObj.getvar('dsn')#">
				SELECT 
					assetgroupname,
					assetgroupid,
					assetid AS id, 
					assetname <!---+ ' (in ' + assetgroupname + ')'---> AS name
				FROM assetsInAssetGroup_join
				WHERE filename IS NOT NULL
				ORDER BY assetgroupname, name
			</cfquery>
		<!---<cfelse>
			<!--- user can see only assets in asset groups in their content groups --->
			<cfquery name="sg" datasource="#variables.requestObj.getvar('dsn')#">
				SELECT 
					assetid AS id, assetname + ' (in ' + assetgroupname + ')' AS name
				FROM assetsInContentGroupUsers_join
				WHERE userid = <cfqueryparam value="#variables.userObj.getUserId()#" cfsqltype="cf_sql_varchar"> 
				ORDER BY assetgroupname, name
			</cfquery>
		</cfif>--->
		
		<cfreturn sg/>
	</cffunction>
	
	<cffunction name="presave">
		<cfset variables.itemdata.changedby = variables.userObj.getUserId()>
		<cfset variables.itemdata.changeddate = now()>
	</cffunction>
	
	<cffunction name="validateDelete">
		
		<cfset var me = "">		
		<cfset var vdtr = this.getValidator()>
		
		<!--- verify the asset is not included on a page --->		
		<cfquery name="me" datasource="#variables.requestObj.getvar('dsn')#" result="m">
			SELECT DISTINCT spv.pagename 
			FROM pageObjects_view pov, sitepages_view spv
			WHERE (pov.module = 'Assets' OR pov.module = 'HTMLContent')
			AND spv.id = pov.pageid
			AND pov.data like <cfqueryparam value="%#this.getId()#%" cfsqltype="cf_sql_varchar">
		</cfquery>

		<cfif me.recordcount>
			<cfset vdtr.addError('assetgroupid', 'This asset is included on page "#me.pagename#". Please remove it from there before deleting the asset.')>
		</cfif>

	</cffunction>
	

	<cffunction name="search" output="false">
		<cfargument name="criteria" required="true">
		<cfset var sg = "">
		
		<cfset variables.observeEvent('search', this)>
	
		<!--- <cfif variables.userobj.issuper()> --->
			<!--- superuser can see all assets in all asset groups --->
			<cfquery name="sg" datasource="#variables.requestObj.getvar('dsn')#">
				SELECT 
					assetid AS id, assetname AS name, fullname, changeddate, assetgroupname
				FROM assetsInAssetGroup_join
				WHERE 
					(assetname LIKE <cfqueryparam value="%#arguments.criteria#%" cfsqltype="cf_sql_varchar"> 
                    	OR description LIKE <cfqueryparam value="%#arguments.criteria#%" cfsqltype="cf_sql_varchar"> 
						OR assetgroupname LIKE <cfqueryparam value="%#arguments.criteria#%" cfsqltype="cf_sql_varchar">)
				ORDER BY assetgroupname, name
			</cfquery>
		<!--- <cfelse>
			<!--- user can see only assets in asset groups in their content groups --->
			<cfquery name="sg" datasource="#variables.requestObj.getvar('dsn')#">
				SELECT 
					assetid AS id, assetname AS name, fullname, changeddate, assetgroupname
				FROM assetsInContentGroupUsers_join
				WHERE userid = <cfqueryparam value="#variables.userObj.getUserId()#" cfsqltype="cf_sql_varchar"> 
				AND
					(assetname LIKE <cfqueryparam value="%#arguments.criteria#%" cfsqltype="cf_sql_varchar"> 
                    	OR description LIKE <cfqueryparam value="%#arguments.criteria#%" cfsqltype="cf_sql_varchar"> 
						OR assetgroupname LIKE <cfqueryparam value="%#arguments.criteria#%" cfsqltype="cf_sql_varchar">)
				ORDER BY assetgroupname, name
			</cfquery>
		</cfif> --->
		
		<cfreturn sg>

	</cffunction>
	
	<cffunction name="getAllAvailableImages" output="false">
		<cfset var sg = "">
		<cfquery name="sg" datasource="#variables.requestObj.getvar('dsn')#">
			SELECT a.id, a.name, a.filesize, a.filename,
				ag.id assetGroup_id, ag.name assetGroup_name
			FROM assets a
			INNER JOIN assetGroups ag ON a.assetgroupid = ag.id AND ag.deleted = 0
			WHERE a.deleted = 0
			AND
				filename LIKE '%jpg'
				OR filename LIKE '%gif'
				OR filename LIKE '%png'
			ORDER BY ag.name, a.name
		</cfquery>
		<cfreturn sg>
	</cffunction>
	
	<cffunction name="uploadAssetFileInfo" output="false">
		<cfargument name="info" required="true">
		<cfset var grp = "">
		<cfset var mainfilesize = "">
		<cfset var mainfile = ''>
		<cfset var previewfile = ''>
		<cfset var qryFile = "">
		<cfset var filetodelete = "">
		
		<cfset var uploaddirectory = variables.assetdirectorypath & info.id>
		<cfif info.filename NEQ ''>
			<cfif this.getfilename() NEQ "">
				<cfset filetodelete = "#uploaddirectory#/#variables.itemdata.filename#">
				<cfif fileexists(filetodelete)>
					<cffile action="delete" file="#filetodelete#">
				</cfif>
			</cfif>
			
			<cfif NOT directoryexists(uploaddirectory)>
				<cfdirectory action="create" directory="#uploaddirectory#" mode="664">
			</cfif>
			
			<cfset mainfile = createObject('component','utilities.fileuploadandsave').init(target = '#variables.assetdirectoryname#/#info.id#', sitepath = variables.requestObj.getVar('machineroot'), file = info.filename, alloweableExtensions="*")>
			
			<cfif NOT mainfile.success()>
				<cfoutput>File not uploaded. #mainfile.reason()#.</cfoutput> <cfabort>
			</cfif>
			
			<cfset variables.itemdata.filename = mainfile.savedName()>
			<cfset variables.itemdata.filesize = mainfile.filesize()>
			
			<cfif NOT this.save()>
				<cfdump var=#vdtr.getErrors()#><cfabort>
			</cfif>
			<cfset variables.observeEvent('uploaded asset', this)>
		</cfif>
			
		<cfreturn variables.itemdata.filename>
	</cffunction>

</cfcomponent>
	