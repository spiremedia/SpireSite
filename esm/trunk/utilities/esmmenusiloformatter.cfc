<cfcomponent name="esmmenusiloformatter">
	<cffunction name="getSilo">
		<cfargument name="topid" required="true">
		<cfargument name="selectedid" required="true">
		<cfargument name="allowedLocationIds">
		<cfargument name="userobject">
		<cfargument name="stateobject">
		<cfargument name="sitemapObject">
		
		<cfset var silohtml = "">
		<cfset var formatter = "">
		<cfset var rootallowed = "">
		<cfset var tli = sitemapObject.getTopItem(topid)>

		<cfset variables.userobject = arguments.userobject>
		<cfset variables.stateobject = arguments.stateobject>
		
		<cfset rootallowed = userObject.isPathAllowed(tli.urlpath)>
		
		<cfif variables.stateObject.isvarset("_#userobject.getCurrentSiteId()#_#topid#")>
			<cfset silohtml = variables.stateObject.getVar("_#userobject.getCurrentSiteId()#_#topid#")>
		<cfelse>
			<!--- 
				not found, recreate silo
				store in state
			--->
			<cfset formatter = createObject('component', 'utilities.esmmenuulliformatter').init("noselect")>

			<cfset silohtml = siteMapObject.getTree(variables.userobject, formatter, topid)>
			<cfset variables.stateObject.setVar("_#userobject.getCurrentSiteId()#_#topid#", silohtml)>
		</cfif>

		<cfif NOT (rootallowed OR structkeyexists(allowedlocationids, topid)) >
			<cfset silohtml = setAlloweablesInLinksViaXml(silohtml, allowedLocationIds)>
		</cfif>
		
		<cfreturn silohtml>
	</cffunction>

	<cffunction name="setAlloweablesInLinksViaXml" output="true">
		<cfargument name="localhtml" required="true">
		<cfargument name="alloweableids" required="true">
			
		<cfset var localxml = "">
		<cfset var aid = "">
		<cfset var disabledText = ' class="disabled" onclick="return false;" '>
		<cfset var anchors = "">
		<!--- make each link inactive. We'll reactivate them in xml if they are allowed --->
		
		<cfset localhtml = replace(localhtml, "<a", "<a #disabledText#", "all")>
	
		<cfset localxml = xmlparse(replace(localhtml,'&','&amp;','ALL'))>
	
		<cfloop collection="#alloweableids#" item="aid">		
		
			<cfset anchors = XmlSearch
				(
					localxml,
					'//li[a/@href=''/pages/editPage/?id=#aid#'']/descendant-or-self::li/a'
				)>

			<cfloop from="1" to="#ArrayLen(anchors)#" index="j">
				<cfset StructDelete(anchors[j].XmlAttributes, 'class', false)>
				<cfset StructDelete(anchors[j].XmlAttributes, 'onclick', false)>
			</cfloop>
			
		</cfloop>
		
		<cfset localhtml = tostring(localxml)>
		
		<cfreturn replace(localhtml, '<?xml version="1.0" encoding="UTF-8"?>','')>
	</cffunction>
</cfcomponent>