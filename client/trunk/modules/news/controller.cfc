<cfcomponent extends="resources.abstractController" ouput="false">
	
	<cfset variables.useparseforlanguage = true>
	
	<cffunction name="getPagesforSiteSearch">
		<cfargument name="aggregator">

		<cfset var model = this.getNewsModel("news")>
		<cfset var itms = model.getAllAvailableNewsItems()>
		<cfset var webpath = "NewsAndEvents/News/">
        <cfset var indexable = "">
		
		<cfloop query="itms">
        	<cfset indexable = aggregator.newpageindexable()>
            <cfset indexable.setkey(itms.id)>
            <cfset indexable.setpath(webpath & itms.id & '/')>
            <cfset indexable.settitle(itms.title)>
            <cfset indexable.setdescription(itms.description)>
            <cfset indexable.saveForIndex()>
        </cfloop>
		
	</cffunction>
	
	<cffunction name="type">
		<cfparam name="variables.data.itemid" default="">
		<cfparam name="variables.data.pageing" default="10">
		
		<cfset variables.newsmodel = this.getNewsModel("news")>
        <cfset variables.newsitem = variables.newsmodel.getFeedInfo(variables.data.itemid)>
		<cfset variables.newslist = variables.newsmodel.getAvailableNewsItemsByYear()>
		
		<cfif variables.newsItem.hasRssFeed EQ 1 AND structkeyexists(variables.pageref, "addtoheader")>
			<cfset variables.pageref.addtoheader('<link rel="alternate" type="application/rss+xml" title="#variables.newsitem.title#" href="#requestObject.getVar("siteurl")#rss/news/#variables.newsItem.id#/" />')>
		</cfif>
		<cfif structkeyexists(variables.pageref, "addtoheader")>
			<cfset variables.pageref.addtoheader('<link rel="stylesheet" href="/ui/css/news.css" type="text/css"/>')>
		</cfif>
		<!---<cfset variables.pager = this.getUtility("pager").init(requestObject)>
       	<cfset variables.pager.setItemsPerPage(variables.data.pageing)>
		<cfset variables.newslist = variables.pager.chopQuery(variables.newslist)>
        <cfset variables.pager.setTitlePattern("Your search returned {recordsfound} results")>
		<cfset variables.pager.setNoRecordsTitlePattern("No records were found")>--->

		<cfreturn this>
	</cffunction>
	
	<cffunction name="shortlist">
		<cfparam name="variables.data.itemid" default="">
		<cfparam name="variables.data.pageing" default="10">
		
		<cfset variables.newsmodel = this.getNewsModel("news")>
        <cfset variables.newsitem = variables.newsmodel.getFeedInfo(variables.data.itemid)>
		<cfset variables.newslist = variables.newsmodel.getAvailableNewsItems(variables.data.itemid)>
		
		<cfreturn this>
	</cffunction>
	
	<cffunction name="home">
		<cfset variables.newsItems = this.getNewsModel("news").getHomeNews()>
		<cfreturn this>
	</cffunction>
	
	<!--- <cffunction name="showHTML">
		<cfreturn parseforlanguage(super.showHTML(argumentcollection=arguments))>
	</cffunction> --->
	
</cfcomponent>