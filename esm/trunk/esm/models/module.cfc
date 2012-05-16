<cfcomponent name="Module Model" output="false" extends="resources.abstractmodel">

	<cffunction name="init">
		<cfargument name="requestObj" required="true">
		<cfargument name="userObj" required="true">
		<cfset variables.requestObj = arguments.requestObj>
		<cfset variables.userObj = arguments.userObj>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="toSingularLabel">
		<cfargument name="str">
		<cfset str = rereplace(str, "([A-Z])", " \1","all")>
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
	
	<cffunction name="setFolderName">
		<cfargument name="fn">
		<cfset variables.foldername = fn>
	</cffunction>
	
	<cffunction name="setup">
		<cfargument name="foldername" required="true">
		<cfargument name="name" required="true">
		<cfargument name="mode" default="skeleton">
		<cfargument name="more" default="#structnew()#">
	
		<cfset variables.foldername = foldername>
		
		<cfdirectory action="create" directory="#requestObj.getVar("machineroot") & foldername#" mode="644">

		<cfset l.replaceable = structnew()>
		<cfset l.replaceable.name = name>
						
		<cfset makeFile("controller.cfc", "controller.cfc", l.replaceable)>
		<cfif mode EQ "skeleton">
			<cfset l.replaceable.methodname = "startpage">
			<cfset addTemplateToFile("normalmethod", "controller.cfc", l.replaceable, "</cfcomponent>", "beforelast")>
		<cfelseif mode EQ "simple">
			<cfset l.replaceable.modelname = more.modelname>
			<cfset addTemplateToFile("startpagemethod", "controller.cfc", l.replaceable, "</cfcomponent>", "beforelast")>
		</cfif>
		<cfset l.replaceable.menuorder = more.modulemenuorder>
		<cfset makeFile("modulexml.cfm", "modulexml.cfm", l.replaceable)>
	</cffunction>
	
	<cffunction name="hastemplatesdirectory">
		<cfreturn directoryexists(requestObj.getVar("machineroot") & variables.foldername & "/" & "templates")>
	</cffunction>
	
	<cffunction name="hasmodelsdirectory">
		<cfreturn directoryexists(requestObj.getVar("machineroot") & variables.foldername & "/" & "models")>
	</cffunction>
	
	<cffunction name="getControllerCode">
		<cfset var l = structnew()>
		<cfset l.ctrlerpath = requestObj.getVar("machineroot") & variables.foldername & "/controller.cfc">
		<cfif NOT fileexists(l.ctrlerpath)>
			<cfthrow message="invalid controller">
		</cfif>
		<cffile action="read" file="#l.ctrlerpath#" variable="l.file">
		<cfreturn l.file>
	</cffunction>
	
	<cffunction name="controllerHasMethod">
		<cfargument name="m" required="true">
		
		<cfset var l = structnew()>
		
		<cfset l.filestr = getControllerCode()>
		
		<cfif findnocase("<cffunction name=""#m#""", l.filestr)>
			<cfreturn true>
		</cfif>
		
		<cfreturn false>
	</cffunction>
	
	<!--- <cffunction name="addMethodToController">
		<cfargument name="m" required="true">
		
		<cfset var l = structnew()>
		
		<cfset l.filestr = getControllerCode()>
		
		<cfif findnocase("<cffunction name=""#name#""", l.filestr)>
			<cfreturn true>
		</cfif>
		
		<cfreturn false>
	</cffunction> --->
		
	<cffunction name="modelAlreadyExists">
		<cfargument name="name">
		<cfreturn fileexists(requestObj.getVar("machineroot") & variables.foldername & "/models/" & name & ".cfc")>
	</cffunction>
	
	<cffunction name="testFileAlreadyExists">
		<cfargument name="name">
		<cfreturn fileexists(requestObj.getVar("machineroot") & variables.foldername & "/" & name)>
	</cffunction>
	
	<cffunction name="hasunittestfiles">
		<cfset var r = getunittests()>
		<cfreturn yesnoformat(r.recordcount)>
	</cffunction>
	
	<cffunction name="getunittests">
		<cfset var uf = "">
		<cfset var a = arraynew(1)>
		
		<cfdirectory action="list" name="uf" directory="#requestObj.getVar("machineroot") & variables.foldername#" filter="*test.cfc">
	
		<cfloop query="uf">
			<cfset arrayappend(a, replacenocase(name, ".cfc", ""))>
		</cfloop>
		
		<cfset queryaddcolumn(uf, "filename", "VarChar", a)>
	
		<cfreturn uf>
	</cffunction>
	
	<cffunction name="getmodels">
		<cfset var uf = "">
		<cfset var a = arraynew(1)>
		
		<cfif NOT hasmodelsdirectory()>
			<cfset uf = querynew("name")>
		</cfif>
		
		<cfdirectory action="list" name="uf" directory="#requestObj.getVar("machineroot") & variables.foldername & "/models"#" filter="*.cfc">		
		
		<cfloop query="uf">
			<cfset arrayappend(a, replacenocase(name, ".cfc", ""))>
		</cfloop>
		
		<cfset queryaddcolumn(uf, "filename", "VarChar", a)>
		
		<cfreturn uf>
	</cffunction>
	
	<cffunction name="getMethods">
		<cfset var methods = "">
		<cfset var methodsq = querynew("name,isajax")>
		<cfset var xml = "">
		<cfset var midx = "">
		
		<!--- <cfif fileexists(requestObj.getVar("machineroot") & variables.foldername & "/modulexml.cfm")> --->
		<cfset xml = getXML()>
		
		<cfset methods = xmlsearch(xml, "//action")>

		<cfloop from="1" to="#arraylen(methods)#" index="midx">
			<cfset queryaddrow(methodsq)>
			<cfset querysetcell(methodsq, "name", methods[midx].xmlattributes.name)>
			
			<cfset querysetcell(methodsq, "isajax", arraylen(methods[midx].xmlChildren) EQ 0)>
		</cfloop>
		<!--- </cfif> --->
		
		<cfreturn methodsq>
	</cffunction>
	
	<cffunction name="gettemplates">
		<cfset var uf = "">
		<cfset var a = arraynew(1)>
		<cfset var a2 = arraynew(1)>
		<cfset var modulexml = getXML()>
		<cfif NOT hastemplatesdirectory()>
			<cfset uf = querynew("name")>
		</cfif>
		
		<cfdirectory action="list" name="uf" directory="#requestObj.getVar("machineroot") & variables.foldername & "/templates"#" filter="*.cfm">		
		
		<cfloop query="uf">
			<cfset arrayappend(a, replacenocase(name, ".cfm", ""))>
			<cfset found = xmlsearch(modulexml, "//template[@file='#name#']")>
			<cfset arrayappend(a2, yesnoformat(arraylen(found)))>
		</cfloop>
		
		<cfset queryaddcolumn(uf, "filename", "VarChar", a)>
		<cfset queryaddcolumn(uf, "isinxml", "VarChar", a2)>
		
		<cfreturn uf>
	</cffunction>
	
	<cffunction name="templateexists">
		<cfargument name="filename">
		<cfreturn fileexists(requestObj.getVar("machineroot") & variables.foldername & "/templates/" & filename)>
	</cffunction>
		
	<cffunction name="getxml">
		<cfset var modulexml = "">
		<cfif fileexists(requestObj.getVar("machineroot") & "#variables.foldername#/modulexml.cfm")>
			<cfinclude template="../../#variables.foldername#/modulexml.cfm">
		<cfelse>
			<cfset modulexml = xmlNew()>
		</cfif>
		<cfreturn modulexml>
	</cffunction>		
		
	<cffunction name="makefile">
		<cfargument name="patternfile" required="true">
		<cfargument name="targetFile" required="true">
		<cfargument name="replaceable" required="true">
		
		<cfset var l = structnew()>

		<!--- get file contents --->
		<cffile action="read" variable="l.txt" file="#requestObj.getVar("machineRoot") & "esm/patterns/" & patternfile & ".txt"#">

		<cfset l.txt = runReplaceables(l.txt, arguments.replaceable)>
				
		<cfif find("/",arguments.targetfile) AND NOT directoryexists(requestObj.getVar("machineroot")& variables.foldername & "/" & gettoken(arguments.targetfile,1,"/"))>
			<cfdirectory action="create" directory="#requestObj.getVar("machineroot")& variables.foldername & "/" & gettoken(arguments.targetfile,1,"/")#" mode="644">
		</cfif>
		
		<cffile action="write" file="#requestObj.getVar("machineroot") & variables.foldername & "/" & targetFile#" output="#l.txt#">

	</cffunction>
	
	<cffunction name="renderTemplateCode">
		<cfargument name="patternfile" required="true">
		<cfargument name="replaceable" required="true">

		<cfset var l = structnew()>
		
		<!--- get template  contents --->
		<cffile action="read" variable="l.ptxt" file="#requestObj.getVar("machineRoot") & "esm/patterns/" & patternfile & ".txt"#">

		<cfset l.ptxt = runReplaceables(l.ptxt, arguments.replaceable)>
		
		<cfreturn l.ptxt>
	</cffunction>
	
	<cffunction name="addTemplateToFile">
		<cfargument name="patternfile" required="true">
		<cfargument name="targetFile" required="true">
		<cfargument name="replaceable" required="true">
		<cfargument name="targetString" required="true">
		<cfargument name="targetinstance" required="false" default="afterfirst">
		
		<cfset var l = structnew()>

		<cfset l.ptxt = renderTemplateCode(arguments.patternfile, arguments.replaceable, arguments.targetString, arguments.targetInstance)>
		
		<cfset addStringToFile( targetFile, l.ptxt, targetString, targetinstance)>
	</cffunction>
	
	<cffunction name="addStringToFile">
		<cfargument name="targetFile" required="true">
		<cfargument name="str" required="true">
		<cfargument name="targetString" required="true">
		<cfargument name="targetinstance" required="false" default="afterfirst">
		
		<cfset var l = structnew()>
		<cfset l.ptxt = str>
		<cffile action="read" variable="l.ttxt" file="#requestObj.getVar("machineRoot") & variables.foldername & "/" & targetfile#">
		
		<cfif targetinstance EQ "afterfirst">
			<cfset l.ttxt = replacenocase(l.ttxt, arguments.targetstring, arguments.targetstring & chr(13) & chr(10) & l.ptxt, "one")>
		<cfelseif targetinstance EQ "beforefirst">
			<cfset l.ttxt = replacenocase(l.ttxt, arguments.targetstring, l.ptxt &  chr(13) & chr(10) & arguments.targetstring, "one")>
		<cfelseif targetinstance EQ "end">
			<cfset l.ttxt = l.ttxt & chr(13) & chr(10) & l.ptxt>
		<cfelseif targetinstance EQ "beforelast">
			<!--- find last occurance and use that to replace --->
			<cfset l.lastidxlp = findnocase(arguments.targetstring, l.ttxt, 0)>
			<cfset l.lastidx = l.lastidxlp>
			<cfloop condition="l.lastidxlp GT 0">
				<cfset l.lastidxlp = findnocase(arguments.targetstring, l.ttxt, l.lastidxlp +1)>
				<cfif l.lastidxlp NEQ 0>
					<cfset l.lastidx = l.lastidxlp>
				</cfif>
			</cfloop>
			<cfif l.lastidx NEQ 0>
				<cfset l.ttxt = left(l.ttxt, l.lastidx -1) & l.ptxt & mid(l.ttxt, l.lastidx, len(l.ttxt) )>
			</cfif>
		<cfelse><!--- afterlast --->
			<!--- find last occurance and use that to replace --->
			<cfset l.lastidxlp = findnocase(arguments.targetstring, l.ttxt, 0)>
			<cfset l.lastidx = l.lastidxlp>
			<cfloop condition="l.lastidxlp GT 0">
				<cfset l.lastidxlp = findnocase(arguments.targetstring, l.ttxt, l.lastidxlp +1)>
				<cfif l.lastidxlp NEQ 0>
					<cfset l.lastidx = l.lastidxlp>
				</cfif>
			</cfloop>
			<cfif l.lastidx NEQ 0>
				<cfset l.ttxt = left(l.ttxt, l.lastidx -1) & arguments.targetstring & l.ptxt & mid(l.ttxt, l.lastidx + len(arguments.targetstring), len(l.ttxt) )>
			</cfif>
		</cfif>
				
		<cffile action="write" file="#requestObj.getVar("machineRoot") & variables.foldername & "/" & targetfile#" output="#trim(l.ttxt)#" mode="644">

	</cffunction>
	
	<cffunction name="runReplaceables">
		<cfargument name="txt" required="true">
		<cfargument name="replaceables" required="true">
		
		<cfset var l = structnew()>
		
		<cfset replaceables.foldername = variables.foldername>
		
		<!--- iterate replaceables --->
		<cfset l.re = "{[a-zA-z0-9]+}">
		<cfset l.reresults = refindnocase(l.re, txt, 0, true)>

		<cfloop condition="l.reresults.pos[1] NEQ 0">
			<cfset l.str = mid(txt, l.reresults.pos[1] + 1, l.reresults.len[1]-2)>

			<cfif structkeyexists(replaceables, l.str)>
				<cfset l.rs = replaceables[l.str]>
			<cfelse>
				<cfset l.rs = "">
			</cfif>

			<cfset 	txt = mid(txt, 1, l.reresults.pos[1] -1)
							& l.rs
							& mid(txt, l.reresults.pos[1] + l.reresults.len[1], len(txt)
			)>
		
			<cfset l.reresults = refindnocase(l.re, txt, 0, true)>
		</cfloop>
		
		<cfreturn txt>
	</cffunction>	
	
	<cffunction name="getFormStr">
		<cfargument name="varname" required="true">
		<cfargument name="label" required="true">
		<cfargument name="modelname" required="true">
		
		<cfset var s = "">
		<cfset var r = structnew()>
		
		<cfset r.varname = varname>
		<cfset r.label = toSingularLabel(label)>
		<cfset r.modelname = modelname>
		
		<cfif refindnocase(".id$",varname)>
			<cfset s = renderTemplateCode("formselectcall", r)>
		<cfelseif refindnocase("ids$",varname)>
			<cfset s = renderTemplateCode("formlistmanagercall", r)>
		<cfelseif refindnocase("^id$",varname)>
			<cfset s = renderTemplateCode("formhiddencall", r)>
		<cfelseif findnocase("date",varname)>
			<cfset s = renderTemplateCode("formdatecall", r)>	
		<cfelseif refindnocase("(blurb|text)", varname)>
			<cfset s = renderTemplateCode("formtextareacall", r)>
		<cfelseif refindnocase("html", varname)>
			<cfset s = renderTemplateCode("formwysiwygcall", r)>
		<cfelse>
			<cfset s = renderTemplateCode("formtextcall", r)>
		</cfif>
		
		<cfreturn s>
	</cffunction>
	
	<cffunction name="getTableJson">
		<cfargument name="tableName" required="true">
		
		<cfset var tableMdl = createObject("component","resources.orm.start").init(requestObj,userObj)>
		<cfset var tableInfo = tableMdl.getTableFields(tableName)>
		<cfset var jsonObj = createObject("component","utilities.json")>
		<cfset var ps = structnew()>
		
		<cfset ps.tablename = tableName>
		<cfset ps.fields = structnew()>
		
		<cfloop query="tableInfo">
			<cfset tmp = structnew()>
			<cfif NOT listfindnocase("id", tableinfo.name)>
				<cfswitch expression="#type#">
					<cfcase value="varchar,nvarchar">
						<cfset tmp.type = "varchar">
						<cfset tmp.maxlen = length>
						<cfset tmp.validation = "maxlength,notblank">
					</cfcase>
					<cfcase value="text,ntext">
						<cfset tmp.type= "varchar">
						<cfset tmp.validation = "notblank">
					</cfcase>
					<cfcase value="float">
						<cfset tmp.type= "real">
						<cfset tmp.validation = "isnumber">
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
	
				<cfset tmp.label = tosingularlabel(tableinfo.name)>
				<cfset ps.fields[tableinfo.name] = tmp>
			</cfif>
			
		</cfloop>
		<cfset ps = jsonObj.encode(ps)>
		<cfset ps = replace(ps, "{", "{#chr(10)##chr(9)#")>
		<cfset ps = replace(ps, """FIELDS"":{", "#chr(10)##chr(9)#""FIELDS"":{#chr(10)##chr(9)##chr(9)#")>
		<cfset ps = rereplace(ps, 'LABEL"([^}]+)},', "LABEL""\1},#chr(10)##chr(9)##chr(9)#", "all")>
		
		<cfset ps = replace(ps, "}}}", "}#chr(10)##chr(9)#}#chr(10)#}")>
		<cfreturn ps>
	</cffunction>
	
	<cffunction name="makeModel">
		<cfargument name="modelname" required="true">
		<cfargument name="hasfactory" required="true">
		<cfargument name="tablename" default="">
		
		
		<cfset var jsonObj = createObject("component","utilities.json")>
		<cfset var tableInfo = "">
		<!--- <cfset var name = requestObj.getFormUrlVar("n")> --->
		<cfset var ps = structnew()>
		<cfset var tmp = "">
		<cfset var repleaceable = structnew()>

		
		<cfif tablename NEQ "">
			<cfset ps = getTableJson(tablename)>
			<!--- <cfset structdelete(ps.fields, "id")> --->
	
			<!--- <cfset ps = jsonObj.encode(ps)> --->
			<cfset replaceable.tablemetadata = "<cfset setTableMetaData('" & ps & "')>">
			<cfset replaceable.modelname = modelname>
			<cfset makeFile("model.cfc", "models/#replaceable.modelname#.cfc", replaceable)>

		<cfelse>
			<cfset replaceable.modelname = modelname>		
			<cfset makeFile("model.cfc", "models/#replaceable.modelname#.cfc", replaceable)>
		</cfif>
		
		<cfif hasfactory AND NOT controllerHasMethod("get" & modelname & "Model")>
			<cfset replaceable = structnew()>
			<cfset replaceable.modelname = modelname>
			<cfset addTemplateToFile("controllerfactoryformodelmethod", "controller.cfc", replaceable, "</cffunction>")>
		</cfif>
		
	</cffunction>
	
	<cffunction name="getFormItemString">
		<cfargument name="tablename" default="">
		<cfargument name="modelname">
		
		<cfset var tableMdl = createObject("component","resources.orm.start").init(requestObj,userObj)>
		<cfset var ps = structnew()>
		<cfset var tmp = "">
		<cfset var repleaceable = structnew()>
		<cfset var tableInfo = tableMdl.getTableFields(tableName)>
		<cfset var fieldlist = "">
		<cfset var field = "">
		<cfset var rstring = "">
		
		<cfloop query="tableInfo">
			<cfif NOT listfind("created,deleted,modified,changedby,name", tableinfo.name)>
				<cfset fieldlist = listappend(fieldlist, tableinfo.name)>
			</cfif>
			<!---
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
			--->
		</cfloop>

		<cfloop list="#fieldlist#" index="field">
			<!--- <cfset l.replaceable.varnames = l.replaceable.varnames  & moduleMdl.renderTemplateCode("getdataitemcall", l.replaceable2)> --->
			<cfset rstring = rstring & getFormStr(field, field, modelname)>
		</cfloop>
			
		<!--- <cfset structdelete(ps.fields, "id")> --->
		<cfreturn rstring>
	</cffunction>
	
	<!---
	<cffunction name="makeStartFiles">
		<cfargument name="moduleName" required="true">
		<cfargument name="tableName" required="true">
		<cfargument name="mode" default="simple">
		
		<cfset var r = structnew()>
		<!--- start page --->
		<cfset r.moduleName = moduleName>
		<cfset makefile("starttitletemplate.cfm", "templates/starttitle.cfm", r)>
		<cfset makefile("startcontentstemplate.cfm", "templates/startcontents.cfm", r)>
	
		<!--- browse --->
		<cfset makefile("browselisttemplate.cfm", "templates/browse.cfm", r)>
		<cfset r = structnew()>
		<cfset addTemplateToFile("browsemethod", "controller.cfc", r, "<cffunction>", "afterlast")>
		<cfset r.methodname = "browse">
		<cfset addTemplateToFile("actionmethod", "modulexml.cfm", r, "</module>", "beforelast")>
	
	</cffunction>
	--->
	
	<cffunction name="makeSimpleFiles">
		<cfargument name="moduleName" required="true">
		<cfargument name="tableName" required="true">

		<cfset var modelname = tosingular(tablename)>
		<cfset var r = structnew()>
		<cfset r.moduleName = moduleName>
		<cfset r.modelname = modelname>
		<cfset r.tablename = tablename>
		
		<!--- methods --->
		<cfset addTemplateToFile("addmethod", "controller.cfc", r, "</cffunction>", "afterlast")>
		<cfset addTemplateToFile("editmethod", "controller.cfc", r, "</cffunction>", "afterlast")>
		<cfset addTemplateToFile("deletemethod", "controller.cfc", r, "</cffunction>", "afterlast")>
		<cfset addTemplateToFile("savemethod", "controller.cfc", r, "</cffunction>", "afterlast")>
		<cfset addTemplateToFile("searchmethod", "controller.cfc", r, "</cffunction>", "afterlast")>
		
		<!--- actions add{tablename}, edit{tablename}, save{tablename} --->
		
		<cfset addTemplateToFile("addaction", "modulexml.cfm", r, "</action>", "afterlast")>
		<cfset addTemplateToFile("editaction", "modulexml.cfm", r, "</action>", "afterlast")>
		<cfset addTemplateToFile("searchaction", "modulexml.cfm", r, "</action>", "afterlast")>
		<cfset r.actionname = "save" & modelname>
		<cfset addTemplateToFile("ajaxaction", "modulexml.cfm", r, "</action>", "afterlast")>
		<cfset r.actionname = "delete" & modelname>
		<cfset addTemplateToFile("ajaxaction", "modulexml.cfm", r, "</action>", "afterlast")>
		
		<!--- templates form{tablename},label{tablename},title{tablename},history--->
		<cfset r.formitems = getFormItemString(tablename, modelname)>
		<cfset makefile("formtemplate.cfm", "templates/form#modelname#.cfm", r)>
		<cfset makefile("formtitletemplate.cfm", "templates/title#modelname#.cfm", r)>
		<cfset makefile("formtitlebuttonstemplate.cfm", "templates/buttons#modelname#.cfm", r)>
		<cfset makefile("recentactivitytemplate.cfm", "templates/recentactivity.cfm", r)>
		<cfset makefile("historytemplate.cfm", "templates/history.cfm", r)>
		
		<!--- startgen --->
		<cfset r.moduleName = moduleName>
		<cfset makefile("starttitletemplate.cfm", "templates/starttitle.cfm", r)>
		<cfset makefile("startcontentstemplate.cfm", "templates/startcontents.cfm", r)>
	
		<!--- search  --->
		<cfset makefile("searchtitletemplate.cfm", "templates/searchtitle.cfm", r)>
		<cfset makefile("searchcontentstemplate.cfm", "templates/search.cfm", r)>
		<cfset makefile("searchcontentsresultstemplate.cfm", "templates/searchresults.cfm", r)>
		
		<!--- browse --->
		<cfset makefile("browselisttemplate.cfm", "templates/browse.cfm", r)>
		<cfset addTemplateToFile("browsemethod", "controller.cfc", r, "</cffunction>", "afterlast")>
		<cfset r.actionname = "browse">
		<cfset addTemplateToFile("ajaxaction", "modulexml.cfm", r, "</action>", "afterlast")>
	
	</cffunction>
</cfcomponent>