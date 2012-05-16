<cfcomponent name="Taxonomies" extends="resources.abstractControllerWEditables">
	
	<cffunction name="startPage">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">
		
		<cfset var mdl = gettaxonomymodel(requestObject, userObj)>
				
		<cfset displayObject.setData('browse', mdl.getAll())>
	</cffunction>

	<cffunction name="gettaxonomyMenuFavoritesModel">
		<cfargument name="requestObj" required="true">
		<cfargument name="userObj" required="true">
		<cfset var m = createObject("component", "taxonomies.models.taxonomyMenuFavorites").init(arguments.requestObj, arguments.userObj)>
		<cfreturn m>
	</cffunction>

	<cffunction name="gettaxonomyitemsModel">
		<cfargument name="requestObj" required="true">
		<cfargument name="userObj" required="true">
		<cfset var m = createObject("component", "taxonomies.models.taxonomyitems").init(arguments.requestObj, arguments.userObj)>
		<cfset m.prepsafename()>
		<cfreturn m>
	</cffunction>
	
	<cffunction name="getMenuModel">
		<cfargument name="requestObj" required="true">
		<cfargument name="userObj" required="true">
		<cfset var m = createObject("component", "taxonomies.models.taxonomymenus").init(arguments.requestObj, arguments.userObj)>
		<cfreturn m>
	</cffunction>
	
	<cffunction name="getMenuItemsModel">
		<cfargument name="requestObj" required="true">
		<cfargument name="userObj" required="true">
		<cfset var m = createObject("component", "taxonomies.models.taxonomymenuitems").init(arguments.requestObj, arguments.userObj)>
		<cfreturn m>
	</cffunction>

	<cffunction name="gettaxonomyModel">
		<cfargument name="requestObj" required="true">
		<cfargument name="userObj" required="true">
		<cfset var m = createObject("component", "taxonomies.models.taxonomy").init(arguments.requestObj, arguments.userObj)>
		<cfreturn m>
	</cffunction>
	
	<cffunction name="addTaxonomy">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">
	
		<cfset var mdl = gettaxonomymodel(requestObject, userObj)>
		<cfset var temp = structnew()>	
				
		<cfset displayObject.setData('browse', mdl.getAll())>
			
		<cfif requestObject.isformurlvarset('id')>
			<cfset mdl.load(requestObject.getformurlvar('id'))>
			<cfset displayObject.setData('history', queryNew("hi"))>
			
			<cfset displayObject.setData('taxonomylist', mdl.getRelatedTaxonomyitems(requestObject.getformurlvar('id')))>

			<cfset displayObject.setData('taxonomy', mdl)>
			<cfset displayObject.setWidgetOpen('mainContent','2')>
		<cfelse>
			<cfset mdl.Load(0)>
			<cfset displayObject.setData('Taxonomy', mdl)>
		</cfif>

		<cfif requestObject.isformurlvarset('sortdir')>
			<cfset displayObject.setWidgetOpen('mainContent','2')>
		</cfif>
			
		<cfif requestObject.isformurlvarset('search')>
			<cfset displayObject.setData('search', 
				model.search(
					requestObject.getformurlvar('search')))>
		</cfif>
	
	</cffunction>
	
	<cffunction name="addTaxonomyItem">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">
	
		<cfset var mdl = gettaxonomyItemsModel(requestObject, userObj)>
		<cfset var temp = structnew()>	
		<cfset var taxid = requestObject.getFormUrlVar("taxid")>
		
		<cfset var sortstruct = structnew()>
		<cfset sortstruct.sort = "sortkey">
		<cfset displayObject.setData('browse', mdl.getByTaxonomyId(taxid, sortstruct))>
			
		<cfif requestObject.isformurlvarset('id')>
			<cfset mdl.load(requestObject.getformurlvar('id'))>
			<cfset displayObject.setData('history', queryNew("hi"))>
			<cfset displayObject.setData('taxonomyitem', mdl)>
		<cfelse>
			<cfset mdl.Load(0)>
			<cfset displayObject.setData('Taxonomy', mdl)>
		</cfif>

		<cfif requestObject.isformurlvarset('sortdir')>
			<cfset displayObject.setWidgetOpen('mainContent','3')>
		</cfif>
			
		<cfif requestObject.isformurlvarset('search')>
			<cfset displayObject.setData('search', 
				model.search(
					requestObject.getformurlvar('search')))>
		</cfif>
	
	</cffunction>
	
	<cffunction name="editTaxonomy">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userObj" required="true">
		<cfargument name="dispatcher" required="true">
		<cfreturn addTaxonomy(displayObject,requestObject,userObj,dispatcher)>
	</cffunction>
	
	<cffunction name="editTaxonomyItem">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userObj" required="true">
		<cfargument name="dispatcher" required="true">
		<cfreturn addTaxonomyItem(displayObject,requestObject,userObj,dispatcher)>
	</cffunction>
	
	<cffunction name="taxonomyList">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userObj" required="true">
		<cfargument name="dispatcher" required="true">
		
		<cfset var mdl = gettaxonomymodel(requestObject, userObj)>
		<cfset var temp = structnew()>	
				
		<cfset displayObject.setData('browse', mdl.getAll())>

		<cfset mdl.load(requestObject.getformurlvar('id'))>

		<cfset displayObject.setData('Taxonomy', mdl)>
	</cffunction>
	
	<cffunction name="DeleteTaxonomy">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userObj" required="true">
		
		<cfset var lcl = structnew()>
		<cfset var mdl = getTaxonomymodel(requestObject, userObj)>
		
		<!---<cfset mdl.load(requestObject.getformurlvar('id'))>--->
				
		<cfif NOT requestObject.isformurlvarset('id')>
			<cfthrow message="id not provided to delete news">
		</cfif>

		<cfif mdl.delete(requestObject.getformurlvar('id'))>
			<!---<cfset lcl.fs = createObject('component','utilities.filesystem').init()>
			<cfif lcl.filename NEQ "">
				<cfset lcl.fs = createObject('component','utilities.filesystem').init()>
				<cfset lcl.siteinfo = application.sites.getSite(arguments.userObj.getCurrentSiteId())>
				<cfset fs.delete(lcl.siteinfo.machineRoot & 'docs/news/' & lcl.filename)>
			</cfif>--->
			<cfset lcl.msg = structnew()>
			<cfset lcl.msg.message = "The Taxonomy Item has been deleted">
			<cfset lcl.msg.ajaxupdater = structnew()>
			<cfset lcl.msg.ajaxupdater.url = "/taxonomies/Browse/">
			<cfset lcl.msg.ajaxupdater.id = 'browse_content'>
			<cfset lcl.msg.htmlupdater = structnew()>
			<cfset lcl.msg.htmlupdater.id = "rightContent">
			<cfset lcl.msg.htmlupdater.HTML = "<div id='msg'>Taxonomy Item Deleted</div>">
			<cfset displayObject.sendJson( lcl.msg )>
		<cfelse>
			<cfset lcl.msg = structnew()>
			<cfset lcl.msg.validation = mdl.getValidator().getErrors()>
			<cfset displayObject.sendJson( lcl.msg )>
		</cfif>
	</cffunction>
	
	<cffunction name="DeleteTaxonomyItem">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userObj" required="true">
		
		<cfset var lcl = structnew()>
		<cfset var mdl = gettaxonomyItemsmodel(requestObject, userObj)>
		
		<!---<cfset mdl.load(requestObject.getformurlvar('id'))>--->
				
		<cfif NOT requestObject.isformurlvarset('id')>
			<cfthrow message="id not provided to delete tax item">
		</cfif>

		<cfif mdl.delete(requestObject.getformurlvar('id'))>
			<!---<cfset lcl.fs = createObject('component','utilities.filesystem').init()>
			<cfif lcl.filename NEQ "">
				<cfset lcl.fs = createObject('component','utilities.filesystem').init()>
				<cfset lcl.siteinfo = application.sites.getSite(arguments.userObj.getCurrentSiteId())>
				<cfset fs.delete(lcl.siteinfo.machineRoot & 'docs/news/' & lcl.filename)>
			</cfif>--->
			<cfset lcl.msg = structnew()>
			<cfset lcl.msg.message = "The Taxonomy Item has been deleted">
			<cfset lcl.msg.ajaxupdater = structnew()>
			<cfset lcl.msg.ajaxupdater.url = "/taxonomies/BrowseItem/?taxid=#requestObject.getFormUrlVar("taxid")#">
			<cfset lcl.msg.ajaxupdater.id = 'browse_content'>
			<cfset lcl.msg.htmlupdater = structnew()>
			<cfset lcl.msg.htmlupdater.id = "rightContent">
			<cfset lcl.msg.htmlupdater.HTML = "<div id='msg'>Taxonomy Item Deleted</div>">
			<cfset displayObject.sendJson( lcl.msg )>
		<cfelse>
			<cfset lcl.msg = structnew()>
			<cfset lcl.msg.validation = mdl.getValidator().getErrors()>
			<cfset displayObject.sendJson( lcl.msg )>
		</cfif>
	</cffunction>
	
	<cffunction name="SaveTaxonomy">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">
		
		<cfset var lcl = structnew()>
		<cfset var mdl = getTaxonomymodel(requestObject, userobj)>
		<cfset var requestvars = requestobject.getallformurlvars()>

		<cfset mdl.setValues(requestVars)>
			
		<cfif mdl.save()>
			<cfset lcl.id = mdl.getId()>
			<cfset lcl.msg = structnew()>
            
			<cfif requestObject.isformurlvarset('id') AND requestObject.getformurlvar('id') NEQ "">
				<cfset lcl.msg.message = "Updated Taxonomy Item">
            <cfelse>
            	<cfset lcl.msg.message = "Saved Taxonomy Item">
                <cfset lcl.msg.switchtoedit = lcl.id>
			</cfif>
            
			<cfset lcl.msg.ajaxupdater = structnew()>
            <cfset lcl.msg.ajaxupdater.url = "/taxonomies/Browse/?id=#lcl.id#">
            <cfset lcl.msg.ajaxupdater.id = 'browse_content'>
			
			<cfset displayObject.sendJson( lcl.msg )>
		<cfelse>
			<cfset lcl.msg = structnew()>
			<cfset lcl.msg.validation = mdl.getValidator().getErrors()>
			<cfset displayObject.sendJson( lcl.msg )>
		</cfif>
	</cffunction>
	
	<cffunction name="SaveTaxonomyItem">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">
		
		<cfset var lcl = structnew()>
		<cfset var mdl = gettaxonomyItemsModel(requestObject, userobj)>
		<cfset var requestvars = requestobject.getallformurlvars()>
	
		<cfset mdl.setValues(requestVars)>
			
		<cfif mdl.save()>
			<cfset lcl.id = mdl.getId()>
			<cfset lcl.msg = structnew()>
            
			<cfif requestObject.isformurlvarset('id') AND requestObject.getformurlvar('id') NEQ "">
				<cfset lcl.msg.message = "Updated Taxonomy Item">
            <cfelse>
            	<cfset lcl.msg.message = "Saved Taxonomy Item">
                <cfset lcl.msg.switchtoedit = lcl.id>
			</cfif>
            
			<cfset lcl.msg.ajaxupdater = structnew()>
            <cfset lcl.msg.ajaxupdater.url = "/taxonomies/BrowseItem/?id=#lcl.id#&taxid=#requestvars.taxonomyid#">
            <cfset lcl.msg.ajaxupdater.id = 'browse_content'>
			
			<cfset displayObject.sendJson( lcl.msg )>
		<cfelse>
			<cfset lcl.msg = structnew()>
			<cfset lcl.msg.validation = mdl.getValidator().getErrors()>
			<cfset displayObject.sendJson( lcl.msg )>
		</cfif>
	</cffunction>
	
	<cffunction name="Search">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userObj" required="true">

		<cfset var mdl = getTaxonomymodel(requestObject, userObj)>
		<cfset var srch = structnew()>
		<cfset displayObject.setData('browse', mdl.getAll())>
		
		<cfset srch.name = arguments.requestObject.getFormUrlVar('searchkeyword')>
		<cfset displayObject.setData('searchResults', mdl.like(srch))>
	</cffunction>
	<cffunction name="Browse">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userObj" required="true">
		
		<cfset var mdl = getTaxonomymodel(requestObject, userObj)>
		
		<cfset displayObject.setData('browse', mdl.getAll())>
		<cfset displayObject.showHTML( displayObject.renderTemplateItem("browse") )>
	</cffunction>
	
	<cffunction name="BrowseItem">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userObj" required="true">
		
		<cfset var mdl = gettaxonomyItemsModel(requestObject, userObj)>
		<cfset var taxid = requestObject.getFormUrlVar("taxid")>
		<cfset var sortstruct = structnew()>
		<cfset sortstruct.orderby = "sortkey">
		<cfset displayObject.setData('browse', mdl.getByTaxonomyId(taxid, sortstruct))>

		<cfset displayObject.showHTML( displayObject.renderTemplateItem("browseItem") )>
	</cffunction>
	
	<cffunction name="TaxonomyMenus">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">
		
		<cfset var mdl = getMenumodel(requestObject, userObj)>
				
		<cfset displayObject.setData('browse', mdl.getAll())>
	</cffunction>
	
	<cffunction name="BrowseMenu">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userObj" required="true">
		
		<cfset var mdl = getMenuModel(requestObject, userObj)>
		<cfset var sortstruct = structnew()>
		<cfset sortstruct.orderby = "sortkey">
		<cfset displayObject.setData('browse', mdl.getAll())>

		<cfset displayObject.showHTML( displayObject.renderTemplateItem("browseMenu") )>
	</cffunction>
	
	<cffunction name="addTaxonomyMenu">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">
	
		<cfset var menumdl = getMenuModel(requestObject, userObj)>
		<cfset var temp = structnew()>	
				
		<cfset displayObject.setData('browse', menumdl.getAll())>
			
		<cfif requestObject.isformurlvarset('id')>
			<cfset displayObject.setData('history', queryNew("hi"))>
			<cfset cx = menumdl.load(requestObject.getformurlvar('id'))>
			<cfset displayObject.setData('taxonomymenumdl', menumdl	)>
			<cfset displayObject.setData('taxonomyiteminfo', menumdl.getMenuDetails(requestObject.getformurlvar('id')))>
			<cfset displayObject.setData('taxonomyitemsmdl', gettaxonomyitemsModel(requestObject, userObj))>
		<cfelse>
			<cfset menumdl.load(0)>
			<cfset displayObject.setData('taxonomymenumdl', menumdl)>
			<cfset displayObject.setData('taxonomyiteminfo', querynew(""))>
			<cfset displayObject.setData('taxonomyitemsmdl', gettaxonomyitemsModel(requestObject, userObj))>
		</cfif>
	
	</cffunction>
	
	<cffunction name="editTaxonomyMenuOrder">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">
	
		<cfset var menumdl = getMenuModel(requestObject, userObj)>
		<cfset var taxmdl = getTaxonomyModel(requestObject, userObj)>
		<cfset var temp = structnew()>	
				
		<cfset displayObject.setData('browse', menumdl.getAll())>
		<cfset displayObject.setData('taxonomylist', taxmdl.getAll())>
			
		<cfset displayObject.setData('taxonomyiteminfo', menumdl.getMenuDetails(requestObject.getformurlvar('id')))>

	</cffunction>
	
	<cffunction name="editTaxonomyMenu">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userObj" required="true">
		<cfargument name="dispatcher" required="true">
		<cfreturn addTaxonomyMenu(displayObject,requestObject,userObj,dispatcher)>
	</cffunction>
	
	<cffunction name="DeleteMenu">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userObj" required="true">
		
		<cfset var lcl = structnew()>
		<cfset var mdl = getMenumodel(requestObject, userObj)>
		
		<!---<cfset mdl.load(requestObject.getformurlvar('id'))>--->
				
		<cfif NOT requestObject.isformurlvarset('id')>
			<cfthrow message="id not provided to delete menu">
		</cfif>

		<cfif mdl.delete(requestObject.getformurlvar('id'))>
			<!---<cfset lcl.fs = createObject('component','utilities.filesystem').init()>
			<cfif lcl.filename NEQ "">
				<cfset lcl.fs = createObject('component','utilities.filesystem').init()>
				<cfset lcl.siteinfo = application.sites.getSite(arguments.userObj.getCurrentSiteId())>
				<cfset fs.delete(lcl.siteinfo.machineRoot & 'docs/news/' & lcl.filename)>
			</cfif>--->
			<cfset lcl.msg = structnew()>
			<cfset lcl.msg.message = "The Taxonomy Menu has been deleted">
			<cfset lcl.msg.ajaxupdater = structnew()>
			<cfset lcl.msg.ajaxupdater.url = "/taxonomies/BrowseMenus/">
			<cfset lcl.msg.ajaxupdater.id = 'browse_content'>
			<cfset lcl.msg.htmlupdater = structnew()>
			<cfset lcl.msg.htmlupdater.id = "rightContent">
			<cfset lcl.msg.htmlupdater.HTML = "<div id='msg'>Taxonomy Menu Deleted</div>">
			<cfset displayObject.sendJson( lcl.msg )>
		<cfelse>
			<cfset lcl.msg = structnew()>
			<cfset lcl.msg.validation = mdl.getValidator().getErrors()>
			<cfset displayObject.sendJson( lcl.msg )>
		</cfif>
	</cffunction>
	
	<cffunction name="saveTaxonomyMenuOrder">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userObj" required="true">
		
		<cfset var lcl = structnew()>
		<cfset var mdl = getMenumodel(requestObject, userObj)>
		<cfset var itemsmdl = getMenuItemsModel(requestObject, userObj)>
		<cfset var favitemsmdl = gettaxonomyMenuFavoritesModel(requestObject, userObj)>
		<cfset lcl.order = mdl.getMenuDetails(requestObject.getformurlvar('id'))>

		<cfset lcl.orderstruct = structnew()>
	
		<cfloop query="lcl.order">
			<cfset lcl.orderstruct[lcl.order.tmitaxonomyid] = lcl.order.tmiid>
		</cfloop>
			
		<cfset lcl.count = 1>
	
		<cfloop list="#requestObject.getFormUrlVar("menuorder")#" index="lcl.idx">
			<cfif structkeyexists(lcl.orderstruct, lcl.idx)>
				<cfset itemsmdl.load(lcl.orderstruct[lcl.idx])>
				<cfset itemsmdl.setSortOrder(lcl.count)>
				<cfset itemsmdl.save()>
				<cfoutput>unmark #lcl.orderstruct[lcl.idx]#<br></cfoutput>
				<cfset structdelete(lcl.orderstruct, lcl.idx)>
			<cfelse>
				<cfset itemsmdl.clear()>
				<cfset itemsmdl.setSortOrder(lcl.count)>
				<cfset itemsmdl.setTaxonomyId(lcl.idx)>
				<cfset itemsmdl.setTaxonomyMenuId(requestObject.getformurlvar('id'))>
				<cfset itemsmdl.save()>	
			</cfif>
			<cfset lcl.count = lcl.count + 1>
		</cfloop>
				
		<cfloop collection="#lcl.orderstruct#" item="lcl.idx">
			<!--- remove children --->
			<cfset lcl.list = favitemsmdl.getByTaxonomyMenuItemId(lcl.orderstruct[lcl.idx])>
			<cfloop query="lcl.list">
				<cfset favitemsmdl.delete(lcl.list.id)>
			</cfloop>
			<!--- remove item --->
			<cfset r = itemsmdl.delete(lcl.orderstruct[lcl.idx])>
		</cfloop>

		<cfset userObj.setFlash("Menu Item Order Updated")>
		
		<cfset lcl.msg = structnew()>
		<cfset lcl.msg.relocate = "../edittaxonomymenu/?id=#requestObject.getFormUrlvar("id")#">
		
		<cfset displayObject.sendJson( lcl.msg )>
	</cffunction>
	
	<cffunction name="SaveTaxonomyMenu">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">
		
		<cfset var lcl = structnew()>
		<cfset var mdl = getMenuModel(requestObject, userobj)>
		<cfset var itemsmdl = getMenuItemsmodel(requestObject, userobj)>
		<cfset var favmdl = getTaxonomyMenuFavoritesModel(requestObject, userobj)>
		<cfset var requestvars = requestobject.getallformurlvars()>
		
		
		<cfset mdl.setValues(requestVars)>
		<cfif mdl.save()>
			<cfset lcl.id = mdl.getId()>
			<cfset lcl.msg = structnew()>
            
			<cfif requestObject.isformurlvarset('id') AND requestObject.getformurlvar('id') NEQ "">
				<cfset lcl.msg.message = "Updated Taxonomy Item">
            <cfelse>
            	<cfset lcl.msg.message = "Saved Taxonomy Item">
                <cfset lcl.msg.switchtoedit = lcl.id>
			</cfif>
            
			<!--- <cfset lcl.msg.ajaxupdater = structnew()>
            <cfset lcl.msg.ajaxupdater.url = "/taxonomies/Browse/?id=#lcl.id#">
            <cfset lcl.msg.ajaxupdater.id = 'browse_content'> --->
			<cfset items = itemsmdl.getByTaxonomyMenuId(requestObject.getFormUrlVar("id"))>
	
			<cfoutput query="items">
				<cfset lcl.deleteable = favmdl.getByTaxonomyMenuItemId(items.id)>
				<cfloop query = "lcl.deleteable">
					<cfset favmdl.delete(lcl.deleteable.id)>
				</cfloop>
				<cfloop list="#requestObject.getFormUrlVar(replace(items.id,'-','_',"all") & "_tmi_id")#" index="lcl.idx">
					<cfset favmdl.clear()>
					<cfset favmdl.setTaxonomyMenuItemId(items.id)>
					<cfset favmdl.setTaxonomyItemId(lcl.idx)>
					<cfset favmdl.save()>
				</cfloop>
			</cfoutput>
			
			<cfset lcl.msg.message = "Updated Taxonomy Menu">
			<cfset displayObject.sendJson( lcl.msg )>
			<cfset displayObject.sendJson( lcl.msg )>
		<cfelse>
			<cfset lcl.msg.validation = mdl.getValidator().getErrors()>
			<cfset displayObject.sendJson( lcl.msg )>
		</cfif>

	</cffunction>
	
	<cffunction name="editClientModule">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">

		<cfset var editableModel = createObject('component', 'taxonomies.models.editable').init(requestObject, userobj)>
		<cfset var menusModel = getMenuModel(arguments.requestObject, arguments.userObj)>
	
		<cfset displayObject.setData('editableModel', editablemodel)>
		<cfset displayObject.setData('menusModel', menusModel)>
	</cffunction>
	
	<cffunction name="saveClientModule">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">

		<cfset var model = createObject('component', 'taxonomies.models.editable').init(requestObject, userobj)>
		<cfset var lcl = structnew()>
		<cfset var requestvars = requestobject.getallformurlvars()>
	
		<cfset model.setValues(requestVars)>
	
		<cfif model.save()>
			<cfset lcl.reloadBase = 1>
			<cfset displayObject.sendJson( lcl )>
		<cfelse>
			<cfset lcl.msg = structnew()>
			<cfset lcl.msg.validation = model.getValidator().getErrors()>
			<cfset displayObject.sendJson( lcl.msg )>
		</cfif>
	</cffunction>
	

</cfcomponent>
