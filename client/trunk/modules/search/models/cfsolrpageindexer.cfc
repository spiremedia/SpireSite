<cfcomponent name="cfsolr page indexer" extends="modules.search.basepageindexer">

	<cffunction name="process">
		<cfargument name="indexableObj" required="true">
		<cfset variables.indexableObject = arguments.indexableObj>
		<cfset var lcl = structnew()>
		<!--- loadhtml --->
		<cfset lcl.htmlobj = getPageHTML()>
		
		<cfif lcl.htmlobj.status NEQ "ok">
			<cfset variables.indexableObject.setError(lcl.htmlobj.error)>
			<cfset variables.indexableObject.save()>
			<cfreturn>
		<cfelse>
			<cfset variables.indexableObject.setError("")>
			<cfset variables.indexableObject.setTextIndexed(lcl.htmlobj.html)>
		</cfif>
				
		<cfset lcl.tags = deserializejson(variables.indexableObject.getTagsJSON())>
		
		<cfset lcl.tagslist = "">
		
		<cfloop collection="#lcl.tags#" item="lcl.tagitem">
			<cfset lcl.tagcat = lcl.tags[lcl.tagitem]>
			<cfloop array="#lcl.tagcat#" index="lcl.tagitemname">
				<cfset lcl.tagslist = listappend(lcl.tagslist, lcl.tagitemname)>
			</cfloop>
		</cfloop>
			
		<cfindex action="update" 
				status="r"
				collection="#variables.collectionobj.getName()#" 
				key="#variables.indexableObject.getPath()#"
				type="custom"
				custom1="#variables.indexableObject.getDescription()#" 
				custom2="#variables.indexableObject.getObjId()#" 
				custom3="#variables.indexableObject.getViewCfc()#" 
				custom4="#variables.indexableObject.getType()#" 
				title="#variables.indexableObject.getTitle()#"
				body="#variables.indexableObject.getTextIndexed()#"
				category="#lcl.tagslist#">
				
		<cfset variables.indexableObject.setlastIndexed(now())>
		<cfset variables.indexableObject.save()>
	</cffunction>
	
<!--- 
	
	<cffunction name="processHTML" output="false">
		<cfargument name="html">
		<cfset var i = "">
		<!--- multiply hs with appropriate value --->
		<cfloop from="1" to="5" index="i">
			<cfset html = rereplacenocase(html, "<h#i#[^>]*?>(.*?)</h#i#>"," #repeatstring("\1 ", 6-i)# ","all")>
		</cfloop>
		<!--- clear out meta strings --->
		<cfset html = rereplace(html, "\&[a-z]+\;"," ","all")><!--- remove javascript code --->
        <!--- clear out all tags --->
        <cfset html = rereplace(html, "<select[^>]*?>.*?</select>"," ","all")><!--- remove javascript code --->
		<cfset html = rereplace(html, "<select[^>]*?>.*?</select>"," ","all")><!--- remove javascript code --->
		<cfset html = rereplace(html, "<head[^>]*?>.*?</head>"," ","all")><!--- remove stuff between head tags code --->
		<cfset html = rereplace(html, "<script[^>]*?>.*?</script>"," ","all")><!--- remove <select>...</select> --->
		<cfset html = rereplace(html, "<!-- header -->.*?<!-- /header -->", " ", "all")><!--- remove <!-- header -->...<!-- /header --> --->
		<cfset html = rereplace(html, "<!-- footer -->.*?<!-- /footer -->", " ", "all")><!--- remove <!-- header -->...<!-- /header --> --->
		<cfset html = rereplace(html, "<[^>]+>"," ","all")>
		<cfset html = replace(html, chr(13), " ","all")>
		<cfset html = replace(html, chr(10), " ","all")>
		<cfset html = replace(html, chr(9), " ","all")>
		<cfset html = rereplace(html, "[ ][ ]+", " ","all")>
		<cfreturn html>
	</cffunction> --->
    <!--- 
   
	
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
		    
    
</cfcomponent>