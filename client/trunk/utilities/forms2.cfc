<cfcomponent name="form2">
	
	<cffunction name="init">
		<cfargument name="requestObject" required="true">
		<cfargument name="formdata">
		<cfset var lcl = structnew()>
		<cfset var user = requestObject.getUserObject()>
		
		<cfset variables.requestObject = arguments.requestObject>
		<cfset variables.items = arraynew(1)>
		
		<cfset variables.forminfo = structnew()>
		
		<cfif structkeyexists(arguments, "formdata")>
			<cfset variables.formdata = arguments.formdata>
		<cfelse>
			<cfset variables.formdata = structnew()>
		</cfif>
		
		<cfset lcl.action = getmetadata(this).name>
		<cfset lcl.action = replace(lcl.action, "modules.","")>
		<cfset variables.action = replace(lcl.action, ".forms.","_")>
		
		<cfif user.isDataSaved("form submission " & variables.action)>
			<cfset lcl.data = user.getSavedData("form submission " & variables.action)>
			<cfset variables.vdtr = lcl.data.vdtr>
			<cfset variables.formdata = lcl.data.formdata>
			<cfset user.clearSavedData("form submission " & variables.action)>
		</cfif>

		<cfset make()>
				
		<cfset lcl.p = addItem("hidden")>
		<cfset lcl.p.setName("submitfrom")>
		<cfset lcl.p.setDefault('/' & requestObject.getFormUrlVar("path"))>
		
		<!--- some apps want you to come back somwehere after succeeding with form --->
		<cfif requestObject.isFormUrlvarSet("relocate")>
			<cfset lcl.p = addItem("hidden")>
			<cfset lcl.p.setName("onsuccessurl")>
			<cfset lcl.p.setDefault(requestObject.getFormUrlVar("relocate"))>
		</cfif>
		
		<!--- track success direction with validation --->
		<cfif structkeyexists(variables.formdata, "onsuccessurl")>
			<cfset lcl.p = addItem("hidden")>
			<cfset lcl.p.setName("onsuccessurl")>
			<cfset lcl.p.setDefault(variables.formdata.onsuccessurl)>
		</cfif>
		
		<cfset requestObject.notifyObservers("form.make.#variables.forminfo.name#", this)>

		<!--- <cfset user.seeForm(variables.forminfo.name, getmetadata(this).name)> --->
		<!--- export here --->
		
		<cfreturn this>
	</cffunction>
	
	<cffunction name="addItem">
		<cfargument name="type" required="true">
		<cfargument name="idx">
		
		<cfset var newitem = "">
		<!--- cfif exists --->
		<cfset newitem = createObject("component","utilities.forms2.#type#").init(requestObject)>
		
		<cfset newitem.setParent(this)>
		<cfset newitem.setFormData(variables.formdata)>
		
		<cfif structkeyexists(arguments, "idx")>
			<cfset arrayinsertat(variables.items, arguments.idx, newitem)>
		<cfelse>
			<cfset arrayappend(variables.items, newitem)>
		</cfif>		
		
		<cfreturn newItem> 
	</cffunction>
	
	<cffunction name="setParent">
		<cfargument name="parent" required="true">
		<cfset variables.parent = arguments.parent>
	</cffunction>
	
	<cffunction name="isFirstView">
		<cfreturn NOT (requestObject.isFormUrlVarSet("submitfrom") OR structkeyexists(variables.formdata, "submitfrom"))>
	</cffunction>
	
	<cffunction name="addAlternateItem">
		<cfargument name="newitem" required="true">
		<cfargument name="idx">

		<cfif structkeyexists(arguments, "idx")>
			<cfset arrayinsertat(variables.items, arguments.idx, newitem)>
		<cfelse>
			<cfset arrayappend(variables.items, newitem)>
		</cfif>		
		
		<cfreturn newItem> 
	</cffunction>
	
	<cffunction name="validate">
		<cfargument name="clear" default="false">
		
		<cfif NOT structkeyexists(variables, "vdtr") OR clear>
			<cfset variables.vdtr = createObject("component", "utilities.datavalidator").init()>
		</cfif>
		
		<cfloop from="1" to="#arraylen(variables.items)#" index="lcl.i">
			<cfif structkeyexists(variables.items[lcl.i], "validate")>
				<cfset variables.items[lcl.i].validate(variables.vdtr)>
			</cfif>
		</cfloop>
		
		<cfreturn variables.vdtr>
	</cffunction>
	
	<cffunction name="submit">
		
	</cffunction>
	
	<cffunction name="showHTML">
		<cfset var lcl = structnew()>

		<cfif structkeyexists(variables.forminfo, "action")>
			<cfset lcl.action = variables.forminfo.action>
		<cfelse>
			<cfset lcl.action = "/forms2/#variables.action#/">
		</cfif>
		
		<cfoutput>
		<cfsavecontent variable="lcl.h">
			<div class="forms2">
			<form class="userform<cfif variables.forminfo.name NEQ ""> #variables.forminfo.name#</cfif>" name="#variables.forminfo.name#" action="#lcl.action#" method="#iif(structkeyexists(variables.forminfo, "method"), "variables.forminfo.method", DE("post"))#">
				<a name="#variables.action#"></a>
				<cfif structkeyexists(variables, "vdtr") AND NOT variables.vdtr.passValidation()>
					#variables.vdtr.getFormattedErrors()#
				</cfif>
				<cfloop from="1" to="#arraylen(variables.items)#" index="lcl.i">
					#variables.items[lcl.i].showHTML()#
				</cfloop>
			</form>
			</div>
		</cfsavecontent>
		</cfoutput>
		
		<cfif structkeyexists(variables.forminfo, "title")>
			<cfset lcl.r = structnew()>
			<cfset lcl.r.title = variables.forminfo.title>
			<cfset lcl.r.html = lcl.h>
			<cfreturn lcl.r>
		</cfif>
		
		<cfreturn lcl.h>
	</cffunction>
	
	<cffunction name="setTitle">
		<cfargument name="title" required="true">
		<cfset variables.forminfo.title = title>
	</cffunction>
	
	<cffunction name="getSuccessInfo">
		<cfthrow message="extend getsuccessinfo">
	</cffunction>
	
	<cffunction name="setformdata">
		<cfargument name="data" required="true">
		<cfset variables.formdata = data>
	</cffunction>
	
	<cffunction name="notempty">
		<cfreturn 1>
	</cffunction>
	
	<cffunction name="dump">
		<cfset var lcl = structnew()>

		<cfif structkeyexists(variables.forminfo, "action")>
			<cfset lcl.action = variables.forminfo.action>
		<cfelse>
			<cfset lcl.action = "/forms2/#variables.action#/">
		</cfif>
		
		<cfoutput>
		<cfsavecontent variable="lcl.h">
			<link rel="stylesheet" href="/ui/esm/forms2.css" type="text/css"/>
			<fieldset class="forms2dump">
			<legend>Form : #variables.forminfo.name#</legend>
				name : #variables.forminfo.name#<br>
				action : #lcl.action#<br>
				<cfloop from="1" to="#arraylen(variables.items)#" index="lcl.i">
					<cfif structkeyexists(variables.items[lcl.i], "dump")>
						#variables.items[lcl.i].dump(variables.forminfo.name)#
					<cfelse>
						<fieldset class="forms2dump">
							<legend>TODO : Name</legend>
							Item does not support dump method.
							
						</fieldset>
					</cfif>
				</cfloop>
			</fieldset>
		</cfsavecontent>
		</cfoutput>
		
		<cfreturn lcl.h>
	</cffunction>
	
	<cffunction name="findByFullPath">
		<cfargument name="path" required="true">
		<cfargument name="matches" default="#structnew()#">
		<cfset var lcl = structnew()>
		<!--- if string, turn this into an array for comparative purposes --->
		<cfif NOT isarray(arguments.path)>
			<cfset arguments.path = listtoarray(arguments.path, ".")>
		</cfif>
		
		<!--- if this mismatches stop --->
		<cfif arraylen(arguments.path) GT 0 AND arguments.path[1] NEQ variables.forminfo.name>
			<cfreturn>
		</cfif>	
		
		<!--- if this matches exactly, add obj to list and stop --->
		<cfif arraylen(arguments.path) EQ 1 AND arguments.path[1] EQ variables.forminfo.name>
			<cfset lcl.path = getMyPath()>
			<cfif NOT structkeyexists(matches, lcl.path)>
				<cfset matches[lcl.path] = arraynew(1)>
			</cfif>
			<cfset arrayappend(matches[lcl.path], this)>
			<cfreturn>
		</cfif>
		
		<!--- if this matches sub continue --->
		<cfif arraylen(arguments.path) GT 1 AND arguments.path[1] EQ variables.forminfo.name>
			<cfset arraydeleteat(arguments.path, 1)>
			<cfloop from="1" to="#arraylen(variables.items)#" index="lcl.i">
				<cfif structkeyexists(variables.items[lcl.i], "findByFullPath")>
					<cfset variables.items[lcl.i].findByFullPath(arguments.path, arguments.matches)>
				</cfif>
			</cfloop>
		</cfif>		
		
		<cfreturn matches>
	</cffunction>
	
	<cffunction name="getmypath">
		<cfargument name="path" default="">

		<cfset arguments.path = listprepend(path, variables.forminfo.name, ".")>
		
		<cfif structkeyexists(variables, 'parent')>
			<cfreturn variables.parent.getMyPath(path)>
		<cfelse>
			<cfreturn path>
		</cfif>
	</cffunction>
	
	<cffunction name="getCacheLength">
		<cfreturn 0>
	</cffunction>
	
</cfcomponent>