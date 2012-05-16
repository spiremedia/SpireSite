<cfcomponent extends="resources.abstractController" ouput="false">
	
	<cfset variables.useparseforlanguage = true>

	<cffunction name="default">
		<cfset var lcl = structnew()>
		<cfset variables.items = structnew()>
		
		<cfset lcl.multiSpotMdl = createObject("component", "modules.multispot.models.multispot").init(requestObject)>
		
		<!--- get existing multipspot items for this spot --->
		<cfset lcl.items = lcl.multispotMdl.getPageObjects(variables.data.pageobjectid, iif(variables.pageref.ispreview('edit'), DE("staged"), DE("published")))>

		<!--- loop thru existing items to fill a structure to use in showhtml with module objects --->
		<cfloop query="lcl.items">
			<cfset lcl.itm = structnew()>
			<cfset lcl.itm.module = lcl.items.module>
			<cfset lcl.itm.id = lcl.items.id>
			<cfset lcl.itm.name = variables.name>
			<cfset lcl.itm.data = lcl.items.data>
			<cfset lcl.itm.title = lcl.items.title>
			<cfif left(lcl.itm.data, 1) EQ "{">
				<cfset lcl.itm.data = deserializejson(lcl.itm.data)>
			<cfelse>
				<cfset lcl.itm.data = structnew()>
				<cfset lcl.itm.data.content = lcl.items.data>
			</cfif>
			<cfif structkeyexists(lcl.itm.data, "moduleaction")>
				<cfset lcl.itm.moduleaction = lcl.itm.data.moduleaction>
			<cfelse>
				<cfset lcl.itm.moduleaction = "default">
			</cfif>
			<cfset lcl.itm.obj = createObject("component", "modules.#lcl.itm.module#.controller").init(
				title = lcl.itm.title,
				data = lcl.itm.data,
				requestObject = variables.requestObject,
				pageRef = variables.pageRef,
				name = lcl.itm.name
			)>

			<cfinvoke component="#lcl.itm.obj#" method="#lcl.itm.moduleaction#" returnvariable="lcl.itm.obj">
				<cfinvokeargument name="module" value="#lcl.itm.module#">
				<cfinvokeargument name="moduleaction" value="#lcl.itm.moduleaction#">
			</cfinvoke>

			<cfset variables.items[lcl.items.name] = lcl.itm>
		</cfloop>
		
		<!--- loop thru the empty ones and fill with blank editables - once complete, all required objects will exist --->
		<cfparam name="variables.data.layout" default="2">
		<cfloop from="1" to="#variables.data.layout#" index="lcl.i">
			<cfset lcl.thisname = variables.name & '_sub_' & lcl.i>
			<cfif NOT structkeyexists(variables.items, lcl.thisname)>
				<cfset lcl.itm = structnew()>
				<cfset lcl.itm.data = structnew()>
				<cfset lcl.itm.module = 'blankeditable'>
				<cfset lcl.itm.moduleaction = "default">
				<cfset lcl.itm.name = variables.name>
				<cfset lcl.itm.title = variables.title>
				<cfset lcl.itm.id = "">
				<cfset lcl.itm.obj = createObject("component", "modules.blankeditable.controller").init()>
				
				<cfset variables.items[lcl.thisname] = lcl.itm>
			</cfif>
		</cfloop>	

		<cfreturn this>
	</cffunction>

	<cffunction name="showHTML">
		<cfset var lcl = structnew()>
		<cfset var rhtml = structnew()>
		<cfoutput>
		<cfsavecontent variable="lcl.html">
			<div style="*min-height:.01%;"><!--- extra div needed for ie6-7 --->
			<cfloop from="1" to="#variables.data.layout#" index="lcl.i">
				<cfsilent>
					<cfset lcl.thisname = variables.name & '_sub_' & lcl.i>
					<cfset lcl.thisitem = variables.items[lcl.thisname]>

					<cfinvoke component="#lcl.thisitem.obj#" method="showhtml" returnvariable="html">
						<cfinvokeargument name="module" value="#lcl.thisitem.module#">
						<cfinvokeargument name="moduleaction" value="#lcl.thisitem.moduleaction#">
					</cfinvoke>
					
					<cfset rhtml.module = lcl.thisitem.module>
					<cfset rhtml.moduleaction = lcl.thisitem.moduleaction>
					<cfset rhtml.templatespot = lcl.thisitem.name>
					
					<cfif isstruct(html)>
						<cfset rhtml.title = html.title>
						<cfset rhtml.html = html.html>
					<cfelse>
						<cfset rhtml.title = "">
						<cfset rhtml.html = html>
					</cfif>
			
					<cfset rhtml.head = '<div class="posub#iif(len(rhtml.title), DE("_wtitle"), DE(""))# #lcl.thisitem.module# #lcl.thisitem.module#_#lcl.thisitem.moduleaction# #lcl.thisitem.name#">
					'>
					
					<cfset rhtml.head = lcase(rhtml.head)>
					
					<cfif rhtml.title NEQ "">
						<cfset rhtml.title = '<div class="posubtitle"><h4>#rhtml.title#</h4></div>
						'>
					</cfif>
			
					<cfset rhtml.htmlhead = '<div class="posubcntnt">
					'>
					
					<cfset rhtml.htmlfoot = '</div>
					'>
								
					<cfset rhtml.foot = '<div class="posubfoot"><div></div></div>
					'>
					
					<cfif variables.pageref.ispreview('edit') AND rhtml.html EQ '' AND structkeyexists(variables.data, 'editable')>
						<cfset rhtml.head = '<div class="hint">#name#_sub_#lcl.i#</div>' & rhtml.head>
						'>
					</cfif>

					<cfif structkeyexists(variables.data, 'editable') AND variables.pageref.ispreview('edit')>
						<cfset rhtml.esm = '<input class="subContentObjectMarker" id="#lcl.thisitem.id#" type="hidden" name="#lcl.thisitem.name#|#lcl.thisitem.name#_sub_#lcl.i#" value=''#variables.pageref.getField("template")#''>
					'>
						<cfset rhtml.html = rhtml.html & '&nbsp;'>
					<cfelse>
						<cfset rhtml.esm = ''>
					</cfif>
					
					<cfset rhtml.tail = "</div>
					">
					
					<cfset rhtml = requestObject.notifyObservers("moduleoutput.#rhtml.module#.#rhtml.moduleaction#", rhtml)>
					
					<cfset lcl.html = rhtml.head & rhtml.title & rhtml.htmlhead & rhtml.html & rhtml.htmlfoot & rhtml.foot & rhtml.esm & rhtml.tail>
				</cfsilent>
				<div class="multispot_#int(variables.data.layout)#_#lcl.i#">
					#lcl.html#
				</div>
			</cfloop>
			<br class="clear"/>
			</div>
			
			<cfif variables.pageref.ispreview('edit')>
				<script>
					jQuery(function(){ 
						jQuery('.#lcase(variables.name)# .subContentObjectMarker').esmclick({link:'#requestObject.getVar("cmslocation")#contentLink/|action|/?pageid=#variables.data.pageobjectid#&siteid=#requestObject.getVar("siteid")#'});
					});  
				</script>					
			</cfif>
		</cfsavecontent>
		</cfoutput>
		<cfreturn lcl.html>
	</cffunction>

</cfcomponent>

<!--- <cfinvoke component="#variables.pageobjects[name].obj#" method="showhtml" returnvariable="html">
			<cfinvokeargument name="module" value="#variables.pageobjects[name].module#">
			<cfinvokeargument name="moduleaction" value="#variables.pageobjects[name].moduleaction#">
		</cfinvoke>
		
		<cfset rhtml.module = variables.pageobjects[name].module>
		<cfset rhtml.moduleaction = variables.pageobjects[name].moduleaction>
		<cfset rhtml.templatespot = arguments.name>
		
		<cfif isstruct(html)>
			<cfset rhtml.title = html.title>
			<cfset rhtml.html = html.html>
		<cfelse>
			<cfset rhtml.title = "">
			<cfset rhtml.html = html>
		</cfif>

		<cfset rhtml.head = '<div class="po#iif(len(rhtml.title), DE("_wtitle"), DE(""))# #variables.pageobjects[name].module# #variables.pageobjects[name].module#_#variables.pageobjects[name].moduleaction# #name#">
		'>
		
		<cfset rhtml.head = lcase(rhtml.head)>
		
		<cfif rhtml.title NEQ "">
			<cfset rhtml.title = '<div class="potitle"><h4>#rhtml.title#</h4></div>
			'>
		</cfif>

		<cfset rhtml.htmlhead = '<div class="pocntnt">
		'>
		
		<cfset rhtml.htmlfoot = '</div>
		'>
					
		<cfset rhtml.foot = '<div class="pofoot"><div></div></div>
		'>
		
		
		<cfif ispreview('edit') AND rhtml.html EQ '' AND find('editable', arguments.parameterlist)>
			<cfset rhtml.head = '<div class="hint">#name#</div>' & rhtml.head>
			'>
		</cfif>
		
		<cfif find('editable', arguments.parameterlist) AND ispreview('edit')>
			<cfset json = createObject('component', 'utilities.json').encode(arguments)>
			<cfset rhtml.esm = '<input class="contentObjectMarker" id="#getObjectId(name)#" #iif(variables.pageobjects[name].objtype EQ 'block', DE('rel="block"'), DE(""))# type="hidden" name="#arguments.name#" value=''#json#''>
		'>
			<cfset rhtml.html = rhtml.html & '&nbsp;'>
		<cfelse>
			<cfset rhtml.esm = ''>
		</cfif>
		
		<cfset rhtml.tail = "</div>
		">
		
		<cfset rhtml = requestObject.notifyObservers("moduleoutput.#rhtml.module#.#rhtml.moduleaction#", rhtml)>
		
		<cfreturn rhtml.head & rhtml.title & rhtml.htmlhead & rhtml.html & rhtml.htmlfoot & rhtml.foot & rhtml.esm & rhtml.tail> --->