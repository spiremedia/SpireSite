<cfcomponent displayname="contentTest" extends="utilities.interfaceunittestmethods">
	
	<cffunction name="setup">
		<cfset variables.httpObj = getSaHttpObj()>
		<cfset variables.siteid = application.sites.getsites().id[1]>
		<!--- set up testpage --->
		<cfset variables.testPage = setupTestPage()>
	</cffunction>
	
	<cffunction name="teardown">
		<cfset var me = "">
		<cfif isDefined("variables.testPage")>
			<cfquery name="me" datasource="#request.requestObject.getVar('dsn')#">
				DELETE FROM pageobjects WHERE pageid = <cfqueryparam value="#variables.testPage.id#">
			</cfquery>
		</cfif>
		<cfset super.teardown()>
	</cffunction>
	
 	<cffunction name="InterfaceTest">    
		<cfset var l = structnew()>
		<cfset var response = "">

		<!--- add HTMLContent --->
		<cfset variables.httpObj.setPath('/contentLink/add/')>		
		<cfset l.arrInfo = structnew()>				
		<cfset l.arrUrlParams = structnew()>
		<cfset l.arrInfo.name = 'middleItem_1_Content'>		
		<cfset l.arrInfo.module = 'HTMLContent'>
		<cfset l.arrInfo.parameterlist = 'editable'>		
		<cfset l.arrUrlParams.pageid = variables.testPage.id>
		<cfset l.arrUrlParams.siteid = variables.siteid>
		<cfset l.arrUrlParams.name = l.arrInfo.name>
		<cfset l.arrUrlParams.type = 'unmanaged'>
		<cfset l.arrUrlParams.template = 'Interior1Column'>
		<cfset l.arrUrlParams.info = URLEncodedFormat(serializeJson(l.arrInfo))>
		<cfloop collection="#l.arrUrlParams#" item="l.idx">
			<cfset variables.httpObj.addUrlField(l.idx, l.arrUrlParams[l.idx])>
		</cfloop>
		<cfset response = variables.httpObj.load()>		
		<cfset asserttrue(condition=(response.getStatus() EQ 200),message="Error while loading content module window")>
		
		<cfset l.fs = response.getESMFormStruct()>
		<cfset variables.httpObj.setPath(response.getESMSubmitsTo())>
		
		<cfset l.fs.mdl = l.arrInfo.module>
		<cfloop collection="#l.fs#" item="l.idx">
			<cfset variables.httpObj.addFormField(l.idx, l.fs[l.idx])>
		</cfloop>
				
		<cfset response = variables.httpObj.load()>
		<cfset l.rjson = deserializejson(response.getHTML())>
		<cfset l.editlink = l.rjson.relocate>

		<cfset asserttrue(condition=(response.getStatus() EQ 200),message="Error while submitting new content module")>
		<cfset asserttrue(condition=refindnocase("/#l.arrInfo.module#/editclientmodule/\?id=[A-Z0-9\-]{35}",l.editlink),message="Error relocating to new content module")>
		<!--- check for lcl scope bug in cf9 --->
		<cfset assertfalse(condition=response.existsByPattern('unknown-obj'), message="possible error with lcl scope")>
				
		<cfset response = variables.httpObj.setPath(l.editlink).load()>
		<cfset l.fs = response.getESMFormstruct()>
		
		<cfloop collection="#l.fs#" item="l.idx">
			<cfset variables.httpObj.addFormField(l.idx, l.fs[l.idx])>
		</cfloop>
		
		<cfset response = variables.httpObj.setPath(response.getESMSubmitsTo()).load()>
		<cfset l.rjson = deserializejson(response.getHTML())>
		<cfset l.issues = structnew()>
		
		<cfloop array="#l.rjson.validation#" index="l.idx">
			<cfset l.issues[l.idx.field] = 1>
		</cfloop>
		
		<cfloop list="content" index="l.idx">
			<cfset asserttrue(condition=(structkeyexists(l.issues, l.idx)), message="Form validation did not find form field #l.idx#.")>
		</cfloop>
		
		<cfset response = variables.httpObj.setPath(l.editlink).load()>
		<cfset l.fs = response.getESMFormstruct()>
		<cfset l.fs.content = "&lt;p&gt;unittesting content&lt;/p&gt;">
		<cfloop collection="#l.fs#" item="l.idx">
			<cfset variables.httpObj.addFormField(l.idx, l.fs[l.idx])>
		</cfloop>
		<cfset response = variables.httpObj.setPath(response.getESMSubmitsTo()).load()>
		<cfset l.rjson = deserializejson(response.getHTML())>
		<cfset variables.httpObj.clear()>
		
		<cfset asserttrue(condition=(response.getStatus() EQ 200),message="Error while saving #l.arrInfo.module#")>
		<cfset asserttrue(condition=(l.rjson.reloadbase EQ 1),message="Error while saving #l.arrInfo.module#")>
		
		<cfhttp method="get" url="#variables.testPage.pageurl#?preview=edit&showmembertype=default" result="l.r">
		
		<cfset asserttrue(condition=refindnocase("unittesting content",l.r.Filecontent), message="Newly saved #l.arrInfo.module# is not displaying")>
		
	</cffunction>
	
	<cffunction name="die" access="private">
		<cfargument name="a">
		<cfif issimplevalue(a)>
			<cfoutput>#a#</cfoutput>
		<cfelse>
			<cfdump var=#a#>
		</cfif>
		<cfabort>
	</cffunction>
	
</cfcomponent>
		