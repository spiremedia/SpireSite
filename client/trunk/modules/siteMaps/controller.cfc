<cfcomponent extends="resources.abstractController" ouput="false">
	
    <cffunction name="init" output="false">
		<cfset super.init(argumentcollection = arguments)>
		<cfset variables.sitemap = pageref.getSiteMap().getSitePages()>
		<cfquery name="variables.sitemap" dbtype="query">
			SELECT * FROM variables.sitemap WHERE searchindexable = 1  AND displayurlpath != '/SiteMap/'
		</cfquery>
		<cfreturn this>
	</cffunction>

	<cffunction name="showHTML" output="false">
		<cfset var lcl = structNew()>			
		<cfsavecontent variable="lcl.html">
			<cfinclude template="templates/sitemaps.cfm">
		</cfsavecontent>		
		<cfreturn lcl.html>
	</cffunction>

	<cffunction name="getSiteMapByLevel" output="false">
		<cfargument name="level" default="1">
		<cfset var lcl = structNew()>
            
		<cfquery name="lcl.sitemap" dbtype="query">
			SELECT * FROM variables.sitemap 
			WHERE [level] = <cfqueryparam value="#arguments.level#" cfsqltype="cf_sql_integer">
			ORDER BY sort
		</cfquery>
		
		<cfreturn lcl.sitemap>
	</cffunction>

	<cffunction name="getSiteMapByParentId" output="false">
		<cfargument name="parentid">
		<cfset var lcl = structNew()>
		<cfset lcl.html = ''>
            
		<cfquery name="lcl.sitemap" dbtype="query">
			SELECT * FROM variables.sitemap 
			WHERE parentid = <cfqueryparam value="#arguments.parentid#">
			ORDER BY sort
		</cfquery>
			
		<cfif lcl.sitemap.recordcount>
			<cfset lcl.html = lcl.html & '<ul>'>
				<cfoutput query="lcl.sitemap">
					<cfset lcl.html = lcl.html & '<li><a href="#displayurlpath#" >#title#</a></li>'>
					<cfset lcl.html = lcl.html & getSiteMapByParentId(parentid = id)>
				</cfoutput> 
			<cfset lcl.html = lcl.html & '</ul>'>
		</cfif>
		
		<cfreturn lcl.html>
	</cffunction>
	
	<cffunction name="getCacheLength">
		<cfreturn 0>
	</cffunction>
</cfcomponent>