<cfcomponent name="events controller" output="false" extends="resources.abstractController">
	
	<cfset variables.useparseforlanguage = true>
	
	<cffunction name="getPagesforSiteSearch">
		<cfargument name="aggregator">

		<cfset var model = this.getEventsModel("events")>
		<cfset var itms = model.getEventsList()>
		<cfset var webpath = "NewsAndEvents/Events/">
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
		<cfif structkeyexists(variables.pageref, "addtoheader")>
			<cfset variables.pageRef.addToHeader('<link rel="stylesheet" href="/ui/css/news.css" type="text/css"/>')>
		</cfif>
		<cfparam name="variables.data.itemid" default="">
		<cfparam name="variables.data.label" default="">
		<cfparam name="variables.data.pageing" default="10">

        <cfset variables.myOrderBy = requestObject.getFormURLVar("orderby", "startdate")>
                  
		<cfset variables.eventsmodel = this.geteventsModel("events")>
		<cfset variables.eventslist = variables.eventsmodel.getEventsList(variables.myOrderBy)>
		
		<cfset variables.pager = this.getUtility("pager").init(requestObject)>
        <cfset variables.pager.setItemsPerPage(variables.data.pageing)>
		<cfset variables.eventslist = variables.pager.chopQuery(variables.eventslist)>
        <cfset variables.pager.setTitlePattern("Your search returned {recordsfound} results")>
		<cfset variables.pager.setNoRecordsTitlePattern("No records were found")>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="shortlist">
		<cfparam name="variables.data.itemid" default="">
		<cfparam name="variables.data.label" default="">
		<cfparam name="variables.data.pageing" default="10">
		
		<cfset variables.eventsmodel = this.geteventsModel("events")>
		<cfset variables.eventslist = variables.eventsmodel.getHomePageItems()>
		
		<cfreturn this>
	</cffunction>
	
	<cffunction name="home">
		<cfset variables.eventsItems = this.geteventsModel("events").getHomePageItems()>
		<cfreturn this>
	</cffunction>

	<cffunction name="getCacheLength">
		<cfreturn 0>
	</cffunction>
	
</cfcomponent>