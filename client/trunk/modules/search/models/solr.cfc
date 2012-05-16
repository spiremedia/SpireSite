<cfcomponent name="solrsearch" extends="modules.search.models.basecollection">
	    
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
		<cfreturn createObject("component","modules.search.models.solr#type#indexer").init(requestobject)>
	</cffunction>
	
	<cffunction name="searchSite" output="false">
		<cfargument name="crit" required="true">
		<cfargument name="rows" required="true">
		<cfset var lcl = structnew()>
		<cfset lcl.machineroot = requestObject.getVar('machineRoot')>
		<cfset lcl.start = requestObject.getFormUrlVar("dd",1)>
		<cfset lcl.rows = arguments.rows>
		<cfset lcl.start = (lcl.start -1) * lcl.rows>
		<cfset lcl.murl = "/solr/#variables.collectionName#/select?">
		
		<cfset lcl.more = structnew()>
		<cfset lcl.more.q = lcase(arguments.crit.criteria)>
		<cfset lcl.more.indent = "on">
		<cfset lcl.more.fl = "key,uid,url,title,mime,size,summary,score,contents,spell,custom1,custom2,custom3,custom4,category,categorytree,category">
		<!---<cfset lcl.more.facet = "true">
		 <cfset lcl.more.['facet.field'] = "category"> --->
		<!--- <cfset lcl.more['facet.query'] = arguments.crit.categories> --->
		<cfset lcl.more.fq = arguments.crit.categories>
		<cfset lcl.more.qt = "standard">
		<cfset lcl.more.start = lcl.start>
		<cfset lcl.more.rows = lcl.rows>
		
		<cfif structkeyexists(arguments.crit,"sort")>
			<cfset lcl.dir = iif(arguments.crit.sort.field NEQ arguments.crit.sort.dir AND listfind("up,down", arguments.crit.sort.dir), "arguments.crit.sort.dir", DE("up"))>
			<cfset lcl.more.sort = arguments.crit.sort.field & ' ' & replacelist(lcl.dir, 'up,down', 'asc,desc')>
		</cfif>
		
		<cfloop collection="#lcl.more#" item="lcl.moreitm">
			<cfset lcl.murl = lcase(lcl.murl) & lcl.moreitm & "=" & urlencodedformat(lcl.more[lcl.moreitm]) & "&">
		</cfloop>
	
		<cfhttp 
			charset="utf-8" 
				url="#lcl.murl#" 
					method="GET" 
						resolveurl="false" 
							redirect="false" 
								result="lcl.httpresult" 
									throwOnError="false" 
										port="8983"/>
		<cfif left(lcl.httpresult.statuscode, 3) NEQ "200" OR requestObject.getFormUrlVar("debug","0") EQ "1">
			ERROR SEARCHING
			<cfdump var=#lcl.more#>
			<cfdump var=#lcl.murl#>
			<cfdump var=#lcl.httpresult#>
			<cfabort>
		</cfif>
		
		<cfset lcl.result = xmlparse(lcl.httpresult.filecontent)>
				
		<cfset lcl.fieldlist = xmlsearch(lcl.result,"//response/lst/lst/str[@name='fl']")>
		<cfset lcl.fieldlist = lcl.fieldlist[1].xmltext>
		

		<cfset lcl.totalSearchRecords = lcl.result.response.result.xmlattributes.numfound>
		
		<cfset lcl.queryresult = querynew(lcl.fieldlist)>
		<cfset lcl.results = xmlsearch(lcl.result,"//response/result/doc")>
		
		<cfloop array="#lcl.results#" index="lcl.resultitem">
			<cfset queryaddrow(lcl.queryresult)>
			<cfloop array="#lcl.resultitem.xmlchildren#" index="lcl.resultitemfield">
				<cfset querysetcell(lcl.queryresult, lcl.resultitemfield.xmlattributes.name, lcl.resultitemfield.xmltext)>
			</cfloop>
		</cfloop>

		<cfloop query="lcl.queryresult">
			<!--- <cfset result.url[currentrow] = replace(result.key, machineroot, "")> --->
			<cfset lcl.queryresult.url[currentrow] = replace(lcl.queryresult.url, "\", "/", "all")>
		</cfloop>
							
		<cfset lcl.searchresultObj = createobject('component', "modules.search.models.searchresult").init(requestObject)>
		<cfset lcl.searchresultObj.setRecordsFound(lcl.totalSearchRecords)>
		<cfset lcl.searchresultObj.setSearchRs(lcl.queryresult)>
		<cfset lcl.searchresultObj.setCriteria(arguments.crit.criteria)>
		<cfset lcl.searchresultObj.setChopped(1)>
		
		<cfset lcl.searchresultObj.save()>
		
        <cfreturn lcl.searchresultObj>
	</cffunction>
    
    <cffunction name="optimize">
		<cfhttp 
			charset="utf-8" 
				url="/solr/#getName()#/update?optimize=true&maxSegments=10&waitFlush=true" 
					method="get" 
						resolveurl="false" 
							redirect="false" 
								result="lcl.result" 
									port="8983">
		<cfif lcl.result.statuscode NEQ "200 OK">
			ERROR OPTIMIZING!
			<cfdump var=#lcl.result#>
			<cfabort>
		</cfif>
	</cffunction> 

	<cffunction name="commit">
		<cfhttp 
			charset="utf-8" 
				url="/solr/#getName()#/update?stream.body=%3Ccommit/%3E" 
					method="get" 
						resolveurl="false" 
							redirect="false" 
								result="lcl.result" 
									port="8983">
		<cfif lcl.result.statuscode NEQ "200 OK">
			ERROR COMMITTING!
			<cfdump var=#lcl.result#>
			<cfabort>
		</cfif>
	</cffunction>
	
	<cffunction name="purge">
		<cfhttp 
			charset="utf-8" 
				url="/solr/#getName()#/update" 
					method="POST" 
						resolveurl="false" 
							redirect="false" 
								result="lcl.result" 
							 		port="8983">
			<cfhttpparam type="body" value="<delete><query>*:*</query></delete>">
			<cfhttpparam type="header" name="content-type" value="text/xml" >
		</cfhttp>
		<cfif lcl.result.statuscode NEQ "200 OK">
			ERROR PURGING!
			<cfdump var=#lcl.result#>
			<cfabort>
		</cfif>
	</cffunction>
	
	<cffunction name="delete">
		<cfargument name="uid" required="true">
		<cfhttp 
			charset="utf-8" 
				url="/solr/#getName()#/update" 
					method="POST" 
						resolveurl="false" 
							redirect="false" 
								result="lcl.result" 
							 		port="8983">
			<cfhttpparam type="body" value="<delete><id>#arguments.uid#</id></delete>">
			<cfhttpparam type="header" name="content-type" value="text/xml" >
		</cfhttp>
		
		<cfif lcl.result.statuscode NEQ "200 OK">
			ERROR PURGING!
			<cfdump var=#lcl.result#>
			<cfabort>
		</cfif>
		
		<cfset commit()>
	</cffunction>
	
</cfcomponent>