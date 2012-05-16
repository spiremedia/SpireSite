<cfcomponent name="contentObjectEditor" output="false">
	
	<cffunction name="init">
		<cfargument name="requestObj" required="true">
		<cfargument name="userObj" required="true">
		<cfargument name="info" required="true">
		
		<cfset variables.requestObj = arguments.requestObj>
		<cfset variables.userObj = arguments.userObj>
		<cfset variables.widgetInfo = deserializeJSON(info)>
		<cfset variables.widgetData = structnew()>
		
		<cfif requestObj.isFormUrlVarSet("view") AND requestObj.getFormUrlVar("view") EQ 'block'>
			<cfset variables.po = createObject("component", "resources.stagedBlockObjectsModel").init(requestObj, userObj)>
			<cfset variables.po.attachObserver(createObject("component", "resources.BlockObjectsLog").init(requestObj, userObj))>
		<cfelse>
			<cfset variables.po = createObject("component", "resources.pageObjectsModel").init(requestObj, userObj)>
			<cfset variables.po.attachObserver(createObject("component", "resources.BlockObjectsLog").init(requestObj, userObj))>
		</cfif>
		
		<cfif NOT variables.requestObj.isformurlvarset('id')>
				Please go back and select an item to edit first por favor.<cfabort>
		</cfif>
		
		<cfset loadItem(variables.requestObj.getFormUrlVar('id'))>

		<cfreturn this>
	</cffunction>
	
	<cffunction name="getInfo">
		<cfreturn variables.widgetData>
	</cffunction>
	
	<cffunction name="setValues">
		<cfargument name="data" required="yes">
	
		<cfset var l = structnew()>
		
		<!--- not all editable modules expose a title --->
		<cfif structkeyexists(data, "title")>
			<cfset variables.widgetData['title'] = data.title>
		</cfif>
		
		<!--- filter out non relevant fields by transfering the relevant ones to widgetdata --->
		<cfloop collection="#variables.widgetInfo.fields#" item="l.widx">
			<cfif structkeyexists(data, l.widx)>
				<cfset variables.widgetData[l.widx] = data[l.widx]>
			</cfif>
		</cfloop>
        
		<!--- add a where clause if it exists to select the right item to update --->
        <cfif structkeyexists(arguments.data, "where")>
        	<cfset variables.widgetData.where = arguments.data.where>
        </cfif>
	</cffunction>
	
	<cffunction name="getValidator">
		<cfif structkeyexists(variables, "vdtr")>
			<cfreturn variables.vdtr>
		<cfelse>
			<cfset variables.vdtr = createObject("component","utilities.datavalidator").init()>
			<cfreturn variables.vdtr>
		</cfif>
	</cffunction>
	
	<cffunction name="loadItem" output="false">
		<cfargument name="id" required="true">
				
		<cfset var l = structnew()>
		<cfset var m = structnew()>
		
		<cfset m.status = 'staged'>
		
		<cfif NOT variables.po.load(id, m)>
			<cfthrow message="Pageobject id = #id# not found">
		</cfif>
		
		<cfif variables.po.getData() NEQ "">
			<cfset structappend( variables.widgetData, deserializeJSON( variables.po.getData() ) )>
		</cfif>
			
		<cfset variables.widgetData.id = variables.po.getid()>
		<cfset variables.widgetData.name = variables.po.getname()>
		<cfset variables.widgetData.title = variables.po.getTitle()>
		<cfset variables.widgetData.module = variables.po.getmodule()>
		
		<cfif variables.po.hasField("pageid")>
			<cfset variables.widgetData.pageid = variables.po.getpageid()>
		</cfif>
	
		<!--- this loop does some proceesing of the widgetdata in relation to the json input structure, preformatting some default values, etc --->
		<cfloop collection="#variables.widgetInfo.fields#" item="l.widgetItem">
			<cfif structkeyexists(variables.widgetData, l.widgetItem)>
				<cfif structkeyexists(variables.widgetInfo.fields[l.widgetItem],"parseforwysiwyg") AND variables.widgetInfo.fields[l.widgetItem].parseforwysiwyg>
					<cfset variables.widgetData[l.widgetItem] = getparserforwysiwyg().preprocessforwysywig(variables.widgetData[l.widgetItem])>
				</cfif>
			<cfelse>
				<cfif structkeyexists(variables.widgetInfo.fields[l.widgetItem], "default")>
					<cfset variables.widgetData[l.widgetItem] = variables.widgetInfo.fields[l.widgetItem].default>
				<cfelseif structkeyexists(variables.widgetInfo.fields[l.widgetItem], "defaulttype")>
					<cfif variables.widgetInfo.fields[l.widgetItem].defaulttype EQ "array">
						<cfset variables.widgetData[l.widgetItem] = arraynew(1)>
					<cfelseif variables.widgetInfo.fields[l.widgetItem].defaulttype EQ "struct">
						<cfset variables.widgetData[l.widgetItem] = structnew()>
					<cfelse>
						<cfthrow message="defaulttype #variables.widgetInfo.fields[l.widgetItem].defaulttype# not supported">
					</cfif>
				<cfelse>
					<cfset variables.widgetData[l.widgetItem] = "">
				</cfif>
			</cfif>
		</cfloop>
	</cffunction>

	<cffunction name="save">
		<cfset var tmp = structnew()>
		<cfset var l = structnew()>
		
		<cfif structkeyexists(variables, "preSave")>
			<cfset variables.preSave()>
		</cfif>
   				
		<!--- PACKAGE STRUCT INFO TO JSON STRING AND SET TO MODEL --->
		<cfloop collection="#variables.widgetInfo.fields#" item="l.widgetItem">
			<cfif structkeyexists(variables.widgetInfo.fields[l.widgetItem],"parseforwysiwyg") AND variables.widgetInfo.fields[l.widgetItem].parseforwysiwyg>
				<cfset tmp[l.widgetItem] = getparserforwysiwyg().postprocessfromwysywig( variables.widgetData[l.widgetItem] )>
			<cfelse>
				<cfset tmp[l.widgetItem] = variables.widgetData[l.widgetItem]>
			</cfif>
		</cfloop>
		
		<cfset validateSave()>
		
		<cfif NOT getValidator().passValidation()>
			<cfreturn false>
		</cfif>

		<cfif structkeyexists(variables.widgetData, "title")>
			<cfset variables.po.setTitle(variables.widgetData.title)>
		</cfif>
		
		<cfset variables.po.setData(serializeJSON(tmp))>

        <cfset l.where = structnew()>
		<cfif structkeyexists(variables.widgetdata,"where")><!--- incorporates previous where data --->
            <cfset l.where.where = variables.widgetData.where>
		</cfif>
		<cfset l.where.where.status = 'staged'><!--- force to only update against staged object --->
        <cfset variables.po.setValues(l.where)>
			
		<cfif variables.po.save()>
			<cfreturn true>
		<cfelse>
			<cfset variables.vdtr = variables.po.getValidator()>
		</cfif>
		
	</cffunction>
	
	<cffunction name="validateSave">
		<cfset var vdtr = getValidator()>
		<cfset var l = structnew()>
		<!--- loop thru items here --->
		<cfloop collection="#variables.widgetInfo.fields#" item="l.widgetItem">
			<cfset l.fieldVal = variables.widgetdata[l.widgetItem]>
			<cfif structkeyexists(variables.widgetInfo.fields[l.widgetItem],"validation")><!--- has validation --->
				<cfloop list="#variables.widgetInfo.fields[l.widgetItem].validation#" index="l.vitem">
					<!--- determine validation method and error string --->
					<cfif find(":", l.vitem)>
						<cfset l.vmethod = gettoken(l.vitem, 1)>
						<cfset l.vtext = gettoken(l.vitem, 2)>
					<cfelse>
						<cfset l.vmethod = l.vitem>
						<cfset l.vtext = vdtr.getDefaultMessage(l.vmethod)>
					</cfif>
					
					<!--- determine label --->
					<cfif structkeyexists(variables.widgetInfo.fields[l.widgetItem], "label")>
						<cfset l.text = variables.widgetInfo.fields[l.widgetItem].label & " " & l.vtext>
					<cfelse>
						<cfset l.text = l.fieldname & " " & l.vtext>
					</cfif>
					
					<cfswitch expression="#l.vmethod#">
						<cfcase value="maxlength">
							<cftry><!--- WAS FIELDNAME --->
							<cfset vdtr.maxLength(	l.WIDGETITEM, 
													tabledata.fields[l.WIDGETITEM].maxlen,
													l.fieldval,
													l.text)>
													<cfcatch>
														<cfdump var=#l#>
														<cfdump var=#cfcatch#><cfabort>
													</cfcatch>
							</cftry>
						</cfcase>
						<cfdefaultcase>
							<cfinvoke component="#vdtr#" method="#l.vmethod#">
								<cfinvokeargument name="field" value="#l.widgetItem#">
								<cfinvokeargument name="val" value="#l.fieldval#">
								<cfinvokeargument name="text" value="#l.text#">
							</cfinvoke>
						</cfdefaultcase>
					</cfswitch>
				</cfloop>
			</cfif>
		</cfloop>
		
		<cfreturn vdtr>
	</cffunction>
	
	<cffunction name="delete">
		<cfargument name="id" required="true">
		<cfset var lcl = structnew()>
		<cfset variables.po.load(id)>
		
		<!--- lcl VALIDATION --->
		<cfset validateDelete(id)>
		
		<cfif NOT variables.vdtr.passValidation()>
			<cfreturn false>
		</cfif>
		
		<cfif variables.po.delete(id)>
			<cfset lcl.nestedpos = variables.po.getByPageId(id)>
			<cfloop query="lcl.nestedpos">
				<cfset variables.po.delete(lcl.nestedpos.id)>
			</cfloop>
			<cfreturn true>
		<cfelse>
			<cfset variables.vdtr = variables.po.getValidator()>
			<cfreturn false>
		</cfif>

	</cffunction>
	
	<cffunction name="validateDelete">
		<cfset var vdtr = getValidator()>
		<!--- loop thru items here --->
		<cfreturn vdtr>
	</cffunction>
	
	<!---
		<cffunction name="getID" output="false">
			<cfreturn variables.id>
		</cffunction>
		
		<cffunction name="validate">		
			<cfset var lcl = structnew()>
			<cfset var vdtr = createObject('component','utilities.datavalidator').init()>	
			<cfreturn vdtr/>
		</cffunction>
		
		<cffunction name="save">
			<cfset var mydata = structnew()>
			<cfset saveData(mydata)>
		</cffunction>
	
		<cffunction name="deleteItem" output="false">
			<cfargument name="id" required="true">
			
			<cfquery name="g" datasource="#variables.request.getvar('dsn')#">
				DELETE FROM pageObjects
				WHERE id = <cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_varchar"> 
				AND  siteid = <cfqueryparam value="#userobj.getCurrentSiteId()#" cfsqltype="cf_sql_varchar">
			</cfquery>
			
			<cfset description = "Removed module ""#variables.module#"" from location ""#variables.name#"".">
			
			<cfquery name="g2" datasource="#variables.request.getvar('dsn')#">
				INSERT INTO  sitepages_log (
					id,
					userid,
					pageid,
					description,
					siteid
				) VALUES (
					<cfqueryparam value="#createuuid()#" cfsqltype="cf_sql_varchar">,
					<cfqueryparam value="#variables.userObj.getUserId()#" cfsqltype="cf_sql_varchar">,
					<cfqueryparam value="#variables.pageid#" cfsqltype="cf_sql_varchar">,
					<cfqueryparam value="#description#" cfsqltype="cf_sql_varchar">,
					<cfqueryparam value="#variables.userObj.getCurrentSiteId()#" cfsqltype="cf_sql_varchar">
				)
			</cfquery>
			
		</cffunction>
	
		<cffunction name="saveData" output="false">
			<cfargument name="data" required="true">
			<cfset var json = createObject('component','utilities.json')>
			<cfset var localdata = json.encode(data)>
			<cfset var description = "">
			
			<cfquery name="g" datasource="#variables.request.getvar('dsn')#">
				UPDATE pageObjects SET data = <cfqueryparam value="#localdata#" cfsqltype="cf_sql_longvarchar">
				WHERE id = <cfqueryparam value="#variables.id#" cfsqltype="cf_sql_varchar"> 
					AND status = 'staged'
			</cfquery>
			
			<cfset description = "Updated module ""#variables.module#"" in location ""#variables.name#"".">
			
			<cfquery name="g2" datasource="#variables.request.getvar('dsn')#">
				INSERT INTO  sitepages_log (
					id,
					userid,
					pageid,
					description,
					siteid
				) VALUES (
					<cfqueryparam value="#createuuid()#" cfsqltype="cf_sql_varchar">,
					<cfqueryparam value="#variables.userObj.getUserId()#" cfsqltype="cf_sql_varchar">,
					<cfqueryparam value="#variables.pageid#" cfsqltype="cf_sql_varchar">,
					<cfqueryparam value="#description#" cfsqltype="cf_sql_varchar">,
					<cfqueryparam value="#variables.userObj.getCurrentSiteId()#" cfsqltype="cf_sql_varchar">
				)
			</cfquery>
	
		</cffunction>
    --->
   
	<cffunction name="getparserforwysiwyg">
		<cfif NOT structkeyexists(variables, "wysiwygparser")>
			<cfset variables.wysiwygparser = createobject('component','utilities.embeddedlinksandassetsparser').init(requestObj)>
		</cfif>
		<cfreturn variables.wysiwygparser>
	</cffunction>
	
	<cffunction name="getParsedParameterList" output="false">
    	<!--- thsi function parses the formurl var parameterlist isn --->
		<cfset var lcl = structnew()>
		
		<cfif NOT variables.requestObj.isFormUrlVarSet('parameterlist')>
        	<cfreturn lcl>
        </cfif>
        
        <cfset lcl.items = structnew()>
        <cfset lcl.pa = listtoarray(variables.requestObj.getFormUrlVar('parameterlist'),",")>
        <cfloop array="#lcl.pa#" index="lcl.itm">
        	<cfif find('=', lcl.itm)>
            	<cfset lcl.items[gettoken(lcl.itm, 1,"=")] = gettoken(lcl.itm, 2,"=")>
            <cfelse>
            	<cfset lcl.items[lcl.itm] = 1>
            </cfif>
        </cfloop>
        
        <cfreturn lcl.items>
	</cffunction>
	
	<cffunction name="onmissingmethod" output="false">
		<cfargument name="missingMethodName" type="string">
		<cfargument name="missingMethodArguments" type="struct"> 
		
		<!--- get --->
		<cfif refindnocase("^get", missingMethodName)>
			<cfif structkeyexists(variables.widgetData, mid(missingMethodName,4,len(missingMethodName)))>
				<cfreturn variables.widgetData[mid(missingMethodName, 4, len(missingMethodName))]>
			<cfelse>
				<cfthrow message="invalid get* request on '#mid(missingMethodName,4,len(missingMethodName))#'">
			</cfif>
		</cfif>
		
		<!--- hasField --->
		<cfif missingMethodName EQ "hasField">
			<cfif  structkeyexists(variables.widgetdata, missingMethodArguments[1])>
				<cfreturn true>
			<cfelse>
				<cfreturn false>
			</cfif>
		</cfif>
	
		<!--- getField --->
		<cfif missingMethodName EQ "getField">
			<cfif structkeyexists(variables.widgetdata, missingMethodArguments[1])>
				<cfreturn variables.widgetdata[missingMethodArguments[1]]>
			<cfelse>
				<cfthrow message="invalid getField request '#missingMethodArguments[1]#'">
			</cfif>
		</cfif>
	
		<!--- set --->
		<cfif refindnocase("^set", missingMethodName)>
			<cfif structkeyexists(variables.widgetdata, mid(missingMethodName,4,len(missingMethodName)))>
				<cfset variables.widgetdata[mid(missingMethodName,4,len(missingMethodName))] = missingMethodArguments[1]>
			<cfelse>
				<cfthrow message="invalid set* operation on '#mid(missingMethodName,4,len(missingMethodName))#'">
			</cfif>
		</cfif>
		
		<cfthrow message ="function #missingmethodName# does not exist">
		
	</cffunction>

	<cffunction name="dump">
		<cfdump var=#variables.widgetdata#>
		<cfabort>
	</cffunction>
</cfcomponent>