<cfcomponent extends="modules.search.models.basecollection">
    
    <cffunction name="checkExists" outpout="false">
		<cfset var qryCollections = "">
		
		<cftry>
			<cfsearch
			name="searchItems"
			collection="#variables.collectionname#"
			criteria="#createUUID()#"
			/>
			<cfcatch type="any">
				<cfif cfcatch.message contains "does not exist">
					 <cfcollection categories="true" engine="solr" action="create" collection="#variables.collectionname#" path="#variables.requestObject.getVar('collectionPath')#">
				<cfelse>
					<cfrethrow>
				</cfif>
			</cfcatch>
		</cftry>

	</cffunction>
	
	<cffunction name="getindexer">
		<cfargument name="type" required="true">
		<cfreturn createObject("component","modules.search.models.cfsolr#type#indexer").init(requestobject)>
	</cffunction>
	
	 
	<cffunction name="searchSite" output="false">
		<cfargument name="crit">
		<cfset var result = "">
		<cfset var machineroot = requestObject.getVar('machineRoot')>
		
		
		<!--- <cfif variables.criteria EQ "or">
			<cfset variables.criteria = '"or"'>
		</cfif>
		
		<cfif refindnocase("^or .", variables.criteria)>
			<cfset variables.criteria = '"or" ' & mid(variables.criteria, 3, len(variables.criteria))>
		</cfif>
		
		<cfif refindnocase(". or$", variables.criteria)>
			<cfset variables.criteria =  mid(variables.criteria, 1, len(variables.criteria) - 3) & ' "or"'>
		</cfif> --->
		
		<cftry>
			<cfsearch name="result"
				collection="#variables.collectionName#" 
					criteria="#lcase(arguments.crit.criteria)#"
						category="#arguments.crit.categories#">
			<cfcatch>
				<cfif findnocase("Invalid search criteria",cfcatch.message)>
					<cfset variables.error = true>
					<cfreturn>
				<cfelse>
					<cfrethrow>
				</cfif>
			</cfcatch>
		</cftry>

		<cfset variables.totalSearchRecords = result.recordcount>

		<cfloop query="result">
			<!--- <cfset result.url[currentrow] = replace(result.key, machineroot, "")> --->
			<cfset result.url[currentrow] = replace(result.url, "\", "/", "all")>
		</cfloop>
							
		<cfset lcl.searchresultObj = createobject('component', "modules.search.models.searchresult").init(requestObject)>
		<cfset lcl.searchresultObj.setRecordsFound(lcl.totalSearchRecords)>
		<cfset lcl.searchresultObj.setSearchRs(result)>
		<cfset lcl.searchresultObj.setCriteria(arguments.crit.criteria)>
		<cfset lcl.searchresultObj.setChopped(0)>

		<cfset lcl.searchresultObj.save()>
		
        <cfreturn lcl.searchresultObj>
	</cffunction>
    <!--- 
    <cffunction name="loadIndexables" output="true">
		<cfargument name="aggregator" required="yes">
		
		<cfset loadPageIndexables(aggregator)>
		<cfset loadFileIndexables(aggregator)>
		<cfabort>
	</cffunction> 	
	
	<cffunction name="loadPageIndexables" output="true">
		<cfargument name="aggregator" required="yes">
		<cfset var lcl = structnew()>
		
		<cfset lcl.q = querynew("key,urlpath,title,custom1,custom2,custom3,custom4,body")>
		
		<cfloop array="#aggregator.getPageIndexables()#" index="lcl.itm">
			<cfset queryaddrow(lcl.q)>
			<cfset querysetcell(lcl.q, 'key', 	lcl.itm.getKey())>
			<cfset querysetcell(lcl.q, 'urlpath',	"/" & lcl.itm.getPath() )>
			<cfset querysetcell(lcl.q, 'title',	lcl.itm.getTitle() )>
			<cfset querysetcell(lcl.q, 'custom1',	lcl.itm.getDescription() )>
			<cfset querysetcell(lcl.q, 'custom2',	'')>
			<cfset querysetcell(lcl.q, 'custom3',	'')>
			<cfset querysetcell(lcl.q, 'custom4',	'')>
			<cfset querysetcell(lcl.q, 'body', 	lcl.itm.getPageHtml(requestObject.getVar('siteurl')) )>
		</cfloop>

		<cfif lcl.q.recordcount>
			<cfindex action="update" 
				status="r"
				collection="#variables.collectionName#" 
				query="lcl.q"
				key="key"
				type="custom"
				urlpath = "urlpath"
				title="title"
				custom1="custom1"
				custom2="custom2"
				custom3="custom3"
				custom4="custom4"
				body="custom1,custom2,custom3,custom4,body">
				
			Pages indexed
			<ul>
			<cfoutput query="lcl.q">
				<li>#title# #urlpath#</li>
			</cfoutput>
			</ul>
			<cfdump var="#r#">
		<cfelse>
			<div>No pages indexed.</div>
		</cfif>
	
	</cffunction>
	
	<cffunction name="loadFileIndexables" output="true">
		<cfargument name="aggregator" required="yes">
		<cfset var lcl = structnew()>
		
		<cfset lcl.q = querynew("key,urlpath,title,custom1,custom2,custom3,custom4")>
		
		<cfloop array="#aggregator.getFileIndexables()#" index="lcl.itm">
			<cfset queryaddrow(lcl.q)>
			<cfset querysetcell(lcl.q, 'key', 	lcl.itm.getPath(requestObject.getVar('cmsmachineroot')) )>
			<!--- <cfset querysetcell(lcl.q, 'urlpath',	> --->
			<cfset querysetcell(lcl.q, 'title',	lcl.itm.getTitle() )>
			<cfset querysetcell(lcl.q, 'custom1',	lcl.itm.getDescription() )>
			<cfset querysetcell(lcl.q, 'custom2',	'')>
			<cfset querysetcell(lcl.q, 'custom3',	'')>
			<cfset querysetcell(lcl.q, 'custom4',	'')>
		</cfloop>

		<cfif lcl.q.recordcount>
			<cfindex action="update" 
				status="r"
				collection="#variables.collectionName#" 
				query="lcl.q"
				key="key"
				type="file"
				urlpath = "urlpath"
				title="title"
				custom1="custom1"
				custom2="custom2"
				custom3="custom3"
				custom4="custom4"
				extensions="extensions">
			Files Indexed
			<ul>
			<cfoutput query="lcl.q">
				<li>#key#</li>
			</cfoutput>
			</ul>
			<cfdump var="#r#">
		<cfelse>
			<div>No files indexed.</div>
		</cfif>
	</cffunction>	
	
	 --->
		    
    <cffunction name="purge">
    	<cftry>
			<cfindex action="purge" collection="#variables.collectionName#">
			<cfcatch></cfcatch>
		</cftry>
    </cffunction>
    
    <cffunction name="optimize">
		<cfcollection action="optimize" collection="#variables.collectionName#"> 
	</cffunction> 
   	
</cfcomponent>