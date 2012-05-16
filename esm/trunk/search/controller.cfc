<cfcomponent name="Search" extends="resources.abstractControllerWEditables">
		
	<cffunction name="getModel">
		<cfargument name="requestObject" required="true">
		<cfargument name="userObj" required="true">
		<cfset var mdl = createObject('component','search.models.search').init(requestObject, userObj)>
		
		<cfreturn mdl>
	</cffunction>

	<cffunction name="startPage">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">
	
		<cfset displayObject.setData('sitePages', dispatcher.callExternalModuleMethod('pages','getPages', requestObject, userobj) )>
		
		<cfreturn displayObject>
	</cffunction>
    
    <cffunction name="keyPhrases">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">
		
        <cfset var miscdata = createObject("component", "resources.miscdata").init(requestObject)>
        
		<cfset displayObject.setData( 'keyphrases', miscdata.getItem("keyphrases") )>

		<cfreturn displayObject>
	</cffunction>
    
    <cffunction name="keyPhrasesSave">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">
		
        <cfset var msg = structnew()>
        <cfset var miscdata = createObject("component", "resources.miscdata").init(requestObject)>
        
		<cfset miscdata.saveItem("keyphrases", requestObject.getFormUrlVar('keyphrases') )>
		
       	<cfset msg.message = "Key Phrases Saved">		
        <cfset displayObject.sendJson(msg)>
	
	</cffunction>
    
    <cffunction name="getSearchModel">
		<cfargument name="requestObj" required="true">
		<cfargument name="userObj" required="true">
		<cfset var mdl = createObject('component','search.models.search').init(requestObj, userObj)>
		<cfreturn mdl>
	</cffunction>
    
    <cffunction name="siteSearchStart">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">
		
		<cfset var model = getSearchModel(requestObject, userObj)>
       
        <cfset displayObject.setData('list', model.getSearchMonths())>
		
		<cfreturn displayObject>
	</cffunction>
    
    <cffunction name="siteSearchSearch">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">
        
		<cfset var model = getSearchModel(requestObject, userObj)>

		<cfset displayObject.setData('list', model.getSearchMonths())>
		<cfset displayObject.setData('requestObject', arguments.requestObject)>
		<cfset displayObject.setData('searchresults', model.keywordsearch(requestObject.getFormUrlVar('searchkeyword')))>		
			
		<cfreturn displayObject>
	</cffunction>
 
	<cffunction name="siteSearchViewByMonth">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">

		<cfset var year = requestObject.getFormUrlVar('year')>
		<cfset var month = requestObject.getFormUrlVar('month')>
		<cfset var model = getSearchModel(requestObject, userObj)>
			
		<cfset displayObject.setData('list', model.getSearchMonths())>
		<cfset displayObject.setData('month', month)>
		<cfset displayObject.setData('year', year)>
		<cfset displayObject.setData('requestObject', arguments.requestObject)>
		<cfset displayObject.setData('monthssearches', model.getSearchItemsByMonth(month,year))>		
	
		<cfreturn displayObject>
	</cffunction>
	
	<cffunction name="indexeddata">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">
		
		<cfset var model = "">
		
		<cfset displayObject.setData('searchword', requestObject.getFormUrlVar("searchkeyword",""))>
		
		<cfif requestObject.getFormUrlVar("searchkeyword","") NEQ "">
			<cfset model = getModel(requestObject, userObj)>
			<cfset displayObject.setData('searchresults', model.findIndexables(requestObject.getFormUrlVar("searchkeyword")))>
		</cfif>
		
		<cfreturn displayObject>
	</cffunction>
	
	<cffunction name="viewIndexable">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">
		
		<cfset var model = getModel(requestObject, userObj)>
		
		<cfset displayObject.setData('item', model.getIndexable(requestObject.getFormUrlVar("id")))>
		
		<cfreturn displayObject>
	</cffunction>

</cfcomponent>