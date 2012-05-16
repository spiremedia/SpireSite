	<cfcomponent name="leaf">
	
	<cffunction name="init">
		<cfargument name="requestObject" required="true">
		
		<cfset variables.requestObject = arguments.requestObject>
		<cfset variables.forminfo = structnew()>
		<cfset variables.formdata = structnew()>
		
		<cfreturn this>
	</cffunction>
	
	<cffunction name="validate">
		<cfargument name="vdtr" required="true">
		<cfset var lcl = structnew()>

		<cfif structkeyexists(variables.formdata, variables.forminfo.name)>
			<cfset lcl.fieldVal = variables.formdata[variables.forminfo.name]>
		<cfelse>
			<cfset lcl.fieldVal = "">
		</cfif>
		<cfif structkeyexists(variables.forminfo,"validation")>
			<cfloop list="#variables.forminfo.validation#" index="lcl.item">
				

				<!--- <cfif find(":", l.vitem)>
					<cfset l.vmethod = gettoken(l.vitem, 1)>
					<cfset l.vtext = gettoken(l.vitem, 2)>
				<cfelse> --->

					<cfset lcl.vtext = vdtr.getDefaultMessage(lcl.item)>
				<!--- </cfif> --->
				
				<cfif structkeyexists(variables.forminfo,"validationlabel")>
					<cfset lcl.text = variables.forminfo["validationlabel"] & " " & lcl.vtext>
				<cfelseif structkeyexists(variables.forminfo,"label")>
					<cfset lcl.text = variables.forminfo["label"] & " " & lcl.vtext>
				<cfelse>
					<cfset lcl.text = lcl.name & " " & lcl.vtext>
				</cfif>
				
				<cfswitch expression="#lcl.item#">
					<cfcase value="maxlength">
						<cfset vdtr.maxLength(	variables.forminfo.name,
												variables.forminfo.maxlen,
												lcl.fieldval,
												lcl.text)>
					</cfcase>
					<cfdefaultcase>
						<cfinvoke component="#vdtr#" method="#lcl.item#">
							<cfinvokeargument name="field" value="#variables.forminfo.name#">
							<cfinvokeargument name="val" value="#lcl.fieldval#">
							<cfinvokeargument name="text" value="#lcl.text#">
						</cfinvoke>
					</cfdefaultcase>
				</cfswitch>
			</cfloop>
		</cfif>
		
		<cfreturn this>
	</cffunction>
	
	<cffunction name="setParent">
		<cfargument name="parent" required="true">
		<cfset variables.parent = arguments.parent>
	</cffunction>
	
	<cffunction name="setname">
		<cfargument name="name" required="true">
		<cfset variables.forminfo.name = name>
	</cffunction>
	
	<cffunction name="setid">
		<cfargument name="id" required="true">
		<cfset variables.forminfo.id = id>
	</cffunction>
    
	<cffunction name="addClassToForm">
		<cfargument name="name" required="true">
		<cfparam name="variables.forminfo.formclasses" default="#structnew()#">
		<cfset variables.forminfo.formclasses[name] = 1>
	</cffunction>
	
	<cffunction name="addClassToWrapper">
		<cfargument name="name" required="true">
		<cfparam name="variables.forminfo.wrapperclasses" default="#structnew()#">
		<cfset variables.forminfo.wrapperclasses[name] = 1>
	</cffunction>
	
	<cffunction name="setlabel">
		<cfargument name="name" required="true">
		<cfset variables.forminfo.label = name>
	</cffunction>
	
	<cffunction name="setfooter">
		<cfargument name="name" required="true">
		<cfset variables.forminfo.footertext = name>
	</cffunction>
	
	<cffunction name="setValidationlabel">
		<cfargument name="name" required="true">
		<cfset variables.forminfo.validationlabel = name>
	</cffunction>
	
	<cffunction name="setrequired">
		<cfset variables.forminfo.required = true>
		<cfset addvalidation("notblank")>
	</cffunction>
	
	<cffunction name="maxlength">
		<cfargument name="len" required="true">
		<cfset variables.forminfo.maxlen = len>
		<cfset addvalidation("maxlength")>
	</cffunction>
	
	<cffunction name="setdefault">
		<cfargument name="name" required="true">
		<cfset variables.forminfo.default = name>
	</cffunction>
    
	<cffunction name="setformdata">
		<cfargument name="data" required="true">
		<cfset variables.formdata = data>
	</cffunction>

	
	<cffunction name="addValidation">
		<cfargument name="method" required="true">
		<cfparam name="variables.forminfo.validation" default="">
		<cfif not listfind(variables.forminfo.validation, method)>
			<cfset variables.forminfo.validation = listappend(variables.forminfo.validation, method)>
		</cfif>
	</cffunction>
	
	<cffunction name="setformstyle">
		<cfargument name="name" required="true">
		<cfargument name="value" required="true">
		<cfparam name="variables.forminfo.formstyles" default="#structnew()#">
		<cfset variables.forminfo.formstyles[name] = value>
	</cffunction>
	
	<cffunction name="setwrapperstyles">
		<cfargument name="name" required="true">
		<cfargument name="value" required="true">
		<cfparam name="variables.forminfo.wrapperstyles" default="#structnew()#">
		<cfset variables.forminfo.wrapperstyles[name] = value>
	</cffunction>
		
	<cffunction name="dump">
		<cfargument name="path">
		<cfset var lcl = structnew()>
		<cfoutput>
		<cfset lcl.mtdt = getMetaData(this)>
		<cfsavecontent variable="lcl.h">
			<fieldset class="leaf">
			<legend>leaf : #lcl.mtdt.name# : #listappend(path, variables.forminfo.name,".")#</legend>
			<cfloop collection="#variables.forminfo#" item="lcl.itm">
				<cfif isstruct(variables.forminfo[lcl.itm])>
					<cftry>
					<cfloop collection="#variables.forminfo[lcl.itm]#" item="lcl.itm2">
						<cfif issimplevalue(variables.forminfo[lcl.itm][lcl.itm2])>
							#lcase(lcl.itm)# .#lcase(lcl.itm2)# : #variables.forminfo[lcl.itm][lcl.itm2]#
						<cfelse>
							#lcase(lcl.itm)# .#lcase(lcl.itm2)# : not a simple val	
						</cfif><br></cfloop>
					<cfcatch>
					<cfdump var=#variables.forminfo[lcl.itm][lcl.itm2]#>
					</cfcatch>
					</cftry>
				<cfelseif issimplevalue(variables.forminfo[lcl.itm])>
					#lcase(lcl.itm)# : #variables.forminfo[lcl.itm]#<br>
				<cfelse>
					#lcase(lcl.itm)# : unknown type?
				</cfif>
			</cfloop>
			</fieldset>
		</cfsavecontent>
		</cfoutput>
		<cfreturn lcl.h>
	</cffunction>">
	
	<cffunction name="findByFullPath">
		<cfargument name="path" required="true">
		<cfargument name="matches" default="#structnew()#">
		
		<!--- if string, turn this into an array for comparative purposes --->
		<cfif NOT isarray(arguments.path)>
			<cfset arguments.path = listtoarray(arguments.path, ".")>
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
	</cffunction>
	
	<cffunction name="getmypath">
		<cfargument name="path" default="">
		<cfset path = listprepend(path, variables.forminfo.name, ".")>
		
		<cfif structkeyexists(variables, 'parent')>
			<cfreturn variables.parent.getMyPath(path)>
		<cfelse>
			<cfreturn path>
		</cfif>
	</cffunction>
	
</cfcomponent>