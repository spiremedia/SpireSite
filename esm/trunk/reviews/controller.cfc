<cfcomponent name="reviews" extends="resources.abstractControllerWEditables">
	
	<cffunction name="init">
		<cfargument name="request" required="true">
		<cfset variables.request = arguments.request>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="getModel">
		<cfargument name="requestObj" required="true">
		<cfargument name="userObj" required="true">
		<cfset var mdl = createObject('component','reviews.models.reviews').init(arguments.requestObj, arguments.userObj)>
		<cfset mdl.attachObserver(createObject('component','reviews.models.logs').init(arguments.requestObj, arguments.userObj))>
		<cfreturn mdl/>
	</cffunction>
	
	<cffunction name="getLogObj">
		<cfargument name="requestObject">
		<cfargument name="userObj">

		<cfreturn createObject('component','reviews.models.logs').init(arguments.requestObject, arguments.userObj)>
	</cffunction>
    
	<cffunction name="StartPage">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userObj" required="true">

		<cfset var model = getmodel(requestObject, userObj)>
		<cfset var log = getLogObj(requestObject, userObj)>
		<cfset var lcl = structNew()>

		<cfset lcl.conditions.sort = 'created desc'>
		<cfset displayObject.setData('searchResults', model.getAll(lcl.conditions))>
		<cfset displayObject.setData('recentActivity', log.getRecentModuleHistory(requestObject.getModuleFromPath()))>
		<cfset displayObject.setData('requestObj', arguments.requestObject)>
		<cfset displayObject.setData('reviewsmodulename', '')>
		
		<cfif requestObject.isformurlvarset('sortkey')>
			<cfset displayObject.setWidgetOpen('mainContent','1,2')>
		</cfif>

	</cffunction>
	
	<cffunction name="Browse">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		
		<cfset var model = getmodel(requestObject, userobj)>
						
		<cfif requestObject.isformurlvarset('id')>
			<cfset displayObject.setData('id', requestObject.getformurlvar('id'))>	
		</cfif>
		<cfif requestObject.getformurlvar('reviewsmodulename') eq "products">
			<cfset displayObject.setData('list', model.getProductReviews())>
		<cfelseif requestObject.getformurlvar('reviewsmodulename') eq "news">
			<cfset displayObject.setData('list', model.getNewsReviews())>
		<cfelse>
			<cfset displayObject.setData('list', model.getAll())>
		</cfif>
		
		<cfset displayObject.showHTML( displayObject.renderTemplateItem("browse") )>
	</cffunction> 
	
	<cffunction name="Search">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userObj" required="true">		
		<cfset var model = getmodel(arguments.requestObject, arguments.userObj)>
		<cfset var lcl = structNew()>
		<cfset var info = requestObject.getAllFormUrlVars()>
		<cfparam name="info.reviewsmodulename" default="">
		
		<cfswitch expression="#info.reviewsmodulename#">
			<cfcase value="products">
				<cfset displayObject.setData('list', model.getProductReviews())>
				<cfset displayObject.setData('searchResults', model.searchProductReviews(info.searchkeyword))>
				<cfset displayObject.setData('reviewsmodulename', info.reviewsmodulename)>
			</cfcase>
			<cfcase value="news">
				<cfset displayObject.setData('list', model.getNewsReviews())>
				<cfset displayObject.setData('searchResults', model.searchNewsReviews(info.searchkeyword))>
				<cfset displayObject.setData('reviewsmodulename', info.reviewsmodulename)>
			</cfcase>
			<cfdefaultcase>
				<cfset displayObject.setData('list', model.getAll())>
				<cfset lcl.title = info.searchkeyword>
				<cfset lcl.reviewername = info.searchkeyword>
				<cfset lcl.modulename = info.searchkeyword>
				<cfset displayObject.setData('searchResults', model.like(lcl))>
			</cfdefaultcase>
		</cfswitch>
		
		<cfset displayObject.setData('requestObj', arguments.requestObject)>

	</cffunction>
	
	<cffunction name="editReview">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">
	
		<cfset var lcl = structnew()>
		<cfset var model = getmodel(requestObject, userObj)>
		<cfset var logs = getlogObj(requestObject, UserObj)>
		
		<cfset displayObject.setData('requestObj', arguments.requestObject)>
		
		<cfset model.load(requestObject.getformurlvar('id'))>
		<cfset displayObject.setData('itemhistory', logs.getRecentModuleItemHistory(requestObject.getModuleFromPath(), requestObject.getformurlvar('id')))>
		<cfset displayObject.setData('info', model)>
		<cfset displayObject.setData('itemname', '')>
		
		<cfif requestObject.getformurlvar('reviewsmodulename') eq "products">
			<cfset displayObject.setData('list', model.getProductReviews())>
			<cfset lcl.moduleitemModel = createObject('component','productcatalog.models.products').init(requestObject, userobj)>	
			<cfset lcl.qryModuleitem = lcl.moduleitemModel.getById(model.getModuleitemid())>	
			<cfset displayObject.setData('itemname', lcl.qryModuleitem.title)>
		<cfelseif requestObject.getformurlvar('reviewsmodulename') eq "news">
			<cfset displayObject.setData('list', model.getNewsReviews())>
			<cfset lcl.moduleitemModel = createObject('component','news.models.newsItems').init(requestObject, userobj)>	
			<cfset lcl.qryModuleitem = lcl.moduleitemModel.getById(model.getModuleitemid())>	
			<cfset displayObject.setData('itemname', lcl.qryModuleitem.title)>
		<cfelse>
			<cfset lcl.conf = structnew()>
			<cfset lcl.conf.sort = "reviews.active, reviews.created desc">
			<cfset displayObject.setData('list', model.getByModulename(requestObject.getformurlvar('reviewsmodulename'), lcl.conf))>
		</cfif>
		
		<cfset displayObject.setData('id', requestObject.getformurlvar('id'))>
		<cfset displayObject.setData('reviewsmodulename', requestObject.getformurlvar('reviewsmodulename'))>

		<cfif requestObject.isformurlvarset('sortdir')>
        	<cfset displayObject.setWidgetOpen('mainContent','2')>
		</cfif>
	</cffunction>
	
	<cffunction name="SaveReview">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">
		
		<cfset var lcl = structnew()>
		
		<cfset var model = getmodel(requestObject, userobj)>
				
		<cfset var requestvars = requestobject.getallformurlvars()>
		<cfparam name="requestvars.active" default="0">

		<cfset model.setValues(requestVars)>
			
		<cfif model.save()>
			<cfset lcl.id = model.getId()>
			<cfset lcl.msg = structnew()>
			<cfset lcl.msg.message = "Saved Review">
			<!---<cfset lcl.msg.ajaxupdater = structnew()>
            <cfset lcl.msg.ajaxupdater.url = "../Browse/?id=#lcl.id#&reviewsmodulename=#requestObject.getformurlvar('reviewsmodulename')#">
			<cfset lcl.msg.ajaxupdater.focusselected = 'true'>
            <cfset lcl.msg.ajaxupdater.id = 'browse_content'>--->
			<cfset displayObject.sendJson( lcl.msg )>
		<cfelse>
			<cfset lcl.msg = structnew()>
			<cfset lcl.msg.validation = model.getValidator().getErrors()>
			<cfset displayObject.sendJson( lcl.msg )>
		</cfif>
		
	</cffunction>
	
	<cffunction name="DeleteReview">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		
		<cfset var lcl = structnew()>
		<cfset var model = getmodel(requestObject, userobj)>				
		<cfset var requestvars = requestobject.getallformurlvars()>

		<cfset model.setValues(requestVars)>
		
		<cfif NOT requestObject.isformurlvarset('id') OR NOT isValid('UUID', requestObject.getFormUrlVar("id"))>
			<cfthrow message="valid id not provided to delete Review">
		</cfif>

		<cfif model.delete(requestObject.getformurlvar('id'))>
			<cfset lcl.msg = structnew()>
			<cfset lcl.msg.message = "The Review has been deleted">
			<!---<cfset lcl.msg.ajaxupdater = structnew()>
			<cfset lcl.msg.ajaxupdater.url = "../Browse/?reviewsmodulename=#requestObject.getformurlvar('reviewsmodulename')#">
			<cfset lcl.msg.ajaxupdater.id = 'browse_content'>
			<cfset lcl.msg.ajaxupdater.focusselected = 'true'>--->
			<cfset lcl.msg.htmlupdater = structnew()>
			<cfset lcl.msg.htmlupdater.id = "rightContent">
			<cfset lcl.msg.htmlupdater.HTML = "<div id='msg'>Review Deleted</div>">
			<cfset displayObject.sendJson( lcl.msg )>
		<cfelse>
			<cfset lcl.msg = structnew()>
			<cfset lcl.msg.validation = model.getValidator().getErrors()>
			<cfset displayObject.sendJson( lcl.msg )>
		</cfif>

	</cffunction>
    
	<cffunction name="ProductReviews">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userObj" required="true">

		<cfset var model = getmodel(requestObject, userObj)>
		<cfset var log = getLogObj(requestObject, userObj)>
		<cfset var reviewsmodulename = 'products'>

		<cfset displayObject.setData('list', model.getProductReviews())>
		<cfset displayObject.setData('searchResults', displayObject.getData('list'))>
		<cfset displayObject.setData('recentActivity', log.getRecentModuleHistory(requestObject.getModuleFromPath()))>
		<cfset displayObject.setData('requestObj', arguments.requestObject)>
		<cfset displayObject.setData('reviewsmodulename', reviewsmodulename)>
		
		<cfif requestObject.isformurlvarset('sortkey')>
			<cfset displayObject.setWidgetOpen('mainContent','1,2')>
		</cfif>

	</cffunction>
</cfcomponent>