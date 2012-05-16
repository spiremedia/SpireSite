<cfcomponent name="homeImages Model" output="false" extends="resources.abstractmodel">

	<cffunction name="init">
		<cfargument name="requestObj" required="true">
		<cfargument name="userObj" required="true">
		<cfset variables.requestObj = arguments.requestObj>
		<cfset variables.userObj = arguments.userObj>
		<cfset setTableMetaData('{
			"TABLENAME":"homeImages",
			"FIELDS":{
				"created":{"TYPE":"date","LABEL":"Created"},
				"active":{"LABEL":"Active","TYPE":"bit","DEFAULT":1},
				"modified":{"TYPE":"date","LABEL":"Modified"},
				"siteid":{"MAXLEN":35,"TYPE":"varchar","LABEL":"Siteid","VALIDATION":"maxlength,notblank"},
				"relocate":{"MAXLEN":100,"TYPE":"varchar","LABEL":"Relocate","VALIDATION":"maxlength"},
				"changedby":{"MAXLEN":35,"TYPE":"varchar","LABEL":"Changedby","VALIDATION":"maxlength,notblank"},
				"name":{"MAXLEN":100,"TYPE":"varchar","LABEL":"Name","VALIDATION":"maxlength,notblank"},
				"filename":{"MAXLEN":100,"TYPE":"varchar","LABEL":"Filename","VALIDATION":"maxlength"}
			}
		}')>
		<cfset variables.directoryname = "imagerotator">
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
	
</cfcomponent>
