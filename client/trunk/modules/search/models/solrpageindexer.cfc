<cfcomponent name="cfsolr page indexer" extends="modules.search.models.basepageindexer">
	
	<cffunction name="process" output="true">
		<cfargument name="indexableObj" required="true">
		<cfset var lcl = structnew()>
		
		<cfset variables.indexableObject = arguments.indexableObj>

		<!--- loadhtml --->
		<cfset lcl.htmlobj = getPageHTML()>
		
		<cfif lcl.htmlobj.status NEQ "ok">
			<cfset variables.indexableObject.setError(lcl.htmlobj.error)>
			<cfset variables.indexableObject.setReindex(0)>
			<cfset variables.indexableObject.setlastIndexed(now())>
			<cfif NOT variables.indexableObject.save()>
				<cfdump var=#variables.indexableObject.getValidator().getErrors()#>
				<cfset variables.indexableObject.dump()>
				<cfabort>
			</cfif>
			<cfreturn>
		<cfelse>
			<cfset variables.indexableObject.setError("")>
			<cfset variables.indexableObject.setTextIndexed(lcl.htmlobj.html)>
		</cfif>
		
		<!--- setup xml to post to solr --->
		<cfset lcl.xml = "<add><doc>">
		<cfset lcl.xml = lcl.xml & '<field name="key">#xmlformat(variables.indexableObject.getPath())#</field>'>
		<cfset lcl.xml = lcl.xml & '<field name="url">#requestObject.getVar("siteurl")#</field>'>
		<cfset lcl.xml = lcl.xml & '<field name="title">#xmlformat(variables.indexableObject.getTitle())#</field>'>
		<cfset lcl.xml = lcl.xml & '<field name="custom1">#xmlformat(variables.indexableObject.getDescription())#</field>'>
		<cfset lcl.xml = lcl.xml & '<field name="custom2">#xmlformat(variables.indexableObject.getObjId())#</field>'>
		<cfset lcl.xml = lcl.xml & '<field name="custom3">#xmlformat(variables.indexableObject.getViewCfc())#</field>'>
		<cfset lcl.xml = lcl.xml & '<field name="custom4">#xmlformat(variables.indexableObject.getType())#</field>'>
		<cfset lcl.xml = lcl.xml & '<field name="contents">#xmlformat(variables.indexableObject.getTextIndexed())#</field>'>
		<cfset lcl.xml = lcl.xml & '<field name="modified">#now()#</field>'>
		<cfset lcl.xml = lcl.xml & '<field name="size">#len(variables.indexableObject.getTextIndexed())#</field>'>
		<cfset lcl.xml = lcl.xml & '<field name="uid">#variables.indexableObject.getObjId()#</field>'>
		<cfset lcl.xml = lcl.xml & '<field name="mime">text</field>'>
		
		<!--- populate tagging --->
		<cfset lcl.tags = deserializejson(variables.indexableObject.getTagsJson())>

		<cfloop collection="#lcl.tags#" item="lcl.tagtype">
			<cfset lcl.thistag = lcl.tags[lcl.tagtype]>
			<cfloop array="#lcl.thistag#" index="lcl.thistagitem">
				<cfset lcl.xml = lcl.xml & '<field name="tax_#lcl.tagtype#">#xmlformat(lcl.thistagitem)#</field>'>
			</cfloop>
		</cfloop>
		
		<!--- populate more indexable options --->
		<cfset lcl.moreinfo = variables.indexableObject.getMoreInfoJson()>
		<cfif left(lcl.moreinfo, 1) EQ '{'>
			<cfset lcl.moreindexable = deserializejson(lcl.moreinfo)>
		
			<cfloop collection="#lcl.moreindexable#" item="lcl.moretype">
				<cfset lcl.thismore = lcl.moreindexable[lcl.moretype]>
				<cfloop array="#lcl.thismore#" index="lcl.thismoreitem">
					<cfset lcl.xml = lcl.xml & '<field name="more_#lcase(lcl.moretype)#">#xmlformat(lcl.thismoreitem)#</field>'>
				</cfloop>
			</cfloop>
		</cfif>
		
		<cfset lcl.xml = lcl.xml & '</doc></add>'>
		
		<cfset lcl.xml = replace(lcl.xml, chr(25), "", "all")>
		
		<cfhttp 
			charset="utf-8" 
				url="/solr/#variables.collectionobj.getName()#/update" 
					method="POST" 
						resolveurl="false" 
							redirect="false" 
								result="lcl.result" 
							 		port="8983">
			<cfhttpparam type="body" value="#lcl.xml#">
			<cfhttpparam type="header" name="content-type" value="text/xml" >
		</cfhttp>

		<cfif left(lcl.result.statuscode,3) NEQ 200 OR requestObject.isformUrlvarset("debug")>
			Failed indexing something
			<!--- <cfoutput><textarea style="width:500px;height:400px">#lcl.xml#</textarea></cfoutput> --->
			<cfdump var=#lcl.xml#>
			<cftry>
				<cfdump var=#xmlparse(lcl.xml)#>
				<cfcatch>couldnt parse xml</cfcatch>
			</cftry>
			<cfdump var=#lcl.result#>
			<cfabort>
		</cfif>

		<cfset variables.indexableObject.setlastIndexed(now())>
		<cfset variables.indexableObject.setUpdateXML(lcl.xml)>
		<cfset variables.indexableObject.setReindex(0)>
		<cfif NOT variables.indexableObject.save()>
			<cfdump var=#variables.indexableObject.getValidator().getErrors()#>
			<cfset variables.indexableObject.dump()>
			<cfabort>
		</cfif>
	</cffunction>
	
 </cfcomponent>