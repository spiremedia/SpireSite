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
	
	<cffunction name="getWidget" output="false">
		<cfargument name="widgetname">
		<cfreturn createobject('component','widget.#widgetname#').init()>
	</cffunction>
	
	<cffunction name="getResource" output="false">
		<cfargument name="resourcename">
		<cfargument name="requestObj">
		<cfargument name="userObj">
		<cfreturn createobject('component','resources.#resourcename#').init(requestObj, userObj)>
	</cffunction>
	
	<cffunction name="settablemetadata" output="false">
		<cfset variables.orm = createobject('component', 'resources.orm.start').init(variables.requestObj, variables.userObj)>
		<cfset variables.orm.setTableData(deserializeJson(arguments[1]))>
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
		
		<!--- validate taxonommies --->
		<cfif structkeyexists(tabledata, "taxonomies")>
			<cfloop collection="#tabledata.taxonomies#" item="l.taxitem">
				<cfif structkeyexists(variables.itemdata, l.taxitem & "Taxonomy")>
					<cfset l.fieldval = variables.itemdata[l.taxitem & "Taxonomy"]>
				<cfelse>
					<cfset l.fieldval = "">
				</cfif>

				<cfif structkeyexists(tabledata.taxonomies[l.taxitem], "validation")>
					<cfloop list="#tabledata.taxonomies[l.taxitem].validation#" index="l.vitem">
						
						<cfif find(":", l.vitem)>
							<cfset l.vmethod = gettoken(l.vitem, 1)>
							<cfset l.vtext = gettoken(l.vitem, 2)>
						<cfelse>
							<cfset l.vmethod = l.vitem>
							<cfset l.vtext = vdtr.getDefaultMessage(l.vmethod)>
						</cfif>
						
						<cfif structkeyexists(tabledata.taxonomies[l.taxitem],"label")>
							<cfset l.text = tabledata.taxonomies[l.taxitem]["label"] & " " & l.vtext>
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
			</cfloop>
		</cfif>
		
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
	
	<cffunction name="getvalues" output="false">
		<cfreturn variables.itemdata>	
	</cffunction>
	
	<cffunction name="exists" output="false">
		<cfargument name="id">
		<cfset var lcl = structnew()>
		<cfif NOT (isdefined("arguments.id") OR isdefined("variables.itemdata.id"))>
			<cfthrow message="id is required in arguments or itemdata for exists">
		</cfif>
		<cfset lcl.more = structnew()>
		<cfset lcl.more.count = 1>
		<cfreturn this.getById(iif(isdefined("arguments.id"), "arguments.id", "variables.itemdata.id"), lcl.more)>
	</cffunction>	
	
	<cffunction name="save" output="false">
		<cfargument name="more" default="#structnew()#">
		<cfset var s = structnew()>
	<!--- save --->
		<cfif NOT isdefined("variables.orm")>
			<cfthrow message="Cant save - no orm available">
		</cfif>

		<cfset s.tablename = variables.orm.getTableName()>
		<cfset s.tabledata = variables.orm.getTableData()>
	
		<cfif NOT structkeyexists(variables,"itemdata")>
			<cfthrow message="No data in itemdata to save">
		</cfif>
		
		<cfparam name="variables.itemdata.id" default="">

		<!--- do preformatting of data --->
		<cfif structkeyexists(this, "preSave")>
			<cfset preSave(variables.itemdata)>
		</cfif>
		
		<!--- do system validation --->
		<cfset vdtr = this.validateSave()>
		
		<cfif NOT vdtr.passValidation()>
			<cfreturn false>
		</cfif>

		<cfloop collection="#s.tabledata.fields#" item="s.parsidx">
			<cfif structkeyexists(variables.itemdata, s.parsidx) AND structkeyexists(s.tabledata.fields[s.parsidx],"wysiwyg")>
				<cfif not isdefined("s.postparser")>
					<cfset s.postparser = createobject('component','utilities.embeddedlinksandassetsparser').init(requestObj)>
				</cfif>
				<cfset variables.itemdata[s.parsidx] = s.postparser.postprocessfromwysywig(variables.itemdata[s.parsidx])>
			</cfif>
		</cfloop>
		
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
						#s.habtmdata.id#
						<cfif s.linkObj.getOrm().hasField("deleted")>
							<cfset s.linkObj.delete(s.habtmdata.id)>
						<cfelse>
							<cfset s.linkObj.destroy(s.habtmdata.id)>
						</cfif>
					</cfloop>
			
					<cfset s.count = 0>

					<cfloop list="#s.formitemdata#" index="s.formitem">	
						<cfset s.count = s.count + 1>
						<cfset s.linkObj.clear()>
						<cfset s.habtmstruct = structnew()>
						<cfset s.habtmstruct.id = "">
						<cfset s.habtmstruct[s.thatkey] = s.formitem>
						<cfset s.habtmstruct[s.thiskey] = this.getId()>
						<cfif s.linkObj.hasField("sortkey")>
							<cfset s.habtmstruct["sortkey"] = s.count>
						</cfif>
						<cfset s.linkObj.setValues(s.habtmstruct)>
						<cfset s.linkObj.save()>
					</cfloop>
				</cfif>
			</cfloop>
		</cfif>
		
		<cfif structkeyexists(s.tabledata, "taxonomies")>
			<cfset s.tax = createobject("component","taxonomies.models.taxonomyToObj").init(requestObj,userObj)>
			<cfloop collection="#s.tabledata.taxonomies#" item="l.taxitem">
				<cfif structkeyexists(variables.itemdata, l.taxitem & "Taxonomy")>
					<cfset l.fieldval = variables.itemdata[l.taxitem & "Taxonomy"]>
				<cfelse>
					<cfset l.fieldval = "">
				</cfif>
				<cfset s.tax.saveToObj(variables.itemdata.id, s.tablename, l.taxitem, l.fieldval)>
			</cfloop>
		</cfif>
		
		<cfset variables.observeEvent('save #variables.orm.getTableName()#', variables.itemData)>
				
		<cfif NOT structkeyexists(more, "noobserve")>
			<cfset requestObj.notifyObservers("orm.save.#variables.orm.getTableName()#", this)>
		</cfif>

		<cfreturn true>
	</cffunction>
	
	<cffunction name="getOrm" output="false">
		<cfif NOT isdefined("variables.orm")>
			<cfthrow message="getorm : orm not available">
		</cfif>
		
		<cfreturn variables.orm>
	</cffunction>
	
	<cffunction name="load" output="false">
		<cfargument name="id" required="true">
		<cfargument name="more" default="#structnew()#">
		<cfset var s = structnew()>
		
		<cfif NOT isdefined("variables.orm")>
			<cfthrow message="load : orm not available">
		</cfif>
		
		<cfset variables.itemdata =structnew()	>
		
		<!--- <cfset variables.itemdata.id = arguments.id> --->
		
		<cfset s.tablename = variables.orm.getTableName()>
		<cfset s.tabledata = variables.orm.getTableData()>
		
		<!--- get --->
		<!--- not sure if we need this <cfif arraylen(missingMethodArguments) EQ 1>
			<cfset arrayappend(missingMethodArguments, structnew())>
		</cfif> --->
		<cfset arguments.more.ignorebelongsto = 1>
		<cfset r = variables.orm.getBy("id", arguments.id, arguments.more)>
	
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
				
				<cfif s.linkObj.hasField("sortkey")>
					<!---<cfset s.habtmstruct.order = structnew()>--->
					<cfset s.habtmstruct.sort = "sortkey ASC">
				</cfif>
				
				<cfset s.habtmdata = s.linkObj.getAll(s.habtmstruct)>
				
				<cfset variables.itemdata[s.formkey] = ArrayToList(s.habtmdata[s.thatkey])>
			</cfloop>
		</cfif>
		
		<!--- get taxonomy lists and set as itemdata keys--->
		<cfif structkeyexists(s.tabledata, "taxonomies")>
			<cfset s.tax = createobject("component","taxonomies.models.taxonomyToObj").init(requestObj,userObj)>
			<cfset s.taxes = s.tax.loadByObj(arguments.id, variables.orm.getTableName())>
			<cfloop collection="#s.tabledata.taxonomies#" item="s.itm">
				<cfif structkeyexists(s.taxes, s.itm)>
					<cfset variables.itemdata["#s.itm#Taxonomy"] = structkeylist(s.taxes[s.itm])>
				<cfelse>
					<cfset variables.itemdata["#s.itm#Taxonomy"] = "">
				</cfif>
			</cfloop>
		</cfif>

		<!--- process --->
		<cfloop list="#r.columnlist#" index="itm">
			<cfif r[itm][1] NEQ "">
				<cfset variables.itemdata[itm] = r[itm][1]>
			</cfif>
		</cfloop>

		<cfloop collection="#s.tabledata.fields#" item="s.parsidx">
			<cfif structkeyexists(variables.itemdata, s.parsidx) AND structkeyexists(s.tabledata.fields[s.parsidx],"wysiwyg")>
				<cfif not isdefined("s.parser")>
					<cfset s.parser = createobject('component','utilities.embeddedlinksandassetsparser').init(requestObj)>
				</cfif>
				<cfset variables.itemdata[s.parsidx] = s.parser.preprocessforwysywig(variables.itemdata[s.parsidx])>
			</cfif>
		</cfloop>

		<cfif r.recordcount EQ 0>
			<cfreturn false>
		</cfif>
		
		<cfreturn true>
	</cffunction>
	
	<cffunction name="hasField" output="false">
		<cfargument name="fieldname" required="true">

		<cfif (structkeyexists(variables, "orm") AND variables.orm.hasfield(arguments.fieldname))
				OR structkeyexists(variables.itemdata, arguments.fieldname)>
			<cfreturn true>
		<cfelse>
			<cfreturn false>
		</cfif>
	</cffunction>
	
	<cffunction name="getField" output="false">
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
	
	
	<cffunction name="onmissingmethod" output="false">
		<cfargument name="missingMethodName" type="string">
		<cfargument name="missingMethodArguments" type="struct"> 
		
		<cfset var r = "">
		<cfset var s = structnew()>

		<!--- delete destroy --->
		<cfif isdefined("variables.orm") AND listfindnocase("delete,destroy", missingMethodName)>
			<cfset s.tablename = variables.orm.getTableName()>
			<cfset s.tabledata = variables.orm.getTableData()>
			
			<!--- do preformatting of data --->
			<cfset s.id = missingMethodArguments[1]>
			<cfif NOT this.load(s.id)>
				<cfthrow message="invalid id in delete or destroy #s.id#">
			</cfif>
			
			<cfif structkeyexists(arguments.missingMethodArguments,"2")>
				<cfset s.more = arguments.missingMethodArguments["2"]>
			<cfelse>
				<cfset s.more = structnew()>
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
			
			<cfif NOT structkeyexists(s.more, "noobserve")>
				<cfset requestObj.notifyObservers("orm#s.mmn#.#variables.orm.getTableName()#", this)>
			</cfif>
		
			<cfreturn true>
		</cfif>
		
		<!--- getby --->
		<cfif isdefined("variables.orm") AND 
				refindnocase("^getby", missingMethodName) 
					AND variables.orm.hasField(mid(missingMethodName,6,len(missingMethodName)))>
							
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
		
		<!--- getRelated --->
		<cfif isdefined("variables.orm") 
				AND refindnocase("^getRelated", missingMethodName)
				AND variables.orm.hasRelation(MID(missingMethodName, 11, len(missingMethodName)))>
			
			<cfset s.relation = variables.orm.getRelation(MID(missingMethodName, 11, len(missingMethodName)))>
			<cfset s.conditions = structnew()>
			<cfset s.id = "">

			<!--- 
				figure out the id, either passed as only argument, as key in argument struct, or already set in itemdata 
				belongs to is sufficiently diff to get its own if
				WTF how hard can this be? Jeez.
			--->
			<cfif s.relation.relationship EQ "belongsTo">
				<cfthrow message="belongs to not yet working">
				<!---<cfset s.fkfieldname = variables.orm.singularize(gettoken(s.relation.withmodel,2,".")) & "id">
				<cfif arraylen(missingMethodarguments) EQ 0><!--- getRelated___() --->
					<cfif structkeyexists(variables.itemdata, s.fkfieldname)>
						<cfset s.id = variables.itemdata[s.fkfieldname]>
					<cfelse>
						<cfthrow message='getRelated on belongsto called without loading'>
					</cfif>
				<cfelseif isstruct(missingMethodArguments[1]) AND structkeyexists(missingMethodArguments[1],"id")><!--- getRelated___({id:#id#}) --->
					<cfif variables.itemdata.id EQ missingMethodArguments[1].id>
					
					<cfset s.id = missingMethodArguments[1].id>
				<cfelseif issimplevalue(missingMethodArguments[1])><!--- getRelated___(#id#}) --->
					<cfset s.id = missingMethodArguments[1]>
					<cfif arraylen(missingMethodArguments) EQ 2 AND issimplevalue(missingMethodArguments[2])>
						<cfset s.conditions.sort = missingMethodArguments[2]>
					</cfif>
				</cfif>--->
			<cfelse>
				<cfif arraylen(missingMethodarguments) EQ 0><!--- getRelated___() --->
					<cfset s.id = this.getId()>
				<cfelseif isstruct(missingMethodArguments[1])><!--- getRelated___({id:#id#}) --->
					<cfset s.conditions = missingMethodArguments[1]>
					<cfif structkeyexists(missingMethodArguments[1], "id") AND missingMethodArguments[1].id NEQ "">
						<cfset s.id = missingMethodArguments[1].id>
					<cfelse>
						<cfset s.id = this.getId()>
					</cfif>
				<cfelseif issimplevalue(missingMethodArguments[1])><!--- getRelated___(#id#}) --->
					<cfset s.id = missingMethodArguments[1]>
					<cfif arraylen(missingMethodArguments) EQ 2 AND issimplevalue(missingMethodArguments[2])>
						<cfset s.conditions.sort = missingMethodArguments[2]>
					</cfif>
				</cfif>
			</cfif>
			
			<cfif s.id EQ "">
				<cfthrow message="id required by #missingMethodName#">
			</cfif>
			
			<cfset s.relatedObj = createObject("component", replace(s.relation.withModel, ".", ".models.")).init(requestObj,userObj)>
			
			<cfif s.relation.relationship EQ "belongsTo">
				<cfset s.conditions["id"] = s.id>
			<cfelseif s.relation.relationship EQ "hasMany">
				<cfset s.conditions[variables.orm.singularize(variables.orm.getTableName()) & "id"] = s.id>
			<cfelseif s.relation.relationship EQ "habtm">
				<!--- todo - include via here --->
				<cfset s.jointablename = variables.orm.getLinkTableName(variables.orm.getTableName(), gettoken(s.relation.withModel, 2, "."))>
				<cfset s.linkObj = createObject("component", gettoken(s.relation.withModel, 1, ".") & ".models." & s.jointablename).init(requestObj,userObj)>
				
				<cfset s.jointemp = structnew()>
				<cfset s.jointemp.values = structnew()>
				<cfset s.jointemp.values[s.jointablename & "." & variables.orm.singularize(variables.orm.getTableName()) & "id"] = s.id>
				<cfset s.jointemp.equalities = structnew()>
				<cfset s.jointemp.equalities[s.jointablename & "." & variables.orm.singularize(gettoken(s.relation.withModel,2,".")) & "id"] = gettoken(s.relation.withModel,2,".") & ".id">
				<cfif s.linkObj.getOrm().hasField("deleted")>
					<cfset s.jointemp.values[s.jointablename & ".deleted"] = "0">
				</cfif>
				
				<cfset s.joins = structnew()>
				<cfset s.joins[s.jointablename] = s.jointemp>
				<cfset s.conditions.joins = s.joins>
			</cfif>
						
			<cfset s.more = structnew()>
			<cfreturn s.relatedObj.getAll(s.conditions)>
		</cfif>
		
		<!--- get --->
		<cfif refindnocase("^get", missingMethodName) AND 
				(structkeyexists(variables, "orm") AND variables.orm.hasfield(mid(missingMethodName, 4, len(missingMethodName))) OR structkeyexists(variables.itemdata, mid(missingMethodName,4,len(missingMethodName))))>
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
		
		<cfthrow message="Function #missingMethodName# does not exist.">
	</cffunction>
	</cfcomponent>