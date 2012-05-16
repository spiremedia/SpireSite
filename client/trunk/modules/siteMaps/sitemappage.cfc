<cfcomponent name="sitemappage" extends="resources.page">
	<cfsetting requesttimeout="2400">
	
	<cffunction name="postObjectLoad">
		<!--- Say CHEESE! --->
		
		<cfset var view = this.getField('show')>
		<cfset var sitemap = "">
		<cfset var args = structnew()>
		<cfset var data = structnew()>
		<cfset var siteurl = variables.requestObject.getVar('siteurl')>
		<cfset var dataCat = structnew()>
		<cfif view EQ 'sitemap'>
			<cfset data = variables.getSiteMap().getSitePages()>
		
			<cfquery name="data" dbtype="query">
				SELECT * FROM data WHERE searchindexable = 1
			</cfquery>

			<cfquery name="moreData" datasource="#requestObject.getVar("dsn")#" >
				SELECT 
					prod.urlname, prod.modified , menus.name 
				FROM 
					products prod,
					taxonomyRelations tr,
					taxonomyMenus menus,
					taxonomyItems ti
				WHERE tr.taxonomyItemId = ti.id
				AND prod.active = 1
				and prod.deleted = 0
				AND menus.basetaxonomyitemid = ti.id
				AND tr.siteid = <cfqueryparam value="#requestObject.getVar("siteid")#" cfsqltype="cf_sql_varchar">
				AND tr.relationId = prod.id
			</cfquery>

			<cfsavecontent variable="content"><?xml version="1.0" encoding="UTF-8"?>
				<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
				<cfoutput query="data">
				   <url>
					  <loc>#siteurl##displayurlpath#</loc>
					  <lastmod>#dateformat(modifieddate,'YYYY-MM-DD')#</lastmod>
				   </url>
				</cfoutput>

				<cfset i = 1>
				<cfoutput query="moreData">
				 <url>
					  <loc>#siteurl##lCase(replace(name," & ","-","all"))#/product/#urlname#/</loc>
	  				 <lastmod>#dateformat(modified,'YYYY-MM-DD')#</lastmod>   
				</url>
				<cfscript>
					i++;
				</cfscript>

				</cfoutput>


				</urlset> 
			</cfsavecontent>
		<cfelse>
			<cfset content = "Sitemap : #siteurl#sitemapxml">
		</cfif>
	
		<cfset data = structnew()>
		<cfset data.content = content>
	
		<cfset addObjectByModulePath('onecontent', 'simplecontent', "", data, "default")>
	
	</cffunction>
	
</cfcomponent>