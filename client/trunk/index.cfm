
<cfparam name="url.path" default="/">
<cfset localrequest = application.settings.makeRequestObject()>

<cfset localrequest.notifyObservers("pagestart", "")>


<cf_toplevelcache 	urlidentifyer="#localrequest.getUrlIdentifyer()#" 
					postProcess="#application.site.getPostProcesses()#"
                    requestObject = "#localrequest#"
					duration="0">
	<cfset page = application.site.getPage(localrequest)>
	<cfset page.preObjectLoad()>
	<cfset page.loadObjects(application.views, application.modules)>
	<cfset page.postObjectLoad()>
	<cfset localrequest.notifyObservers("page.objects", page)>
	<cfset cachelength = page.getCacheLength()>
	<cfset is404 = page.is404()>

	<cfset page.showPage()>
</cf_toplevelcache>