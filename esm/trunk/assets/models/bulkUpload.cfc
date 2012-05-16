<cfcomponent name="asset model" output="false" extends="resources.abstractmodel">

	<cffunction name="init">
		<cfargument name="requestObj" required="true">
		<cfargument name="userobj" required="true">
		
		<cfset variables.requestObj = arguments.requestObj>
		<cfset variables.userobj = arguments.userobj>
		
		<cfset variables.zipObj = createObject("component", "utilities.zip").init()>
		
		<cfset variables.directorypath = variables.requestObj.getVar("machineroot") &  'docs/assetsbulkuploadwork/'>
		<cfset variables.assetsdirectorypath = variables.requestObj.getVar("machineroot") &  'docs/assets/'>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="setFileName">
		<cfargument name="fn" required="true">
		<cfset variables.zipObj.setZipPath(variables.directorypath & fn)>
	</cffunction>
	
	<cffunction name="validate">
		<cfset var l = structnew()>
		<cfif NOT variables.zipObj.isZipfile()>
			<cfset variables.errors = "Zip file could not be read. Check that it is a valid zip file.">
			<cfreturn false>
		</cfif>
		
		<cfset l.errors = arraynew(1)>
		<cfset l.list = variables.zipObj.list()>
		
		<cfquery name="l.checkfolders" dbtype="query">
			SELECT * FROM l.list WHERE type = 'Directory'
		</cfquery>
		
		<cfloop query="l.checkfolders">
			<cfif find("/", directory)>
				<cfset arrayappend(l.errors, 'The only directories should be at the root of the zip. (#directory#) appears to be nested #listlen(directory,"/")# levels deep.')>
			</cfif>
		</cfloop>
		
		<cfquery name="l.checkfiles" dbtype="query">
			SELECT * FROM l.list WHERE type = 'File'
		</cfquery>
		
		<cfloop query="l.checkfiles">
			<cfif listlen(name, "/") EQ 1>
				<cfset arrayappend(l.errors, 'The file (#name#) appears to be at the root of the zip. There should be no files at the root.')>
			</cfif>
			
			<cfif listlen(name, "/") GT 2>
				<cfset arrayappend(l.errors, 'The file (#name#) is not nested one folder deep. Files should only be nested one folder deep.')>
			</cfif>
			
			<cfif len(listlast(name, "/")) GT 53>
				<cfset arrayappend(l.errors, 'Asset files should have names shorter than 50 chars as they will be used for the Asset Name(#listlast(name,"/")#).')>
			</cfif>
		</cfloop>
		
		<cfif arraylen(l.errors)>
			<cfset variables.errors = "Zip file errors <ul><li>" & arraytolist(l.errors,"</li><li>") & "</li></ul>">
			<cfreturn false>
		</cfif>
		
		<cfreturn true>
	</cffunction>
	
	<cffunction name="getValidationIssues">
		<cfreturn variables.errors>
	</cffunction>
	
	<cffunction name="process">
		<cfargument name="assetMdl" required="true">
		<cfargument name="GroupMdl" required="true">
		
		<cfset var results = structnew()>
		<cfset var l = structnew()>
		<cfset variables.zipObj.unzip(variables.directorypath)>
		
		<cfset results.groupsadded = 0>
		<cfset results.groupsupdated = 0>
		<cfset results.assetsadded = 0>
		<cfset results.assetsupdated = 0>
	
		<cfdirectory action="list" name="l.dir" directory="#variables.directorypath#">
		
		<cfloop query="l.dir">
			<cfif l.dir.type EQ "dir">
				<cfdirectory action="list" name="l.groupdir" directory="#l.dir.directory#/#l.dir.name#">
				<cfset processdir(assetMdl, groupMdl, l.groupdir, results)>
			</cfif>
		</cfloop>
				
		<cfreturn results>
	</cffunction>
	
	<cffunction name="processdir">
		<cfargument name="assetmdl" required="true">
		<cfargument name="groupmdl" required="true">
		<cfargument name="list" required="true">
		<cfargument name="results" required="true">
		
		<cfset var l = structnew()>
		<!--- <cfdump var=#list#> --->
		<!--- identify group --->
		<cfquery name="l.txtfilename" dbtype="query">
			SELECT * FROM list WHERE name = 'assetgroupname.txt'
		</cfquery>
		
		<cfif l.txtfilename.recordcount EQ 1>
			<cffile action="read" variable="l.groupname" file="#l.txtfilename.directory#/assetgroupname.txt">
		<cfelse>
			<!--- <cfdump var=#list.directory[1]#> --->
			<cfset l.groupname = replace(listlast(list.directory[1],"\/"), "_", " ", "all")>
			<!--- <cfdump var=#l.groupname#> --->
			<cfset l.groupname = rereplacenocase(l.groupname, "\.[a-zA-Z0-9]{2,4}$", "")>
		</cfif>

		<cfset l.group = groupmdl.getByName(l.groupname)>
		<!--- <cfdump var=#l.group#> --->
		<cfif l.group.recordcount EQ 0>
			<cfset groupmdl.clear()>
			<cfset groupmdl.setname(l.groupname)>
			<cfset groupmdl.setdescription(l.groupname)>
			<cfif NOT groupmdl.save()>
				Groups error
				<cfdump var=#groupmdl.getValidator().getErrors()#>
				<cfabort>
			</cfif>
			<cfset l.groupid = groupmdl.getId()>
			<cfset results.groupsadded = results.groupsadded + 1>
		<cfelse>
			<cfset l.groupid = l.group.id>
		</cfif>
	
		<cfquery name="l.files" dbtype="query">
			SELECT * FROM list WHERE name <> 'assetgroupname.txt' AND type = 'File'
		</cfquery>
		<!--- <cfdump var=#l.files#> --->
	
		<cfloop query="l.files">
			<cfset assetmdl.clear()>
			<cfset l.assetcrit = structnew()>
			<cfset l.assetcrit.assetgroupid = l.groupid>
			<cfset l.assetcrit.name = replace(l.files.name, "_", " ", "all")>
			<cfset l.assetcrit.name = rereplacenocase(l.assetcrit.name, "\.[a-zA-Z0-9]{2,4}$", "")>
			<cfset l.asset = assetmdl.getAll(l.assetcrit)>
			<!--- <cfdump var=#l.asset#> --->
			<cfset l.assetfilename = replace(l.files.name, " ", "_","all")>
			<cfif l.asset.recordcount>
				<cfset l.assetid = l.asset.id>
				<cfset assetmdl.load(l.assetid)>
				<cfset assetmdl.setname(l.assetcrit.name)>
				<cfset assetmdl.setDescription(l.assetcrit.name)>
				<cfset assetmdl.setFileSize(l.files.size)>
				<cfset assetmdl.setFileName(l.assetfilename)>
				<cfif NOT assetmdl.save()>
					asset error
					<cfdump var=#assetmdl.getValidator().getErrors()#>
					<cfabort>
				</cfif>
				<cfset results.assetsupdated = results.assetsupdated + 1>
			<cfelse>
				<cfset assetmdl.setName(l.assetcrit.name)>
				<cfset assetmdl.setdescription(l.assetcrit.name)>
				<cfset assetmdl.setFileSize(l.files.size)>
				<cfset assetmdl.setAssetGroupId(l.groupId)>
				
				<cfset assetmdl.setFileName(l.assetfilename)>
				<cfif NOT assetmdl.save()>
					<cfdump var=#assetmdl.getValidator().getErrors()#>
					<cfabort>
				</cfif>
				<cfset l.assetid = assetmdl.getId()>
				<cfset results.assetsadded = results.assetsadded + 1>
			</cfif>
			<cfif not directoryexists("#variables.assetsdirectorypath#/#l.assetid#")>
				<cfdirectory action="create" directory="#variables.assetsdirectorypath#/#l.assetid#">
			</cfif>
			<cffile action="move" source="#l.files.directory#/#l.files.name#" destination="#variables.assetsdirectorypath#/#l.assetid#/#l.assetfilename#" nameconflict="overwrite">
		</cfloop>
		
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
					assetid AS id, assetname + ' (in ' + assetgroupname + ')' AS name
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
	<!---
	<cffunction name="load" output="false">
		<cfargument name="id" required="true">
		<cfset var sg = "">
		<cfset var itm = "">
	
		<cfquery name="sg" datasource="#variables.requestObj.getvar('dsn')#" result="myre">
			SELECT 
				id, name, filename, description,  previewfilename, changeddate, changedby, assetgroupid, active, startdate, enddate
			FROM assets_view
			WHERE id = <cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_varchar">
		</cfquery>
	
		<cfparam name="variables.itemdata" default="#structnew()#">
		
		<cfloop list="#sg.columnlist#" index="itm">
			<cfset variables.itemdata[itm] = sg[itm][1]>
		</cfloop> 
  
		<cfreturn this>
	</cffunction>
	--->
	<!---
	<cffunction name="getField">
		<cfargument name="fieldname">
		
		<cfif not structkeyexists(variables.itemdata, fieldname)>
			<cfthrow message="field '#arguments.fieldname#' was not found">	
		</cfif>
		
		<cfreturn variables.itemdata[fieldname]>
		
	</cffunction>
	--->
	<!---
	<cffunction name="validate">
		
		<cfset var lcl = structnew()>
		<cfset var requestvars = variables.itemData>
		<cfset var vdtr = createObject('component','utilities.datavalidator').init()>
		<cfset var mylocal = structnew()>
			
		<cfset vdtr.notblank('name', requestvars.name, 'The Asset Name is required.')>
		<cfset vdtr.notblank('assetgroupid', requestvars.assetgroupid, 'The Group Name is required.')>
		<!---><cfset vdtr.notblank('description', requestvars.description, 'A Description for the search results is required.')>--->
		<cfset vdtr.maxlength('description', 255, requestvars.description, 'The Description is too long - currently #len(requestvars.description)#.  Max is 255chars.')>
		
		<cfif requestvars.startdate NEQ "">
			<cfset vdtr.isvaliddate('startdate', requestvars.startdate, 'The Show Date must be valid.')>
		</cfif>
		
		<cfif requestvars.enddate NEQ "">
			<cfset vdtr.isvaliddate('enddate', requestvars.enddate, 'The Hide Date must be valid.')>
		</cfif>
	
		<cfreturn vdtr/>
	</cffunction>
	--->
	<!---
	<cffunction name="saveAsset">
		<cfset var id = "">
		<cfif variables.itemData.id EQ "">
			<cfset id = insertAsset()>
		<cfelse>
			<cfset id = updateAsset()>
		</cfif>
		<cfreturn id>
	</cffunction>
	--->
	<cffunction name="presave">
		<cfset variables.itemdata.changedby = variables.userObj.getUserId()>
		<cfset variables.itemdata.changeddate = now()>
	</cffunction>
	<!--->
	<cffunction name="insertAsset" output="false">
		<cfset var grp = "">
		<cfset var mainfile = ''>
		<cfset var previewfile = ''>

		<!---
		<cfif variables.itemdata.previewfilename NEQ ''>
			<cfset previewfile = createObject('component','utilities.fileuploadandsave').init(target = 'assets', sitepath = variables.requestObj.getVar('machineroot'), file = 'previewfilename')>
			<cfif NOT previewfile.success()>
				<cfthrow message="File not uplaoded.">
			</cfif>
			<cfset previewfile = previewfile.savedName()>
		</cfif>
		--->
		
		<cfset variables.observeEvent('add', this)>
		
		<!--- update the item record --->
		<cfset >
		<cfquery name="grp" datasource="#variables.requestObj.getvar('dsn')#">
			INSERT INTO assets ( 
				id, name, changeddate, changedby, assetgroupid, active, startdate, description, enddate
			)VALUES (
				<cfqueryparam value="#id#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#variables.itemdata.name#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp">,
				<cfqueryparam value="#variables.userObj.getUserId()#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#variables.itemdata.assetgroupid#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#variables.itemdata.active#" cfsqltype="cf_sql_integer">,
				<cfqueryparam value="#variables.itemdata.startdate#" null="#(not isDate(variables.itemdata.startdate))#" cfsqltype="cf_sql_date">,
				<cfqueryparam value="#variables.itemdata.description#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#variables.itemdata.enddate#" null="#(not isDate(variables.itemdata.enddate))#" cfsqltype="cf_sql_date">
			)			
		</cfquery>
		
		<cfreturn id/>
	</cffunction>
	--->
	<!---
	<cffunction name="uploadAsset">
		
		<cfif NOT directoryexists(variables.requestObj.getVar('machineroot') & "docs/assets/#id#")>
			<cfdirectory action="create" directory="#variables.requestObj.getVar('machineroot') & "docs/assets/" & id#">
		</cfif>
		
		<cfset mainfile = createObject('component','utilities.fileuploadandsave').init(target = 'assets/#id#', sitepath = variables.requestObj.getVar('machineroot'), file = 'filename')>
		
		<cfif NOT mainfile.success()>
			<cfthrow message="File not uploaded.">
		</cfif>
		
		
	
			<!--- retrieve the filename to delete, before uploading new file --->
			<cfquery name="qryFile" datasource="#variables.requestObj.getvar('dsn')#">
				SELECT filename
				FROM assets_view 
				WHERE id = <cfqueryparam value="#variables.itemdata.id#" cfsqltype="cf_sql_varchar">
			</cfquery>
			
			<cfif qryFile.recordcount>
				<cfset filetodelete = qryFile.filename>
			</cfif>
			
			<cfif NOT directoryExists(variables.requestObj.getVar('machineroot') & "docs/assets/#variables.itemdata.id#")>
				<cfdirectory action="create" directory="#variables.requestObj.getVar('machineroot') & "docs/assets/" & variables.itemdata.id#" mode="664" >
			</cfif>
			
			<cfset mainfile = createObject('component','utilities.fileuploadandsave').init(target = 'assets/#variables.itemdata.id#', sitepath = variables.requestObj.getVar('machineroot'), file = 'filename', filetodelete = filetodelete)>
			
			<cfif NOT mainfile.success()>
				<cfthrow message="File not uploaded.">
			</cfif>
			
			<cfset mainfilesize = mainfile.filesize()>
			<cfset mainfile = mainfile.savedName()>
		
	</cffunction>
	--->
	<!---
	<cffunction name="updateAsset" output="false">
		<cfset var grp = "">
		<cfset var mainfilesize = "">
		<cfset var mainfile = ''>
		<cfset var previewfile = ''>
		<cfset var qryFile = "">
		<cfset var filetodelete = "">	

		<!---
		<cfif variables.itemdata.previewfilename NEQ ''>
			<cfset previewfile = createObject('component','utilities.fileuploadandsave').init(target = 'assets', sitepath = variables.requestObj.getVar('machineroot'), file = 'previewfilename')>
			<cfif NOT previewfile.success()>
				<cfthrow message="File not uplaoded.">
			</cfif>
			<cfset previewfile = previewfile.savedName()>
		</cfif>--->
			
		<cfset variables.observeEvent('edit', this)>
		
		<cfquery name="grp" datasource="#variables.requestObj.getvar('dsn')#">
			UPDATE assets SET 
				name = <cfqueryparam value="#variables.itemdata.name#" cfsqltype="cf_sql_varchar">,
				startdate = <cfqueryparam value="#variables.itemdata.startdate#" null="#(not isDate(variables.itemdata.startdate))#" cfsqltype="cf_sql_date">, 
				enddate = <cfqueryparam value="#variables.itemdata.enddate#" null="#(not isDate(variables.itemdata.enddate))#" cfsqltype="cf_sql_date">, 
				changeddate = <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp">, 
				description = <cfqueryparam value="#variables.itemdata.description#" cfsqltype="cf_sql_varchar">,
				changedby = <cfqueryparam value="#variables.userObj.getUserId()#" cfsqltype="cf_sql_varchar">, 
				assetgroupid = <cfqueryparam value="#variables.itemdata.assetgroupid#" cfsqltype="cf_sql_varchar">
			WHERE 
				id = <cfqueryparam value="#variables.itemdata.id#" cfsqltype="cf_sql_varchar">
		</cfquery>
		
		<cfreturn variables.itemdata.id>
	</cffunction>
	--->
	<cffunction name="validateDelete">
		
		<cfset var me = "">		
		<cfset var vdtr = this.getValidator()>
		
		<!--- verify the asset is not included on a page --->		
		<cfquery name="me" datasource="#variables.requestObj.getvar('dsn')#">
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
	
	<!--- <cffunction name="deleteAsset" output="false">
		<cfargument name="id" required="true">
		<cfset var fs = createObject('component','utilities.filesystem').init()>
		<cfset var tempFileName = "">
		
		<cfset var itemdata = this.getById(arguments.id)>
		<cfset variables.observeEvent('delete assets', itemdata)>

		<cfif tempFileName neq ''>
			<cfset fs.delete(variables.requestObj.getVar('machineroot') & 'docs/assets/#arguments.id#/' & itemdata.filename)>
		</cfif>
		
		<cfquery name="g" datasource="#variables.requestObj.getvar('dsn')#">
			DELETE FROM assets 
			WHERE id = <cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_varchar"> 
		</cfquery>

	</cffunction> --->
	
	<cffunction name="search" output="false">
		<cfargument name="criteria" required="true">
		<cfset var sg = "">
		
		<cfset variables.observeEvent('search', this)>
		
		<!--- <cfquery name="g" datasource="#variables.requestObj.getvar('dsn')#">
			SELECT a.id, a.name, a.fullname, a.changeddate, ag.name AS assetgroupname 
			FROM assets_view a, assetgroups_view ag
			WHERE a.assetgroupid = ag.id
			AND
			(a.name LIKE <cfqueryparam value="%#arguments.criteria#%" cfsqltype="cf_sql_varchar"> 
				OR ag.name LIKE <cfqueryparam value="%#arguments.criteria#%" cfsqltype="cf_sql_varchar">)
		</cfquery>
		 --->
		
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
			
			<cfif NOT this.save()>
				<cfdump var=#vdtr.getErrors()#><cfabort>
			</cfif>
			<cfset variables.observeEvent('uploaded asset', this)>
		</cfif>
			
		<cfreturn variables.itemdata.filename>
	</cffunction>

</cfcomponent>
	