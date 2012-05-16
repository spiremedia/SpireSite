<cfcomponent name="model" output="false">
	<cfset variables.itemdata = structnew()>
	
	<cffunction name="dump">
		<cfdump var="#variables.itemdata#">
		<cfabort>
	</cffunction>
	
	<cffunction name="clear" output="false">
		<cfif structkeyexists(variables, "itemdata")>
			<cfset structclear(variables.itemdata)>
		</cfif>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="attachObserver" output="false">
		<cfargument name="observer" required="true">
		<cfif not isdefined('variables.observers')>
			<cfset variables.observers = arraynew(1)>
		</cfif>
		<cfset arrayappend(variables.observers, arguments.observer)>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="observeEvent" output="false">
		<cfargument name="eventName">
		<cfargument name="more">
		<cfif structkeyexists(variables, "observers")>
			<cfloop from="1" to="#arraylen(variables.observers)#" index="i">
				<cfset variables.observers[i].event(arguments.eventName, this, more)>
			</cfloop>
		</cfif>
		<cfreturn this>
	</cffunction>
		
	<cffunction name="startOrm">
		<cfargument name="tablename" required="true">
		<cfargument name="more" default="#structnew()#">
		<cfset variables.orm = createobject('component', 'resources.orm.start').init(variables.requestObject, tablename	)>
	</cffunction>
		
	<cffunction name="getValidator" output="false">
		<cfif structkeyexists(variables, "vdtr")>
			<cfreturn variables.vdtr>
		<cfelse>
			<cfset variables.vdtr = createObject('component','utilities.datavalidator').init()>
			<cfreturn variables.vdtr>
		</cfif>
	</cffunction>
	
	<cffunction name="validateSave" output="false">
		<cfset var tabledata = variables.orm.getTableData()>
		<cfset var l = structnew()>
		<cfset variables.vdtr = getValidator()>

		<cfif NOT structkeyexists(variables, "orm")>
			<cfthrow message="No orm to validate against">
		</cfif>

		<cfloop collection="#tabledata.fields#" item="l.fieldname">
			<cfif structkeyexists(variables.itemdata, l.fieldname)><!--- ispresent --->
				<cfset l.fieldVal = variables.itemdata[l.fieldname]>
				<cfif structkeyexists(tabledata.fields[l.fieldname],"validation")><!--- has validation --->
					<cfloop list="#tabledata.fields[l.fieldname].validation#" index="l.vitem">
						<cfif find(":", l.vitem)>
							<cfset l.vmethod = gettoken(l.vitem, 1)>
							<cfset l.vtext = gettoken(l.vitem, 2)>
						<cfelse>
							<cfset l.vmethod = l.vitem>
							<cfset l.vtext = vdtr.getDefaultMessage(l.vmethod)>
						</cfif>
						
						<cfif structkeyexists(tabledata.fields[l.fieldname],"label")>
							<cfset l.text = tabledata.fields[l.fieldname]["label"] & " " & l.vtext>
						<cfelse>
							<cfset l.text = l.fieldname & " " & l.vtext>
						</cfif>
						
						<cfswitch expression="#l.vmethod#">
							<cfcase value="maxlength">
								<cfset vdtr.maxLength(	l.fieldname, 
														tabledata.fields[l.fieldname].maxlen,
														l.fieldval,
														l.text)>
							</cfcase>
							<cfdefaultcase>
								<cfinvoke component="#vdtr#" method="#l.vmethod#">
									<cfinvokeargument name="field" value="#l.fieldname#">
									<cfinvokeargument name="val" value="#l.fieldval#">
									<cfinvokeargument name="text" value="#l.text#">
								</cfinvoke>
							</cfdefaultcase>
						</cfswitch>
					</cfloop>
				</cfif>
			</cfif>
		</cfloop>

		<cfreturn vdtr>
	</cffunction>
	
	<cffunction name="validateDelete" output="false">
		<cfset variables.vdtr = getValidator()>
	</cffunction>
	
	<cffunction name="validateDestroy" output="false">
		<cfset variables.vdtr = getValidator()>
	</cffunction>
	
	<cffunction name="setvalues" output="false">
		<cfargument name="itemdata">

		<cfparam name="variables.itemdata" default="#structnew()#">
		<cfset structappend(variables.itemdata, arguments.itemdata)>	
        
		<cfreturn this>
	</cffunction>
	
	<cffunction name="setField">
		<cfargument name="name" required="true">
		<cfargument name="val" required="true">

		<cfparam name="variables.itemdata" default="#structnew()#">
		
		<cfset variables.itemdata[name] = val>	
	</cffunction>
	
	<cffunction name="hasField">
		<cfargument name="fieldname" required="true">

		<cfif (structkeyexists(variables, "orm") AND variables.orm.hasfield(arguments.fieldname))
				OR structkeyexists(variables.itemdata, arguments.fieldname)>
			<cfreturn true>
		<cfelse>
			<cfreturn false>
		</cfif>
	</cffunction>
	
	<cffunction name="getField">
		<cfargument name="fieldname" required="true">
		
		<cfif NOT hasField(fieldname)>
			<cfthrow message="getField : #fieldname# does not exist">
		</cfif>
		
		<cfif structkeyexists(variables.itemdata, fieldname)>
			<cfreturn variables.itemdata[fieldname]>
		<cfelse>
			<cfreturn "">
		</cfif>

	</cffunction>
	
	<cffunction name="getvalues">
		<cfparam name="variables.itemdata" default="#structnew()#">
		<cfreturn variables.itemdata>	
	</cffunction>
	
	<!--- TODO:doesnt belong here like this --->
	<cffunction name="getTaxonomyObj">
		<cfargument name="id" default="#this.getID()#">
		<cfif NOT structkeyexists(variables, "taxonomyObj")>
			<cfset variables.taxonomyObj = createObject("component","modules.taxonomies.models.taxonomies").init(requestObject).loadById(arguments.id)>
		</cfif>
		<cfreturn variables.taxonomyObj/>
	</cffunction>
	
	<cffunction name="load">
		<cfargument name="id" required="true">
		<cfset var s = structnew()>
		<cfset var r = "">
		<cfif NOT isdefined("variables.orm")>
			<cfthrow message="Cannot load if orm not loaded">
		</cfif>
		
		<cfparam name="variables.itemdata" default="#structnew()#">
		<cfset s.tablename = variables.orm.getTableName()>
		<cfset s.tabledata = variables.orm.getTableData()>
		
		<!--- get --->
		<cfset r = variables.orm.getBy("id", arguments.id)>
		
		<!--- gethabtm lists and set as itemdata keys--->
		<cfif structkeyexists(s.tabledata, "habtm")>
			<cfloop collection="#s.tabledata.habtm#" item="s.itm">
				<cfset s.thistable = s.tablename>
				<cfset s.thiskey = variables.orm.singularize(s.thistable) & "id">
				<cfset s.thattable = gettoken(s.itm, 2, ".")>
				<cfset s.thatkey = variables.orm.singularize(s.thattable) & "id">
				<cfset s.formkey = s.thatkey & "s"><!--- plural --->
				
				<cfif structkeyexists(s.tabledata.habtm[s.itm], "via")><!--- path to linking object is provided by via key of habbtm struct --->
					<cfset s.linkObj = createObject("component","#replacenocase(s.tabledata.habtm[s.itm].via, ".", ".models.")#").init(requestObj, userObj)>
				<cfelse>
					<cfset s.sortable = listsort(s.thistable & "," & s.thattable,"Textnocase")>
					<cfset s.linkObj = createObject("component","#gettoken(s.itm, 1, ".")#.models.#listgetat(s.sortable,1)#To#listgetat(s.sortable,2)#" ).init(requestObj, userObj)>
				</cfif>

				<cfset s.habtmstruct = structnew()>
				<cfset s.habtmstruct[s.thiskey] = arguments.id>
				<cfset s.habtmdata = s.linkObj.getAll(s.habtmstruct)>
				
				<cfset variables.itemdata[s.formkey] = ArrayToList(s.habtmdata[s.thatkey])>
			</cfloop>
		</cfif>
	
		<!--- process --->
		<cfloop list="#r.columnlist#" index="itm">
			<cfif r[itm][1] NEQ "">
				<cfset variables.itemdata[itm] = r[itm][1]>
			</cfif>
		</cfloop>
	
		<cfif r.recordcount EQ 0>
			<cfreturn 0>
		</cfif>
		
		<cfreturn 1>
	</cffunction>
	
	<cffunction name="onmissingmethod" output="false">
		<cfargument name="missingMethodName" type="string">
		<cfargument name="missingMethodArguments" type="struct"> 
		
		<cfset var r = "">
		<cfset var s = structnew()>

		<!--- save --->
		<cfif isdefined("variables.orm") AND listfindnocase("save", missingMethodName)>
			<cfif NOT structisempty(arguments.missingMethodArguments)>
				<cfset s.more = arguments.missingMethodArguments[1]>
			<cfelse>
				<cfset s.more = structnew()>
			</cfif>
			<cfset s.tablename = variables.orm.getTableName()>
			<cfset s.tabledata = variables.orm.getTableData()>
		
			<cfif NOT structkeyexists(variables,"itemdata")>
				<cfthrow message="No data in itemdata to save">
			</cfif>
			
			<cfparam name="variables.itemdata.id" default="">
			
			<!--- do preformatting of data --->
			<cfif structkeyexists(variables, "preSave")>
				<cfset preSave(variables.itemdata)>
			</cfif>
	
			<!--- do system validation --->
			<cfset vdtr = this.validateSave()>
			
			<cfif NOT vdtr.passValidation()>
				<cfreturn false>
			</cfif>

			<cfset variables.itemdata.savemode = iif(variables.itemdata.id EQ "", DE("insert"), DE("update"))>
			<cfset variables.itemdata.id = variables.orm.save(variables.itemdata)>
		
			<cfif structkeyexists(s.tabledata, "habtm")>
				<cfloop collection="#s.tabledata.habtm#" item="s.itm">
					<cfset s.thistable = s.tablename>
					<cfset s.thiskey = variables.orm.singularize(s.thistable) & "id">
					<cfset s.thattable = gettoken(s.itm, 2, ".")>
					<cfset s.thatkey = variables.orm.singularize(s.thattable) & "id">
					<cfset s.formkey = s.thatkey & "s"><!--- plural --->
					
					<cfif structkeyexists(variables.itemdata, s.formkey)>
						<cfif structkeyexists(s.tabledata.habtm[s.itm], "via")><!--- path to linking object is provided by via key of habbtm struct --->
							<cfset s.linkObj = createObject("component","#replacenocase(s.tabledata.habtm[s.itm].via, ".", ".models.")#").init(requestObj, userObj)>
						<cfelse>
							<cfset s.sortable = listsort(s.thistable & "," & s.thattable,"TextNoCase")>
							<cfset s.linkObj = createObject("component","#gettoken(s.itm, 1, ".")#.models.#listgetat(s.sortable,1)#To#listgetat(s.sortable,2)#" ).init(requestObj, userObj)>
						</cfif>
		
						<!--- value of form item --->
						<cfset s.formitemdata = variables.itemdata[s.formkey]>
					
						<!--- create the linking object getall structure --->
						<cfset s.habtmstruct = structnew()>
						<cfset s.habtmstruct[s.thiskey] = variables.itemdata.id>
						<cfset s.habtmdata = s.linkObj.getAll(s.habtmstruct)>

						<!--- first delete the ones not supposed to be there --->
						<cfloop query="s.habtmdata">	
							<cfif NOT listfindnocase(s.formitemdata, s.habtmdata[s.thatkey][s.habtmdata.currentrow])>
								<cfif s.linkObj.getOrm().hasField("deleted")>
									<cfset s.linkObj.delete(s.habtmdata.id)>
								<cfelse>
									<cfset s.linkObj.destroy(s.habtmdata.id)>
								</cfif>
							</cfif>
						</cfloop>
						
						<!--- add the ones that arent there already --->
						<cfset s.existingitemlist = ArrayToList(s.habtmdata[s.thatkey])>
	
						<cfloop list="#s.formitemdata#" index="s.formitem">	
							<cfif NOT listfindnocase(s.existingitemlist, s.formitem)>	
								<cfset s.linkObj.clear()>
								<cfset s.habtmstruct = structnew()>
								<cfset s.habtmstruct.id = "">
								<cfset s.habtmstruct[s.thatkey] = s.formitem>
								<cfset s.habtmstruct[s.thiskey] = this.getId()>
								
								<cfset s.linkObj.setValues(s.habtmstruct)>
								<cfset s.linkObj.save(s.more)>
							</cfif>
						</cfloop>
					</cfif>
				</cfloop>
			</cfif>
			
			<cfset variables.observeEvent('save #variables.orm.getTableName()#', variables.itemData)>

			<cfif NOT structkeyexists(s.more, "noobserve")>
				<cfset requestObject.notifyObservers("orm.save.#variables.orm.getTableName()#", this)>
			</cfif>

			<cfreturn true>
		</cfif>
		
		<!--- getorm --->
		<cfif isdefined("variables.orm") AND missingMethodName EQ "getOrm">
			<cfreturn variables.orm>
		</cfif>
		
		<!--- delete destroy --->
		<cfif isdefined("variables.orm") AND listfindnocase("delete,destroy", missingMethodName)>
			<cfset s.tablename = variables.orm.getTableName()>
			<cfset s.tabledata = variables.orm.getTableData()>
			
		<!--- do preformatting of data --->
			<cfset s.id = missingMethodArguments[1]>
			
			<cfset s.isloaded = this.load(s.id)>
			
			<cfif NOT s.isloaded>
				<cfthrow message="invalid id #s.id#">
			</cfif>
			

			<!--- do system validation --->
			<cfinvoke component="#this#" method="validate#missingMethodName#"></cfinvoke>

			<!--- check validate does not have children --->
			<cfif structkeyexists(s.tabledata, "hasmany")>
				<cfset s.localtableinfo = s.tabledata.hasmany>
				<cfloop collection="#s.localtableinfo#" item="s.hm">
					<cfif NOT (structkeyexists(s.tabledata.hasmany[s.hm],"allowdeletewithchildren") AND s.tabledata.hasmany[s.hm].allowdeletewithchildren)>
						<cfset s.itm = createObject("component", replace(s.hm, ".", ".models.")).init(requestObj, userObj)>
						<cfset s.cntstruct = structnew()>
						<cfif structkeyexists(s.localtableinfo[s.hm], "fk")>
							<cfset s.fk = s.localtableinfo[s.hm].fk>
						<cfelse>
							<cfset s.fk = rereplacenocase(variables.orm.getTableName(), "s$", "") & "id">
						</cfif>
						<cfset s.cntstruct[s.fk] = s.id>
						<cfif s.itm.getOrm().hasField(s.fk) AND s.itm.count(s.cntstruct)>
							<cfset vdtr.addError("name", "This item has children (#listlast(s.hm,".")#). Please remove the relationship before deleting this item.")>
						</cfif>
					</cfif>
				</cfloop>
			</cfif>
			
			<cfif NOT vdtr.passValidation()>
				<cfreturn false>
			</cfif>
			
			<cfif missingmethodname EQ "delete" AND NOT variables.orm.hasField("deleted")>
				<cfset s.mmn = "destroy">
			<cfelse>
				<cfset s.mmn = missingmethodname>
			</cfif>
	
			<cfinvoke component="#variables.orm#" method="#s.mmn#">
				<cfinvokeargument name="id" value="#variables.itemdata.id#">
			</cfinvoke>
			
			<cfif missingmethodname EQ "destroy" AND structkeyexists(s.tabledata, "habtm")>
				<cfloop collection="#s.tabledata.habtm#" item="s.itm">
					<cfset s.thistable = s.tablename>
					<cfset s.thiskey = variables.orm.singularize(s.thistable) & "id">
					<cfset s.thattable = gettoken(s.itm, 2, ".")>
					<cfset s.thatkey = variables.orm.singularize(s.thattable) & "id">
					<cfset s.formkey = s.thatkey & "s"><!--- plural --->
					
					<cfif structkeyexists(s.tabledata.habtm[s.itm], "via")><!--- path to linking object is provided by via key of habbtm struct --->
						<cfset s.linkObj = createObject("component","#replacenocase(s.itm.via, ".", ".models.")#").init(requestObj, userObj)>
					<cfelse>
						<cfset s.sortable = listsort(s.thistable & "," & s.thattable,"TextNoCase")>
						<cfset s.linkObj = createObject("component","#gettoken(s.itm, 1, ".")#.models.#listgetat(s.sortable,1)#To#listgetat(s.sortable,2)#" ).init(requestObj, userObj)>
					</cfif>

					<!--- create the linking object getall structure --->
					<cfset s.habtmstruct = structnew()>
					<cfset s.habtmstruct[s.thiskey] = variables.itemdata.id>
					<cfset s.habtmdata = s.linkObj.getAll(s.habtmstruct)>
					
					<!--- use get all rs to destroy --->
					<cfloop query="s.habtmdata">
						<cfset s.linkObj.destroy(s.habtmdata.id)>d
					</cfloop>
				</cfloop>
			</cfif>
			
			<cfset variables.observeEvent('#missingMethodName# #variables.orm.getTableName()#', variables.itemData)>

			<cfreturn true>
		</cfif>
		
		<!--- getby --->
		<cfif isdefined("variables.orm") AND refindnocase("^getby", missingMethodName) AND variables.orm.hasField(mid(missingMethodName,6,len(missingMethodName)))>
			<cfinvoke component="#variables.orm#" method="getby" returnvariable="r">
				<cfinvokeargument name="field" value="#mid(missingMethodName,6,len(missingMethodName))#">
				<cfinvokeargument name="value" value="#missingMethodArguments[1]#">
				<cfif arraylen(missingMethodArguments) EQ 2>
					<cfinvokeargument name="more" value="#missingMethodArguments[2]#">
				</cfif>
			</cfinvoke>
			<cfreturn r>
		</cfif>
		
		<!--- getAll --->
		<cfif isdefined("variables.orm") AND listfindnocase("getAll,Count,Like", missingMethodName)>
			
			<cfif isstruct(missingMethodArguments) AND structkeyexists(missingMethodArguments,"1")>
				<cfset s.args = missingMethodArguments[1]>
			<cfelse>
				<cfset s.args = missingMethodArguments>
			</cfif>
			
			<cfif missingMethodName EQ "count">
				<cfset s.args.count = 1>
			</cfif>
			
			<cfif missingMethodName EQ "like">
				<cfset s.args.like = 1>
			</cfif>
	
			<cfinvoke component="#variables.orm#" method="getAll" returnvariable="r">
				<cfinvokeargument value="#s.args#" name="conditions">
			</cfinvoke>
			<cfreturn r>
		</cfif>
		
		<!--- get --->
		<cfif structkeyexists(variables, "orm") AND refindnocase("^get", missingMethodName) AND 
				(variables.orm.hasfield(mid(missingMethodName, 4, len(missingMethodName))) OR structkeyexists(variables.itemdata, mid(missingMethodName,4,len(missingMethodName))))>
			<cfif structkeyexists(variables.itemdata, mid(missingMethodName,4,len(missingMethodName)))>
				<cfreturn variables.itemdata[mid(missingMethodName, 4, len(missingMethodName))]>
			<cfelse>
				<cfreturn "">
			</cfif>
		</cfif>
		
		<!--- set --->
		<cfif isdefined("variables.orm") AND refindnocase("^set", missingMethodName) AND variables.orm.hasfield(mid(missingMethodName,4,len(missingMethodName)))>
			<cfset variables.itemdata[mid(missingMethodName,4,len(missingMethodName))] = missingMethodArguments[1]>
			<cfreturn>
		</cfif>
		
		<!--- 
			isfield bool  
			fieldLessThan
			fieldGreaterThan 
			fieldContains()
			fieldIs()
			validateField()
		--->
		
		<cfthrow message="Model function #missingMethodName# does not exist.">
	</cffunction>
</cfcomponent>