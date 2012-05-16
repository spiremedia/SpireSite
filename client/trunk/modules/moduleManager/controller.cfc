<cfcomponent extends="resources.abstractController" ouput="true">

	<cffunction name="default">
		<cfset variables.modules = this.getModulesModel("moduleManager")>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="modelform">
		<cfset variables.tables = this.getActivityLogsModel("moduleManager").getOrm().getTables()>
		<cfset variables.modules = this.getModulesModel("moduleManager")>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="installables">
		<cfset variables.modules = this.getModulesModel("moduleManager")>
		
		<!--- determine installables --->
		<cffeed
			source = "http://esm3installer.spiremedia.com/index.cfm?view=getAllinfo&1"
        	properties = "variables.tmp" 
        	query = "variables.installables">
		
		<!--- process list of installables --->
		
		<cfreturn this>
	</cffunction>
	
	<cffunction name="modelform2">
		<cfset var l = structnew()>
		<cfset variables.modules = this.getModulesModel("moduleManager")>
		<cfset l.module = this.getModuleModel("moduleManager")>
		<cfset l.modulename = requestObject.getFormUrlVar("n")>
		<cfset l.module.setFolderName(l.modulename)>
		
		<cfset l.datamodelname = requestObject.getFormUrlVar("datamodelname")>
		<cfset l.othermodelname = requestObject.getFormUrlVar("othermodelname")>
		<cfset l.type = requestObject.getFormUrlVar("type")>
				
		<cfif l.type EQ "database">
			<cfset variables.modelname = l.datamodelname>
		<cfelse>
			<cfset variables.modelname = l.othermodelname>
		</cfif>

		<cfif l.module.modelAlreadyExists("variables.modelname")>
			<cfset session.user.setFlash("Model already Exists")>
			<cflocation url="../modelform/?n=#l.modulename#" addtoken="false">
		</cfif>
		
		<cfif l.type EQ "database">
			<cfset l.replaceable = structnew()>
			<cfset l.replaceable.tablename = variables.modelname>
			<cfset l.initstr = l.module.renderTemplateCode("modeldatainitmethod", l.replaceable)>
		<cfelse>
			<cfset l.replaceable = structnew()>
			<cfset l.initstr = l.module.renderTemplateCode("modelinitmethod", l.replaceable)>
		</cfif>
		
		<cfloop list="#requestObject.getFormUrlVar("methodslist")#" index="l.mname">
			<cfset l.mname = trim(l.mname)>
			<cfset l.replaceable = structnew()>
			<cfset l.replaceable.methodname = l.mname>
			<cfset l.initstr = l.initstr & l.module.renderTemplateCode("modelmethod", l.replaceable)>
		</cfloop>
		
		<cfset l.replaceable = structnew()>
		<cfset l.replaceable.modelname = variables.modelname>
		<cfset variables.modeltext = l.module.renderTemplateCode("model.cfc",l.replaceable)>
		<cfset variables.modeltext = l.module.insertStringIntoString(l.initstr, "</cfcomponent>",variables.modeltext, "beforelast")>
			
		<cfreturn this>
	</cffunction>
	
			
	<cffunction name="modelaction">
		<cfset var l = structnew()>
		<cfset l.module = this.getModuleModel("moduleManager")>
		
		<cfset l.modulename = requestObject.getFormUrlVar("n")>
		<cfset l.modelname = requestObject.getFormUrlVar("modelname")>
		<cfset l.modelText = requestObject.getunsafeformurlvar("modelText")>
		
		<cfset l.module.setFolderName(l.modulename)>

		<cfset l.module.makeFileFromString("models/#l.modelname#.cfc", l.modelText)>
		
		<cfset session.user.setFlash("Model Added")>
		<cflocation url="MgModule/?n=#l.modulename#" addtoken="false">
	</cffunction>
	
	<cffunction name="testfileform">
		<cfset var l = structnew()>
		<cfset variables.modules = this.getModulesModel("moduleManager")>
		<cfset l.module = this.getModuleModel("moduleManager")>
		<cfset l.modulename = requestObject.getFormUrlVar("n")>
		<cfset l.module.setFolderName(l.modulename)>
		
		<cfset variables.testfilename = requestObject.getFormUrlVar("testfilename")>
		<cfset l.testfilemethods = requestObject.getFormUrlVar("testfilemethods")>

		<cfif l.module.testFileAlreadyExists("variables.testfilename")>
			<cfset session.user.setFlash("Test File already Exists. Please modify Manually")>
			<cflocation url="../modelform/?n=#l.modulename#" addtoken="false">
		</cfif>

		<cfset l.replaceable = structnew()>
		<cfset l.replaceable.testfilename = variables.testfilename>
		<cfset l.methodstr = "">
		<cfset variables.testfiletext = l.module.renderTemplateCode("test.cfc", l.replaceable)>
		
		<cfloop list="#requestObject.getFormUrlVar("testfilemethods")#" index="l.mname">
			<cfset l.mname = trim(l.mname)>
			<cfset l.replaceable = structnew()>
			<cfset l.replaceable.methodname = l.mname>
			<cfset l.methodstr = l.module.renderTemplateCode("testmethod", l.replaceable)>
			<cfset variables.testfiletext = l.module.insertStringIntoString(l.methodstr, "</cfcomponent>", variables.testfiletext, "beforelast")>
		</cfloop>
		
		<cfreturn this>
	</cffunction>
	
	<cffunction name="testaction">
		<cfset var l = structnew()>
		<cfset l.module = this.getModuleModel("moduleManager")>
		
		<cfset l.modulename = requestObject.getFormUrlVar("n")>
		<cfset l.testfilename = requestObject.getFormUrlVar("testfilename")>
		<cfset l.testfileText = requestObject.getunsafeformurlvar("testfileText")>
		
		<cfset l.module.setFolderName(l.modulename)>

		<cfset l.module.makeFileFromString("#l.testfilename#.cfc", l.testfileText)>
		
		<cfset session.user.setFlash("Test File Added")>
		<cflocation url="MgModule/?n=#l.modulename#" addtoken="false">
	</cffunction>
	
	<cffunction name="cgNewModule">
		<cfset variables.tables = this.getActivityLogsModel("moduleManager").getOrm().getTables()>
		<cfset variables.modules = this.getModulesModel("moduleManager")>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="cgNewModuleAction">
		<cfset variables.name = requestObject.getFormUrlVar("modulename")>
		<cfset variables.mdule = this.getModuleModel("moduleManager")>
		<cfset variables.modules = this.getModulesModel("moduleManager")>
		
		<cfset variables.name = modules.fixModuleName(variables.name)>
		
		<cfif variables.modules.isanesmmodule(variables.name)>
			<cfset session.user.setFlash("Module Already Exists")>
			<cflocation url="../modules/" addtoken="no">
		</cfif>
		
		<cfset variables.mdule.setup(variables.name, requestObject.getFormUrlVar("modulename"))>
		
		<cfset session.user.setFlash("Module Added")>
		
		<cflocation url="mgmodule/?n=#variables.name#" addtoken="no">
	</cffunction>
	
	<cffunction name="templateform">
		<cfset var l = structnew()>
		<cfset variables.modules = this.getModulesModel("moduleManager")>
		<cfset variables.tables = this.getActivityLogsModel("moduleManager").getOrm().getTables()>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="templateform2">
		<cfset var l = structnew()>
		<cfset l.type = requestObject.getFormUrlVar("templatetype")>
		<cfset variables.templatename = requestObject.getFormUrlVar("templatename")>
		<cfset l.module = this.getModuleModel("moduleManager")>
		<cfset l.module.setFolderName(requestObject.getFormUrlVar("n"))>
		<cfset variables.modules = this.getModulesModel("moduleManager")>
		<cfset variables.templatename = variables.modules.fixModuleName(variables.templatename)>
		
		
		<cfif listfind("dblist,dbform", l.type)>
			<cfset l.tablename = requestObject.getFormUrlVar(l.type)>
			<cfset l.fields = this.getActivityLogsModel("moduleManager").getOrm().getTableFields(l.tablename)>
			<cfset l.fields = valuelist(l.fields.name)>
		<cfelseif listfind("formlist,fieldlist", l.type)>
			<cfset l.fields = requestObject.getFormUrlVar(l.type)>
		<cfelse>
			<cfset l.fields = "">
		</cfif>
		
		<cfif listfind("dblist,fieldlist", l.type)>
			<cfset l.htmltype = requestObject.getFOrmUrlVar(l.type & "type")>
		<cfelseif l.type EQ "other">
			<cfset l.htmltype = "">
		<cfelse>
			<cfset l.htmltype = "form">
		</cfif>
		
		<cfif variables.templatename EQ "">
			<cfset session.user.setFlash("Template Name Required")>
			<cflocation url="/system/modules/templateform/?n=#requestObject.getFormUrlVar("n")#" addtoken="no">
		</cfif>
		
		<cfif l.module.templateexists(variables.templatename)>
			<cfset session.user.setFlash("Template Already Exists")>
			<cflocation url="../modules/" addtoken="no">
		</cfif>
		
		<cfset l.replaceable = structnew()>
		<cfset l.replaceable.name = variables.templatename>

		<cfset l.templateText = l.module.renderTemplateCode("template.cfm", l.replaceable)>

		<cfset l.tmpstr = "<cfoutput>">

		<cfif l.htmltype EQ "table">
			<cfset l.tmpstr = l.tmpstr & chr(13) & chr(9) & '<table class="tabulardata">#chr(13)##chr(9)#<tr>#chr(13)##chr(9)#'>
			<cfloop list="#l.fields#" index="l.mname">
				<cfset l.tmpstr = l.tmpstr & "<th>#l.mname#</th>">
			</cfloop>
			<cfset l.tmpstr = l.tmpstr & '#chr(13)##chr(9)#</tr>#chr(13)##chr(9)#<cfloop query="#variables.templatename#">#chr(13)##chr(9)##chr(9)#<tr>#chr(13)#'>
		<cfelseif l.htmltype EQ "divs">
			<cfset l.tmpstr = l.tmpstr & '#chr(13)#<cfloop query="#variables.templatename#">#chr(13)##chr(9)#<div class="#requestObject.getFormUrlVar("n")#item">#chr(13)#'>
		<cfelseif l.htmltype EQ "form">
			<cfset l.tmpstr = l.tmpstr & '#chr(13)#<form name="myForm" action="" method="post">#chr(13)#<cfloop query="#variables.templatename#">#chr(13)##chr(9)#<div class="item">#chr(13)#'>
		</cfif>
		
		<cfloop list="#l.fields#" index="l.mname">
			<cfset l.mname = trim(l.mname)>
			<cfset l.replaceable = structnew()>
			<cfset l.replaceable.varname = lcase(l.mname)>
			<cfset l.tmpstr = l.tmpstr & l.module.renderTemplateCode("#l.htmltype#iterator", l.replaceable)>
		</cfloop>
		
		<cfif l.htmltype EQ "table">
			<cfset l.tmpstr = l.tmpstr & "#chr(9)##chr(9)#</tr>#chr(13)##chr(9)#</cfloop>#chr(13)##chr(9)#</tr>#chr(13)##chr(9)#</table>">
		<cfelseif l.htmltype EQ "divs">
			<cfset l.tmpstr = l.tmpstr & "#chr(9)#</div>#chr(13)#</cfloop>">
		<cfelseif l.htmltype EQ "form">
			<cfset l.tmpstr = l.tmpstr & "#chr(9)#</cfloop>#chr(13)#</form>">
		</cfif>
		
		<cfset l.tmpstr = l.tmpstr & "#chr(13)#</cfoutput>#chr(13)#">
		
		<cfset variables.templatetext = l.module.insertStringIntoString(l.tmpstr, "</div>", l.templateText, "beforelast")>
	
		<cfreturn this>
	</cffunction>
	
	<cffunction name="templateaction">
		<cfset var l = structnew()>
		<cfset l.module = this.getModuleModel("moduleManager")>
		
		<cfset l.modulename = requestObject.getFormUrlVar("n")>
		<cfset l.templatename = requestObject.getFormUrlVar("templatename")>
		<cfset l.testfileText = requestObject.getunsafeformurlvar("templateText")>
		
		<cfset l.module.setFolderName(l.modulename)>

		<cfset l.module.makeFileFromString("templates/#l.templatename#.cfm", l.testfileText)>
		
		<cfset session.user.setFlash("Template Added")>
		<cflocation url="MgModule/?n=#l.modulename#" addtoken="false">
	</cffunction>
	
	<cffunction name="subctrlform">
		<cfset var l = structnew()>
		<cfset variables.modules = this.getModulesModel("moduleManager")>
		<cfset variables.tables = this.getActivityLogsModel("moduleManager").getOrm().getTables()>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="subctrlform2">
		<cfset var l = structnew()>
		<cfset l.type = requestObject.getFormUrlVar("ctrltype")>
		<cfset l.subctrllayout = requestObject.getFormUrlVar("subctrllayout")>
		<cfset l.cacheable = NOT requestObject.isFormUrlVarSet("cacheable")>
		<cfset variables.subctrlname = requestObject.getFormUrlVar("subctrlname")>
		<cfset l.module = this.getModuleModel("moduleManager")>
		<cfset l.module.setFolderName(requestObject.getFormUrlVar("n"))>
		<cfset variables.modules = this.getModulesModel("moduleManager")>
		<cfset variables.subctrlname = variables.modules.fixModuleName(variables.subctrlname)>
		
		<cfif listfind("dblist,dbform", l.type)>
			<cfset l.tablename = requestObject.getFormUrlVar(l.type)>
			<cfset l.fields = this.getActivityLogsModel("moduleManager").getOrm().getTableFields(l.tablename)>
			<cfset l.fields = valuelist(l.fields.name)>
		<cfelseif listfind("formlist,fieldlist", l.type)>
			<cfset l.fields = requestObject.getFormUrlVar(l.type)>
		<cfelse>
			<cfset l.fields = "">
		</cfif>
		
		<cfif listfind("dblist,fieldlist", l.type)>
			<cfset l.htmltype = requestObject.getFOrmUrlVar(l.type & "type")>
		<cfelseif l.type EQ "other">
			<cfset l.htmltype = "">
		<cfelse>
			<cfset l.htmltype = "form">
		</cfif>
		
		<cfif variables.subctrlname EQ "">
			<cfset session.user.setFlash("Subcontroller Name Required")>
			<cflocation url="/system/modules/subctrlform/?n=#requestObject.getFormUrlVar("n")#" addtoken="no">
		</cfif>
		
		<cfif l.module.subcontrollerexists(variables.subctrlname)>
			<cfset session.user.setFlash("Subcontroller Already Exists")>
			<cflocation url="../modules/" addtoken="no">
		</cfif>
		
		<cfset l.replaceable = structnew()>
		<cfset l.replaceable.name = variables.subctrlname>

		<cfset l.subctrlText = l.module.renderTemplateCode("subcontroller.cfc", l.replaceable)>
		
		<cfset l.tmpstr = "<cfoutput>">

		<cfif l.htmltype EQ "table">
			<cfset l.tmpstr = l.tmpstr & chr(13) & chr(9) & '<table class="tabulardata">#chr(13)##chr(9)#<tr>#chr(13)##chr(9)#'>
			<cfloop list="#l.fields#" index="l.mname">
				<cfset l.tmpstr = l.tmpstr & "<th>#l.mname#</th>">
			</cfloop>
			<cfset l.tmpstr = l.tmpstr & '#chr(13)##chr(9)#</tr>#chr(13)##chr(9)#<cfloop query="#variables.subctrlname#">#chr(13)##chr(9)##chr(9)#<tr>#chr(13)#'>
		<cfelseif l.htmltype EQ "divs">
			<cfset l.tmpstr = l.tmpstr & '#chr(13)#<cfloop query="#variables.subctrlname#">#chr(13)##chr(9)#<div class="item">#chr(13)#'>
		<cfelseif l.htmltype EQ "form">
			<cfset l.tmpstr = l.tmpstr & '#chr(13)#<form name="myForm" action="" method="post">#chr(13)#<cfloop query="#variables.templatename#">#chr(13)##chr(9)#<div class="#requestObject.getFormUrlVar("n")#item">#chr(13)#'>
		</cfif>
		
		<cfloop list="#l.fields#" index="l.mname">
			<cfset l.mname = trim(l.mname)>
			<cfset l.replaceable = structnew()>
			<cfset l.replaceable.varname = lcase(l.mname)>
			<cfset l.tmpstr = l.tmpstr & l.module.renderTemplateCode("#l.htmltype#iterator", l.replaceable)>
		</cfloop>
		
		<cfif l.htmltype EQ "table">
			<cfset l.tmpstr = l.tmpstr & "#chr(9)##chr(9)#</tr>#chr(13)##chr(9)#</cfloop>#chr(13)##chr(9)#</tr>#chr(13)##chr(9)#</table>">
		<cfelseif l.htmltype EQ "divs">
			<cfset l.tmpstr = l.tmpstr & "#chr(9)#</div>#chr(13)#</cfloop>">
		<cfelseif l.htmltype EQ "form">
			<cfset l.tmpstr = l.tmpstr & "#chr(9)#</cfloop>#chr(13)#</form>">
		</cfif>
		
		<cfset l.tmpstr = l.tmpstr & "#chr(13)#</cfoutput>#chr(13)#">
		
		<cfset l.tmpstr = replace(l.tmpstr, chr(10), "","all")>
		<cfset l.view = l.module.renderTemplateCode("template.cfm", l.replaceable)>
		<cfset l.view = l.module.insertStringIntoString(l.tmpstr, "</div>", l.view, "beforelast")>
		
		<cfif l.subctrllayout EQ "template">
			<cfset variables.templatetext = l.view>
			<cfset l.replaceable = structnew()>
			<cfset l.replaceable.name = variables.subctrlname>
			<cfset variables.subctrltext = l.module.renderTemplateCode("subcontroller.cfc", l.replaceable)>
		<cfelse>
			<cfset l.showhtmlstr = l.module.renderTemplateCode("showhtmlmethod", structnew())>
			<cfset l.tmpstr = replace(l.tmpstr, chr(13), chr(13) & chr(9) & chr(9), "all")>
			<cfset l.showhtmlstr = l.module.insertStringIntoString(l.tmpstr, "</cfsavecontent>", l.showhtmlstr, "beforelast")>
			<cfset variables.subctrltext = l.module.insertStringIntoString(l.showhtmlstr, "</cfcomponent>", l.subctrlText, "beforelast")>
		</cfif>
		
		<cfif l.cacheable>
			<cfset l.cacheabletxt = l.module.renderTemplateCode("cacheablemethod", structnew())>
			<cfset variables.subctrltext = l.module.insertStringIntoString(l.cacheabletxt, "</cfcomponent>", l.subctrlText, "beforelast")>
		</cfif>
		
		<cfreturn this>
	</cffunction>
	
	<cffunction name="subctrlaction">
		<cfset var l = structnew()>
		<cfset l.module = this.getModuleModel("moduleManager")>
		
		<cfset l.modulename = requestObject.getFormUrlVar("n")>
		<cfset l.subctrlname = requestObject.getFormUrlVar("subctrlname")>
		<cfset l.subctrlText = requestObject.getunsafeformurlvar("subctrlText")>
				
		<cfset l.module.setFolderName(l.modulename)>

		<cfset l.module.makeFileFromString("#l.subctrlname#ctrl.cfc", l.subctrlText)>
		
		<cfif requestObject.isFormUrlVarSet("templatetext")>
			<cfset l.templateText = requestObject.getunsafeformurlvar("templatetext")>
			<cfset l.module.makeFileFromString("templates/#l.subctrlname#.cfm", l.templateText)>
		</cfif>
		
		<cfset session.user.setFlash("Subcontroller Added")>
		<cflocation url="MgModule/?n=#l.modulename#" addtoken="false">
	</cffunction>
	
	
	<cffunction name="cgModule">
		<cfset variables.modules = this.getModulesModel("moduleManager")>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="mgModule">
		<cfset variables.modules = this.getModulesModel("moduleManager")>
		<cfset variables.mdule = this.getModuleModel("moduleManager")>
		<cfset variables.mdule.setFolderName(requestObject.getFormUrlVar("n"))>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="installmodule">
		<cfset variables.modules = this.getModulesModel("moduleManager")>
		<cfset variables.mdule = this.getModuleModel("moduleManager")>
		
		<cfset l.moduletoinstall = requestObject.getFormUrlVar("moduletoinstall")>
				
		<cfset l.module = modules.getDownloadAbleModuleInfo(l.moduletoinstall)>

		<cfif directoryexists(requestObject.getVar("machineroot") & '/modules/' & l.module.module)>
			<cfset session.user.setFlash("This folder already exists.")>
			<cflocation url="/system/modules/installables/" addtoken="false">
		</cfif>

		<cfset variables.results = modules.installModule(l.module)>
		
		<cfreturn this>
	</cffunction>
	
	<cffunction name="getCacheLength">
		<cfreturn 0>
	</cffunction>
</cfcomponent>