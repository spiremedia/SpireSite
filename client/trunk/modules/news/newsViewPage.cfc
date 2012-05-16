<cfcomponent name="news View" extends="resources.page">
	<cffunction name="preobjectLoad">
		<cfset variables.newsid = variables.requestObject.getFormUrlVar('path')>
		<cfset variables.newsid = listlast(variables.newsid, "/")>

		<cfset variables.news = createObject('component','modules.news.models.news').init(requestObject)>
		<cfset variables.newsInfo = variables.news.getNews(variables.newsid)>
		<cfset variables.pageInfo.breadCrumbs = "Home~NULL~/|News & Events~#variables.requestObject.getVar('newseventsPageID')#~/NewsAndEvents/|#variables.newsInfo.itemtitle#|">
		<cfset variables.pageInfo.title = variables.newsInfo.itemtitle>
		<cfset variables.pageInfo.pagename = variables.newsInfo.itemtitle>
		<cfset variables.pageInfo.description = XmlFormat(variables.newsInfo.itemdesc)>
		<cfset variables.pageInfo.keywords = XmlFormat(variables.newsInfo.itemdesc)>
	</cffunction>
    
	<cffunction name="postObjectLoad">
		<cfset var data = structnew()>
		<!--- main title --->
		<cfset data.content = variables.pageinfo.title>
		<cfset addObjectByModulePath('mainTitle', 'simpleContent', data)>

		<!--- mainContent --->
		<cfset data = structnew()>
		<cfset data.newsInfo = variables.NewsInfo>
		<cfset addObjectByModulePath('middleItem_1_Content', 'news', "", data, "newsdetail")>
		
		<!--- Reviews --->	
		<!--- <cfset data = structnew()>
		<cfset data.moduleInfo = variables.NewsInfo>
		<cfset addObjectByModulePath('middleItem_6_Content', 'Reviews', "", data, "news")> --->
	</cffunction>
</cfcomponent>