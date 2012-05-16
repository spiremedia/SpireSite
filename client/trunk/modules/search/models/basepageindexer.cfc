<cfcomponent name="base page indexer" extends="resources.abstractmodel">
	
	<cffunction name="init">
    	<cfargument name="requestObject" required="yes">
        <cfset variables.requestObject = arguments.requestObject>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="setCollection">
		<cfargument name="collectionobj" required="true">
		<cfset variables.collectionobj = collectionobj>
    </cffunction>
		
 	<cffunction name="getPageHtml" output="false">
		<cfset var lcl = structnew()>
		<cfset lcl.r = structnew()>
		<cfhttp method="get" url="#requestObject.getVar("siteurl") & variables.indexableObject.getpath()#" result="lcl.pageinfo" redirect="false">
		<!---<cfdump var="#requestObject.getVar("siteurl") & variables.indexableObject.getpath()#">
		<cfdump var=#lcl.pageinfo#>
		<cfabort>--->
        <cfif left(lcl.pageinfo.Statuscode,3) NEQ "200">>
			<cfset lcl.status = "nok">
			<cfset lcl.error = "status code WAS #lcl.pageinfo.statuscode#">
		<cfelseif findnocase("cfdump", lcl.pageinfo.filecontent)>
			<cfset lcl.status = "nok">
			<cfset lcl.error = "found cfdump">
        <cfelse>
			<cfset lcl.status = "ok">
			<cfset lcl.html = processHTML(lcl.pageinfo.filecontent)>
        </cfif>
		<cfreturn lcl>
	</cffunction>
	
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
		<cfset html = rereplace(html, "<!-- nosearch -->.*?<!-- /nosearch -->", " ", "all")><!--- remove <!-- header -->...<!-- /header --> --->
		<cfset html = rereplace(html, "<[^>]+>"," ","all")>
		<cfset html = replace(html, chr(13), " ","all")>
		<cfset html = replace(html, chr(10), " ","all")>
		<cfset html = replace(html, chr(9), " ","all")>
		<cfset html = rereplace(html, "[ ][ ]+", " ","all")>
		<cfreturn html>
	</cffunction>
     
</cfcomponent>