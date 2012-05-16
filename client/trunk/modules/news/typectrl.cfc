<cfcomponent name="newslistcontroller" output="false" extends="resources.abstractSubController">
	
	<cffunction name="init">

		<cfset super.init(argumentCollection = arguments)>
		<cfset variables.pageRef.addToHeader('<link rel="stylesheet" href="/ui/css/news.css" type="text/css"/>')>
		<cfreturn this>
	</cffunction>
	<!---
	<cffunction name="loadSummary" output="false">
		<cfset var lcl = structnew()>

		<cfparam name="variables.data.itemid" default="">
		<cfparam name="variables.data.pageing" default="10">

		<cfset variables.newsitem = variables.newsmodel.getFeedInfo(variables.data.itemid)><strong></strong>
		<cfset variables.newslist = variables.newsmodel.getAvailableNewsItems(variables.data.itemid)>
		<cfset variables.rowcount = variables.data.pageing>
		<cfset variables.totalSearchRecords = variables.newslist.recordcount>

		<cfif variables.requestObject.isFormUrlVarSet('page')>
			<cfset variables.page = variables.requestObject.getFormUrlVar('page')>
			<cfparam name="variables.page" type="integer">
			<cfset variables.startrow = variables.page * variables.rowCount - variables.rowCount + 1>
		<cfelse>
			<cfset variables.page = 1>
			<cfset variables.startrow = 1>
		</cfif>

		<cfset lcl.a = arraynew(1)>
		<cfloop from="1" to="#variables.newslist.recordcount#" index="lcl.i">
		<cfset arrayappend(lcl.a, lcl.i)>
		</cfloop>

		<cfset queryaddcolumn(variables.newslist,'counter', lcl.a)>

		<cfif variables.rowcount EQ "all">
			<cfset lcl.rowcount = 100000>
			<cfelse>
			<cfset lcl.rowcount = variables.rowcount>
		</cfif>

		<cfquery name="variables.newslist" dbtype="query" maxrows="#lcl.rowcount#">
			SELECT *
			FROM  variables.newslist
			WHERE counter >= <cfqueryparam cfsqltype="cf_sql_integer" value="#variables.startrow#">
		</cfquery>

		<cfreturn this>
	</cffunction>
	--->
	<cffunction name="showHTML" output="false">
		<cfset var html = "">
		<cfsavecontent variable="html">
			<div class="newsList">
				<cfinclude template="templates/newslisting.cfm">
			</div>
		</cfsavecontent>
		<cfreturn html>
	</cffunction>
	
	<cffunction name="dump">
		<cfdump var=#variables.data#>
		<cfabort>
	</cffunction>
</cfcomponent>