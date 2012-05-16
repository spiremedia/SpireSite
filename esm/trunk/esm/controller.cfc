<cfcomponent name="Config" extends="resources.abstractController">

	<cffunction name="startPage">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">

	</cffunction>
	
	<cffunction name="toSingularLabel">
		<cfargument name="str">
		<cfset str = rereplace(str, "[A-Z]", " /1","all")>
		<cfset str = rereplace(str, "s$", "")>
		<cfset str = ucase(left(str,1)) & mid(str, 2, len(str))>
		<cfreturn str>
	</cffunction>
	
	<cffunction name="toSingular">
		<cfargument name="str">
		<cfset str = rereplace(str, "s$", "")>
		<cfset str = ucase(left(str,1)) & mid(str, 2, len(str))>
		<cfreturn str>
	</cffunction>
	
	<cffunction name="getModuleModel">
		<cfargument name="requestObject">
		<cfargument name="userObject">
		<cfset mdl = createObject("component","esm.models.module").init(requestObject,userObject)>
		<cfreturn mdl>
	</cffunction>
	
    <cffunction name="getModulesModel">
		<cfargument name="requestObject">
		<cfargument name="userObject">
		<cfset mdl = createObject("component","esm.models.modules").init(requestObject,userObject)>
		<cfreturn mdl>
	</cffunction>
    
    <cffunction name="localsettings">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">

		<cfset var settings = application.settings.getinistring()>
		
		<cfset displayObject.setData( 'settings', settings )>

	</cffunction>
    
    <cffunction name="updatelocalsettings">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">
		
        <cfset var msg = structnew()>
        <cfset var settings = requestObject.getFormUrlVar("settings")>
		<cfset var dv = createObject('component', "utilities.datavalidator").init(requestObject)>
		
		
		<cfset dv.notblank('settings', settings, 'Settings may not be blank')>
		
		<cfif dv.passvalidation()>
			<cfset settings = application.settings.saveinistring(settings)>
	       	<cfset msg.message = "Settings Updated">	
		</cfif>
		
        <cfset displayObject.sendJson(msg)>
	
	</cffunction>
    
    <cffunction name="Modules">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">

		<cfset var mm = getModulesModel(requestObject, userObj)>
		<cfset var t = createObject("component","resources.orm.start").init(requestObject, userObj).getTables()>

		<cfset displayObject.setData('tables', t)>
		<cfset displayObject.setData('modules', mm.getAll())>
	</cffunction>
	
    <cffunction name="tables">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">

		<cfset var mm = getModulesModel(requestObject, userObj)>
		<cfset var t = createObject("component","resources.orm.start").init(requestObject, userObj).getTables()>

		<cfset displayObject.setData('tables', t)>
		<cfset displayObject.setData('modules', mm.getAll())>
	</cffunction>
	
    <cffunction name="downloadModule">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">
		
		<cfset var l = structnew()>
		
		<cfset l.m = getModulesModel(requestObject, userObj)>
		<cfset l.modules = l.m.getDownloadAbleModules()>

		
		<cfset displayObject.setData('modules', l.m.getAll())>
		<cfset displayObject.setData('modulesavailable', l.modules.items)>
	</cffunction>
	
	<cffunction name="installdownloadableModule">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">
		
		<cfset var l = structnew()>
		
		<cfset l.moduletoinstall = requestObject.getFormUrlVar("moduletoinstall")>
		<cfset l.m = getModulesModel(requestObject, userObj)>
		
		<cfset l.module = l.m.getDownloadAbleModuleInfo(l.moduletoinstall)>

		<cfif directoryexists(requestObject.getVar("machineroot") & '/' & l.module.module)>
			<cfset userobj.setFlash("This folder already exists.")>
			<cflocation url="/esm/downloadmodule/" addtoken="false">
		</cfif>

		<cfset l.results = l.m.installModule(l.module)>
		
		<cfset displayObject.setData('modules', l.m.getAll())>
		<cfset displayObject.setData('results', l.results)>
		<cfset displayObject.setData('module', l.module)>
	</cffunction>
	 <!---   
    <cffunction name="editTemplateItem">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">

		<cfset var viewlist = createObject('component', 'resources.clientTemplates').init(requestObject, userobj).get()>
		<cfset var modulesavailable = createObject('component', 'resources.clientmodulesavailable').init(requestObject, userobj).get()>
		<cfset var templates = createObject('component','resources.clientTemplates').init(requestObject)>
		<cfset displayObject.setData( 'modulesavailable', modulesavailable )>
		
		<cfset displayObject.setData( 'templateitem', templates.getTemplateItems(requestObject.getFormUrlVar("template"), requestObject.getFormUrlVar("itemname")) )>
	</cffunction>
	
	<cffunction name="templateItemForm">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">

		<cfset var templates = createObject('component','resources.clientTemplates').init(requestObject)>
		<cfset var modulesavailable = createObject('component', 'resources.clientmodulesavailable').init(requestObject, userobj).get()>
		<cfset displayObject.setData( 'modulesavailable', modulesavailable )>
		<cfset displayObject.setData( 'templateitem', templates.getTemplateItems(requestObject.getFormUrlVar("template"), requestObject.getFormUrlVar("itemname")) )>

	</cffunction>
	--->
	<cffunction name="module">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">

		<cfset var moduleMdl = getModuleModel(requestObject, userObj)>
		<cfset var modulesMdl = getModulesModel(requestObject, userObj)>
		
		<cfset moduleMdl.setFolderName(requestObject.getFormUrlVar("n"))>
		
		<cfset displayObject.setData('modules', modulesMdl.getAll())>
		<cfset displayObject.setData('modulemdl', moduleMdl)>
	</cffunction>
	
	<cffunction name="model">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">

		<cfset var moduleMdl = getModuleModel(requestObject, userObj)>
		<cfset var modulesMdl = getModulesModel(requestObject, userObj)>
		<cfset var tableMdl = createObject("component","resources.orm.start").init(requestObject,userObj)>
		
		<cfif NOT requestObject.isFormUrlVarSet("n")>
			<cfthrow message="n not set">
		</cfif>
		
		<cfset moduleMdl.setFolderName(requestObject.getFormUrlVar("n"))>

		<cfset displayObject.setData('modules', modulesMdl.getAll())>
		<cfset displayObject.setData('moduleMdl', moduleMdl)>
		<cfset displayObject.setData('tables', tableMdl.getTables())>

	</cffunction>
	
	<cffunction name="action">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">

		<cfset var moduleMdl = getModuleModel(requestObject, userObj)>
		<cfset var modulesMdl = getModulesModel(requestObject, userObj)>
		<cfset var tableMdl = createObject("component","resources.orm.start").init(requestObject,userObj)>
		
		<cfif NOT requestObject.isFormUrlVarSet("n")>
			<cfthrow message="n not set">
		</cfif>
		
		<cfset moduleMdl.setFolderName(requestObject.getFormUrlVar("n"))>

		<cfset displayObject.setData('modules', modulesMdl.getAll())>
		<cfset displayObject.setData('moduleMdl', moduleMdl)>
		<cfset displayObject.setData('tables', tableMdl.getTables())>

	</cffunction>
	
	<cffunction name="view">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">

		<cfset var moduleMdl = getModuleModel(requestObject, userObj)>
		<cfset var modulesMdl = getModulesModel(requestObject, userObj)>
		<cfset var tableMdl = createObject("component","resources.orm.start").init(requestObject,userObj)>
		
		<cfif NOT requestObject.isFormUrlVarSet("n")>
			<cfthrow message="n not set">
		</cfif>
		
		<cfset moduleMdl.setFolderName(requestObject.getFormUrlVar("n"))>

		<cfset displayObject.setData('modules', modulesMdl.getAll())>
		<cfset displayObject.setData('moduleMdl', moduleMdl)>
		<cfset displayObject.setData('tables', tableMdl.getTables())>
	</cffunction>
	
	<cffunction name="editables">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">


		<cfset var modulesMdl = getModulesModel(requestObject, userObj)>
		<cfset var moduleMdl = getModuleModel(requestObject, userObj)>
		
		<cfset moduleMdl.setFolderName(requestObject.getFormUrlVar("n"))>
		
		<cfif NOT requestObject.isFormUrlVarSet("n")>
			<cfthrow message="n not set">
		</cfif>
		
		<cfset displayObject.setData('modules', modulesMdl.getAll())>
		<cfset displayObject.setData('moduleMdl', moduleMdl)>

	</cffunction>
	
	<cffunction name="template">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">

		<cfset var moduleMdl = getModuleModel(requestObject, userObj)>
		<cfset var modulesMdl = getModulesModel(requestObject, userObj)>
		
		<cfif NOT requestObject.isFormUrlVarSet("n")>
			<cfthrow message="n not set">
		</cfif>
		
		<cfset moduleMdl.setFolderName(requestObject.getFormUrlVar("n"))>

		<cfset displayObject.setData('modules', modulesMdl.getAll())>
		<cfset displayObject.setData('modulesMdl', modulesMdl)>

	</cffunction>
	
	<cffunction name="test">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">

		<cfset var modulesMdl = getModulesModel(requestObject, userObj)>
		
		<cfif NOT requestObject.isFormUrlVarSet("n")>
			<cfthrow message="n not set">
		</cfif>
		
		<cfset displayObject.setData('modules', modulesMdl.getAll())>

	</cffunction>
	
	<cffunction name="getTableInfo">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">

		<cfset var moduleMdl = getModuleModel(requestObject, userObj)>
		<cfset var tableinfo = moduleMdl.getTableJson(requestObject.getFormUrlVar("tablename"))>
		
		<cfset displayObject.showHTML(tableinfo)>
	
	</cffunction>
	
	<cffunction name="saveModel">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">
		
		<cfset var modulesMdl = getModulesModel(requestObject,userObj)>
		<cfset var moduleMdl = getModuleModel(requestObject,userObj)>
		<cfset var jsonObj = getUtility("json")>
		<cfset var tableName = requestObject.getFormUrlVar("tablename")>
		<cfset var altName = requestObject.getFormUrlVar("altname")>
		<cfset var hasfactory = false>
		<cfset var name = requestObject.getFormUrlVar("n")>
		<cfset var msg = structnew()>

		<cfset moduleMdl.setFolderName(name)>
		
		<cfif NOT modulesMdl.isanesmmodule(name)>
			<cfset msg.message = "Invalid Module">
			<cfset displayObject.sendJson(msg)>
		</cfif>
		
		<cfif requestObject.isFormUrlVarSet("addctrlerfactorymethod") AND requestObject.getFormUrlVar("addctrlerfactorymethod")>
			<cfset hasfactory = true>
		</cfif>

		<cfif tablename NEQ "">
			<!--- check sitewide so as not to have duplicates --->
			<cfif modulesMdl.modelAlreadyExists(tableName)>
				<cfset msg.message = "This table already has an model.">
				<cfset displayObject.sendJson(msg)>
			</cfif>
						
			<cfif moduleMdl.modelAlreadyExists(tableName)>
				<cfset msg.message = "This module already has this model. You'll have to alter it manually for now.">
				<cfset displayObject.sendJson(msg)>
			</cfif>
		
			<!---
			<cfset tableInfo = tableMdl.getTableFields(tableName)>
	
			<cfset ps.tablename = tableName>
			<cfset ps.fields = structnew()>
			<cfloop query="tableInfo">
				<cfset tmp = structnew()>
				
				<cfswitch expression="#type#">
					<cfcase value="varchar">
						<cfset tmp.type = "varchar">
						<cfset tmp.maxlen = length>
						<cfset tmp.validation = "maxlen,notblank">
					</cfcase>
					<cfcase value="text">
						<cfset tmp.type= "varchar">
						<cfset tmp.validation = "notblank">
					</cfcase>
					<cfcase value="integer">
						<cfset tmp.type = "integer">
						<cfif name EQ "deleted">
							<cfset tmp.default = 0>
						</cfif>
						<cfif name EQ "active">
							<cfset tmp.default = 1>
						</cfif>
					</cfcase>
					<cfcase value="bit">
						<cfset tmp.type = "bit">
						<cfif name EQ "deleted">
							<cfset tmp.default = 0>
						</cfif>
						<cfif name EQ "active">
							<cfset tmp.default = 1>
						</cfif>
					</cfcase>
					<cfcase value="datetime,date,timestamp">
						<cfset tmp.type = "date">
					</cfcase>
				</cfswitch>
			
				<cfset tmp.label = ucase(left(tableinfo.name,1)) & lcase(right(tableinfo.name,len(tableinfo.name)-1))>
				<cfset ps.fields[tableinfo.name] = tmp>
			</cfloop>
			<!--- <cfset structdelete(ps.fields, "id")> --->
	
			<cfset ps = jsonObj.encode(ps)>
			<cfset replaceable.tablemetadata = "<cfset setTableMetaData('" & ps & "')>">
			<cfset replaceable.modelname = tablename>
			<cfset moduleMdl.makeFile("model.cfc", "models/#replaceable.modelname#.cfc", replaceable)>
				--->
			<cfset moduleMdl.makeModel(tablename, hasfactory, tablename)>
			<cfset userObj.setFlash("#tablename# Model Added")>
			<cfset msg.relocate = "/esm/module/?n=#name#">
		<cfelse>
			<cfif moduleMdl.modelAlreadyExists(altName)>
				<cfset msg.message = "This module already has this model. You'll have to alter it manually for now.">
				<cfset displayObject.sendJson(msg)>
			</cfif>
		
			<!---<cfset replaceable.modelname = altName>		
			<cfset moduleMdl.makeFile("model.cfc", "models/#replaceable.modelname#.cfc", replaceable)>--->
			<cfset moduleMdl.makeModel(altName, hasfactory)>
			<cfset userObj.setFlash("#altname# Model Added")>
			<cfset msg.relocate = "/esm/module/?n=#name#">
		</cfif>
		
		<cfset displayObject.sendJson(msg)>
	</cffunction>
    
	<cffunction name="saveView">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">
		
		<cfset var modulesMdl = getModulesModel(requestObject, userObj)>
        <cfset var moduleMdl = getModuleModel(requestObject, userObj)>
		<cfset var msg = structnew()>
		<cfset var name = trim(requestObject.getFormUrlVar("n"))>
		<cfset var actionxmlStr = trim(requestObject.getFormUrlVar("maction"))>
		<cfset var actionxml = "">
		<cfset var l = structnew()>
		<cfset l.replaceable = structnew()>
		
		<cfset moduleMdl.setFolderName(name)>
		
		<!--- loadxml --->
		<cfset actionxml = xmlparse(actionxmlStr)>
		<cfset actionname = rereplace(actionxml.action.xmlAttributes.name, "[^0-9a-zA-Z]","","all") >
		
		<!--- slight change to string --->
		<cfset actionxmlStr = chr(10) & chr(9) & chr(9) & replace(actionxmlStr, chr(10),  chr(10) & chr(9) & chr(9), "all")>

		<!--- check action name valid --->
		<cfif NOT refindnocase("^[a-z][a-z0-9_\-]+$", actionname)>
			<cfset msg.message = "Ohh Nooooooo!  action names must follow standard variable techniques.">
			<cfset displayObject.sendJson(msg)>
		</cfif>
		
		<!--- check action not already there --->
		<cfif  moduleMdl.controllerHasMethod(actionname)>
			<cfset msg.message = "daaaaamn!  This method already exists in the controller!">
			<cfset displayObject.sendJson(msg)>
		</cfif>
		
		<!--- add the item to xml--->		
		<cfset moduleMdl.addStringToFile("modulexml.cfm", actionxmlStr, "</action>", "afterlast")>
				
		<!--- add the itme to the controlelr --->
		<cfset replaceable.methodname = actionname>
		<cfset moduleMdl.addTemplateToFile("normalmethod", "controller.cfc", replaceable, "</cffunction>", "afterlast")>
		
		<!--- loop thru each include file and add it if it does not exist --->
		<cfset l.mtch = xmlsearch(actionxml, "//template")>
		<cfloop from="1" to="#arraylen(l.mtch)#" index="l.idx">
			<cfset l.filename = l.mtch[l.idx].xmlAttributes.file>
			<cfif NOT modulemdl.templateexists(l.filename)>
				<cfif modulesmdl.templatepatternexists(l.filename)>
					<cfset l.replaceable.methodname = actionname>
					<cfset moduleMdl.makeFile(replace(l.filename,".cfm", "template.cfm"), "templates/#l.filename#", l.replaceable)>
				<cfelse>
					<cfset moduleMdl.makeFile("plaintemplate.cfm", "templates/#l.filename#", l.replaceable)>
				</cfif>
			</cfif>
		</cfloop>
		<cfset userobj.setFlash("View Added")>
		<cfset msg.relocate = "/esm/module/?n=#name#">

		<cfset displayObject.sendJson(msg)>
	</cffunction>
		
	<cffunction name="generateeditables">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">
		
		<cfset var modulesMdl = getModulesModel(requestObject, userObj)>
        <cfset var moduleMdl = getModuleModel(requestObject, userObj)>
		<cfset var msg = structnew()>
		<cfset var name = trim(requestObject.getFormUrlVar("n"))>
		<cfset var listofsaveables = trim(requestObject.getFormUrlVar("listofsaveables"))>
		<cfset var modelstouse = trim(requestObject.getFormUrlVar("modelstouse"))>
		<cfset var actionxml = "">
		<cfset var l = structnew()>
		<cfset l.replaceable = structnew()>
		<cfset moduleMdl.setFolderName(name)>
		
		<cfif NOT moduleMdl.controllerHasMethod("editClientModule")>
			<cfset l.replaceable = structnew()>
			<cfset l.replaceable2 = structnew()>
			<cfset moduleMdl.addTemplateToFile("editableclientmoduleaction", "modulexml.cfm", l.replaceable, "</action>", "afterlast")>
			
			<cfset moduleMdl.makeFile("clientmodulebuttonstemplate.cfm", "templates/clientmodulebuttons.cfm", l.replaceable)>
			<cfset moduleMdl.makeFile("clientmodulelabeltemplate.cfm", "templates/clientmodulelabel.cfm", l.replaceable)>
			
			<cfset l.replaceable2 = structnew()>	
			<!--- <cfset l.replaceable.varnames = ""> --->
			<cfset l.replaceable.formfields = "">
			<cfloop list="#listofsaveables#" index="l.lidx">
				<cfset l.replaceable2.varname = l.lidx>
				<cfset l.replaceable2.fieldname = l.lidx>
				<!--- <cfset l.replaceable.varnames = l.replaceable.varnames  & moduleMdl.renderTemplateCode("getdataitemcall", l.replaceable2)> --->
				<cfset l.replaceable.formfields = l.replaceable.formfields & moduleMdl.getFormStr(l.lidx, l.lidx, "widgetModel")>
			</cfloop>
			
			<cfset moduleMdl.makeFile("clientmoduleformtemplate.cfm", "templates/clientmoduleform.cfm", l.replaceable)>
			
			<cfset l.replaceable.getmodels = "">
			<cfset l.replaceable.setmodels = "">
			<cfloop list="#modelstouse#" index="l.lidx">
				<cfset l.replaceable2.modelname = l.lidx>
				<cfset l.replaceable.setmodels = l.replaceable.setmodels  & moduleMdl.renderTemplateCode("setdatacall", l.replaceable2)>
				<cfset l.replaceable.getmodels = l.replaceable.getmodels  & moduleMdl.renderTemplateCode("modelfactorycall", l.replaceable2)>
			</cfloop>
			<cfset moduleMdl.addTemplateToFile("editclientmodulemethod", "controller.cfc", l.replaceable, "</cffunction>", "afterlast")>
		</cfif>

		<cfif NOT moduleMdl.controllerHasMethod("SaveClientModule")>
			<cfset l.replaceable = structnew()>
			<cfset l.replaceable.actionname = "saveclientmodule">
			<cfset moduleMdl.addTemplateToFile("ajaxaction", "modulexml.cfm", l.replaceable, "</module>", "beforelast")>
			<cfset moduleMdl.addTemplateToFile("saveclientmodulemethod", "controller.cfc", l.replaceable, "</cffunction>", "afterlast")>
		</cfif>

		<cfif NOT moduleMdl.controllerHasMethod("DeleteClientModule")>
			<cfset l.replaceable = structnew()>
			<cfset l.replaceable.actionname = "deleteclientmodule">
			<cfset moduleMdl.addTemplateToFile("ajaxaction", "modulexml.cfm", l.replaceable, "</module>", "beforelast")>
			<cfset moduleMdl.addTemplateToFile("deleteclientmodulemethod", "controller.cfc", l.replaceable, "</cffunction>", "afterlast")>
		</cfif>

		<cfif NOT moduleMdl.modelAlreadyExists("widgetmodel")>
			<!--- add widget model --->
			<cfset l.replaceable = structnew()>
			<cfset l.replaceable2 = structnew()>
			<cfset l.replaceable.params1 = "">
			<cfset l.replaceable.params2 = "">
			<cfset l.replaceable.params3 = "">
			<cfset l.replaceable.params4 = "">
			
			<cfloop list="#listofsaveables#" index="l.lidx">
				<cfset l.replaceable2.varname = l.lidx>
				<cfset l.replaceable.params1 = l.replaceable.params1  & moduleMdl.renderTemplateCode("cfparamcall", l.replaceable2)>
				<cfset l.replaceable.params2 = l.replaceable.params2  & moduleMdl.renderTemplateCode("widgetmodelsetcall", l.replaceable2)>
				<cfset l.replaceable.params3 = l.replaceable.params3  & moduleMdl.renderTemplateCode("widgetmodelsetfromargscall", l.replaceable2)>
				<cfset l.replaceable.params4 = l.replaceable.params4  & moduleMdl.renderTemplateCode("widgetmodelcettolvarcall", l.replaceable2)>
			</cfloop>
			
			<cfset moduleMdl.makeFile("widgetmodel.cfc", "models/widgetmodel.cfc", l.replaceable)>
		</cfif>
		<cfset userobj.setFlash("Editables Generated")>
		<cfset msg.relocate = "/esm/module/?n=#name#">

		<cfset displayObject.sendJson(msg)>
	</cffunction>
	
	<cffunction name="saveTemplate">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">
		
		<cfset var modulesMdl = getModulesModel(requestObject, userObj)>
        <cfset var moduleMdl = getModuleModel(requestObject, userObj)>
		<cfset var msg = structnew()>
		<cfset var name = trim(requestObject.getFormUrlVar("n"))>
		<cfset var templatename = trim(requestObject.getFormUrlVar("templatename"))>
		<cfset var templatepattern = trim(requestObject.getFormUrlVar("templatepattern"))>
		
		<cfset var l = structnew()>
		<cfset l.replaceable = structnew()>
		
		<cfset moduleMdl.setFolderName(name)>
		
		<cfif templatepattern EQ "">
			<cfset templatepattern = "plaintemplate">
		</cfif>
		
		<!--- check template name valid --->
		<cfif NOT refindnocase("^[a-z][a-z0-9_\-]+$", templatename)>
			<cfset msg.message = "Ohh Goodness!  template names must be alphanumeric only.">
			<cfset displayObject.sendJson(msg)>
		</cfif>
		
		<!--- check template not already there --->
		<cfif  moduleMdl.templateExists(templatename & ".cfm")>
			<cfset msg.message = "Whyyyyyy!  This template exists in this module!">
			<cfset displayObject.sendJson(msg)>
		</cfif>

		<cfset moduleMdl.makeFile(templatepattern & ".cfm", "templates/#templatename#.cfm", l.replaceable)>

		<cfset userobj.setflash("Template Added")>
		<cfset msg.relocate = "/esm/module/?n=#name#">

		<cfset displayObject.sendJson(msg)>
	</cffunction>
	
	<cffunction name="saveSkeletonModule">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">
		
		<cfset var modulesMdl = getModulesModel(requestObject, userObj)>
        <cfset var moduleMdl = getModuleModel(requestObject, userObj)>
		<cfset var msg = structnew()>
		<cfset var name = trim(requestObject.getFormUrlVar("name"))>
		<cfset var moduleFolder = "">
		<cfset var more = structnew()>
		
		<cfif refind("[^a-zA-Z ]", name)>
			<cfset msg.message = "Sooo close.  But module names need to be just alphabetic with possible spaces.">
			<cfset displayObject.sendJson(msg)>
		</cfif>
				
		<cfset moduleFolder = modulesMdl.fixModuleName(name)>
		
		<cfif modulesMdl.isanesmmodule(moduleFolder)>
			<cfset msg.message = "Module already exists. Your probably already done!">
			<cfset displayObject.sendJson(msg)>
		</cfif>
		
		<cfif directoryexists(requestObject.getVar("machineroot") & ModuleFolder)>
			<cfset msg.message = "That directory already exists. Your probably should not f(*&*(&)) with it.">
			<cfset displayObject.sendJson(msg)>
		</cfif>
		
		<cfset more.modulemenuorder = modulesmdl.getNextModuleOrderNo()>

		<cfset moduleMdl.setup(moduleFolder, name, "skeleton", more)>
		
		<cfset userobj.setFlash("Lets Get Started")>
		<cfset msg.relocate = "/esm/module/?n=#ModuleFolder#&refresh=true">

		<cfset displayObject.sendJson(msg)>
	</cffunction>
		
	<cffunction name="saveSimpleModule">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">
		
		<cfset var modulesMdl = getModulesModel(requestObject, userObj)>
        <cfset var moduleMdl = getModuleModel(requestObject, userObj)>
		<cfset var msg = structnew()>
		<cfset var modulename = trim(requestObject.getFormUrlVar("name"))>
		<cfset var tableName = requestObject.getFormUrlVar("table")>
		<cfset var tableLabel = tosingularlabel(tablename)>
		<cfset var more = structnew()>
		
		<cfif refind("[^a-zA-Z ]", modulename)>
			<cfset msg.message = "Sooo close.  But module names need to be just alphabetic with possible spaces.">
			<cfset displayObject.sendJson(msg)>
		</cfif>
				
		<cfset moduleFolder = modulesMdl.fixModuleName(modulename)>
		
		<cfif modulesMdl.isanesmmodule(moduleFolder)>
			<cfset msg.message = "Module already exists. Your probably already done!">
			<cfset displayObject.sendJson(msg)>
		</cfif>
		
		<cfif directoryexists(requestObject.getVar("machineroot") & ModuleFolder)>
			<cfset msg.message = "That directory already exists. Your probably should not f(*&*(&)) with it.">
			<cfset displayObject.sendJson(msg)>
		</cfif>
		
		<cfset more.modelname = table>
		<cfset more.modulemenuorder = modulesmdl.getNextModuleOrderNo()>
		<cfset moduleMdl.setup(moduleFolder, moduleName, "simple", more)>
		<cfset moduleMdl.setFolderName(moduleFolder)>
		<cfset moduleMdl.makeModel(tablename, "true", tablename)>
		<!--- <cfset moduleMdl.makeStartFiles(moduleName, tableName,"simple")> --->
		<cfset moduleMdl.makeSimpleFiles(moduleName, tableName)>
		<cfset userObj.setFlash("Here it is")>
		<cfset msg.relocate = "/esm/module/?n=#ModuleFolder#&refresh=1">

		<cfset displayObject.sendJson(msg)>
	</cffunction>
	
	<cffunction name="saveTest">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">
		
		<cfset var modulesMdl = getModulesModel(requestObject, userObj)>
        <cfset var moduleMdl = getModuleModel(requestObject, userObj)>
		<cfset var msg = structnew()>
		<cfset var testfilename = lcase(trim(requestObject.getFormUrlVar("testfilename")))>
		<cfset var foldername = requestObject.getFormUrlVar("n")>
		<cfset var listomethods = requestObject.getFormUrlVar("listoftestmethods")>
		<cfset var replaceable=structnew()>
		<cfset var listidx = "">
		
		<cfif refind("[^a-zA-Z0-9]", testfilename)>
			<cfset msg.message = "Sooo close.  Test file names need to be just alphamumeric.">
			<cfset displayObject.sendJson(msg)>
		</cfif>
		
		<cfloop list="#listomethods#" index="listidx">
			<cfif NOT refindnocase("^[a-z][a-z0-9_\-]+$", listidx)>
				<cfset msg.message = "Criminy!  method Names must fit standard variable naming conventions(#listidx#).">
				<cfset displayObject.sendJson(msg)>
			</cfif>
		</cfloop>
	
		<cfif NOT modulesMdl.isanesmmodule(foldername)>
			<cfset msg.message = "invalid module!">
			<cfset displayObject.sendJson(msg)>
		</cfif>
		
		<cfset moduleMdl.setFolderName(folderName)>
		
		<cfif moduleMdl.testfileAlreadyExists(testfilename & "test.cfc")>
			<cfset msg.message = "There is already a test file with this name">
			<cfset displayObject.sendJson(msg)>
		</cfif>

		<cfset replaceable.name = testfilename>
		
		<cfset moduleMdl.makeFile("test.cfc", "#testfilename#test.cfc", replaceable)>
		
		<cfloop list="#requestObject.getFormUrlVar("listoftestmethods")#" index="listidx">
				<cfset replaceable = structnew()>
				<cfset replaceable.name = listidx>
				<cfset moduleMdl.addTemplateToFile("testmethod", testfilename & "test.cfc", replaceable, "</cffunction>", "last")>
		</cfloop>
		
		<cfset userobj.setFlash("Test file added")>
		<cfset msg.relocate = "/esm/module/?n=#foldername#">

		<cfset displayObject.sendJson(msg)>
	</cffunction>
	
	<cffunction name="saveAction">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">
		
		<cfset var modulesMdl = getModulesModel(requestObject, userObj)>
        <cfset var moduleMdl = getModuleModel(requestObject, userObj)>
		<cfset var msg = structnew()>
		<cfset var mode = requestObject.getFormUrlVar("mode")>
		<cfset var foldername = requestObject.getFormUrlVar("n")>
		<cfset var modelsToUse = requestObject.getFormUrlVar("modelstouse")>
		<cfset var actionname = "">
		<cfset var replaceable=structnew()>
		<cfset var replaceable2=structnew()>
		<cfset var listidx = "">
		<cfset var ajaxtplt= "">
		<cfset var modelname = "">
		<cfset var actionparts = "">
		<cfif NOT modulesMdl.isanesmmodule(foldername)>
			<cfset msg.message = "invalid module!">
			<cfset displayObject.sendJson(msg)>
		</cfif>
		
		<cfset moduleMdl.setFolderName(folderName)>
		
		<!--- determine action name --->
		<cfswitch expression="#mode#">
			<cfcase value="display">
				<cfset actionname = requestObject.getFormUrlVar("tpltactionname")>
			</cfcase>
			<cfcase value="adhockajax">
				<cfset actionname = requestObject.getFormUrlVar("ahactionname")>
			</cfcase>
			<cfcase value="standardajax">
				<cfset actionparts = requestObject.getFormUrlVar("saactionname")>
				<cfset ajaxtplt = gettoken(actionparts, 1, " ")>
				<cfset modelname = gettoken(actionparts, 2, " ")>
				<cfset actionname = ajaxtplt & modelname>
			</cfcase>
			<cfdefaultcase><cfthrow message="noooooo mode not mapping right -#mode#-"></cfdefaultcase>
		</cfswitch>
		
		<!--- check action name valid --->
		<cfif NOT refindnocase("^[a-z][a-z0-9_\-]+$", actionname)>
			<cfset msg.message = "Ohh Nooooooo!  action names must follow standard variable techniques.">
			<cfset displayObject.sendJson(msg)>
		</cfif>

		<!--- check not already there in xml and methods --->
		<cfif  moduleMdl.controllerHasMethod(actionname)>
			<cfset msg.message = "Whoa baby!  This method already exists in the controller!">
			<cfset displayObject.sendJson(msg)>
		</cfif>
		
		<!--- if mode = template, check template names valid
		<cfloop list="#templates#" index="listidx">
			<cfif NOT refindnocase("^[a-z][a-z0-9_\-]+$", listidx)>
				<cfset msg.message = "Criminy!  method Names must fit standard variable naming conventions(#listidx#).">
				<cfset displayObject.sendJson(msg)>
			</cfif>
		</cfloop> --->

		<cfif mode EQ "display">
			<cfloop list="#requestObject.getFormUrlVar("listoftestmethods")#" index="listidx">
				<cfset replaceable = structnew()>
				<cfset replaceable.name = listidx>
				<cfset moduleMdl.addTemplateToFile("testmethod", testfilename & "test.cfc", replaceable, "</cffunction>", "last")>
			</cfloop>
		</cfif>
		
		<cfif mode EQ "adhockajax">
			<cfset replaceable.actionname = actionname>
			<cfset moduleMdl.addTemplateToFile("ajaxaction", "modulexml.cfm", replaceable, "</module>", "beforefirst")>
			<cfif modelsToUse NEQ "">
				<cfset replaceable.methodcalls = "">
				<cfloop list="#modelsToUse#" index="listidx">
					<cfif NOT moduleMdl.controllerHasMethod(listidx)>
						<cfset replaceable2 = structnew()>
						<cfset replaceable2.modelname = listidx>
						<cfset moduleMdl.addTemplateToFile("controllerfactoryformodelmethod", "controller.cfc", replaceable2, "</cffunction>")>
					</cfif>
					<cfset replaceable.methodcalls = replaceable.methodcalls & moduleMdl.renderTemplateCode("modelfactorycall", replaceable2, "</cffunction>")>
				</cfloop>
			</cfif>
			<cfset moduleMdl.addTemplateToFile("ajaxmethod", "controller.cfc", replaceable, "</cfcomponent>", "beforefirst")>
		</cfif>
		
		<cfif mode EQ "standardajax">
			<cfset replaceable.actionname = actionname>
			<cfset replaceable.modelname = modelname>
			<cfset moduleMdl.addTemplateToFile("ajaxaction", "modulexml.cfm", replaceable, "</module>", "beforefirst")>
			<cfset moduleMdl.addTemplateToFile("#ajaxtplt#method", "controller.cfc", replaceable, "</cfcomponent>", "beforefirst")>
		</cfif>
		
		<cfset userobj.setFlash("Action added")>
		<cfset msg.relocate = "/esm/module/?n=#foldername#">

		<cfset displayObject.sendJson(msg)>
	</cffunction>
	
</cfcomponent>