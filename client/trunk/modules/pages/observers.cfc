<cfcomponent name="ordersobservers" extends="resources.abstractobserver">
	
	<cffunction name="search_synchsearchables">
		<cfargument name="observed" required="true">
	
		<cfset var currentPages = "">
		<cfset var indexable = "">
		<cfset var siteurl = variables.requestObject.getVar('siteurl')>
		<cfset var lcl = structnew()>

		<cfquery name="currentpages" datasource="#variables.requestObject.getVar('dsn')#">
			SELECT id,  urlpath, summary, pagename
			FROM publishedPages 
			WHERE siteid = <cfqueryparam value="#variables.requestObject.getVar('siteid')#:published">
			AND pagename not in ('404', 'Search Results')
            AND searchindexable = 1
			AND expired = 0
			ORDER BY len(urlpath)
		</cfquery>
		
        <cfloop query="currentPages">
        	<cfset indexable = observed.newIndexable()>
            <cfset indexable.setObjId(currentpages.id)>
			<cfset indexable.setPath(currentpages.urlpath)>
            <cfset indexable.setTitle(currentpages.pagename)>
            <cfset indexable.setDescription(currentpages.summary)>
			<cfset lcl.thisjson = structnew()>
			<cfif currentpages.urlpath NEQ "">
				<cfset lcl.thisjson.section = arraynew(1)>
				<cfset arrayappend(lcl.thisjson.section, listfirst(currentpages.urlpath,"/"))>
			</cfif>
			<cfset indexable.setTagsjson(serializeJSON(lcl.thisjson))>
			<cfset indexable.setType("page")>
			<cfset indexable.setViewcfc("modules.pages.searchview")>
            <cfset indexable.save()>
        </cfloop>
        
		<cfreturn observed>
	</cffunction>

</cfcomponent>