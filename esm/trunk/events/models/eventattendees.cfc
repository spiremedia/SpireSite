<cfcomponent name="Event Attendees Model" output="false" extends="resources.abstractModel">

	<cffunction name="init">
		<cfargument name="requestObj" required="true">
		<cfargument name="userobj" required="true">
		
		<cfset variables.requestObj = arguments.requestObj>
		<cfset variables.userobj = arguments.userobj>
		<cfset variables.itemdata = structnew()>
		
		<cfset setTableMetaData('{	
			"tableName":"eventattendees",
			"fields":{
				"eventid":{"type":"varchar","validation":"notblank"},
				"fname":{"type":"varchar","maxlen":50,"validation":"notblank,maxlength","label":"First Name"},
				"lname":{"type":"varchar","maxlen":50,"validation":"notblank,maxlength","label":"Last Name"},
				"title":{"type":"varchar","maxlen":50,"validation":"notblank,maxlength"},
				"phone":{"type":"varchar","maxlen":50,"validation":"notblank,maxlength"},
				"companyName":{"type":"varchar","maxlen":100,"validation":"notblank,maxlength","label":"Company Name"},
				"add1":{"type":"varchar","maxlen":255,"validation":"notblank,maxlength","label":"Address 1"},
				"add2":{"type":"varchar","maxlen":255,"validation":"notblank,maxlength","label":"Address 2"},
				"city":{"type":"varchar","maxlen":50,"validation":"notblank,maxlength"},
				"state":{"type":"varchar","maxlen":50,"validation":"notblank,maxlength"},
				"zip":{"type":"varchar","maxlen":12,"validation":"notblank,maxlength"},
				"wantsmaterials":{"type":"bit","validation":"notblank,maxlength","label":"Wants Materials"},
				"addtlattendeescount":{"type":"integer","validation":"notblank","label":"Additional Attendees Count"},
				"addtlattendeesinfo":{"type":"varchar","maxlen":255,"validation":"notblank,maxlength","label":"Additional Attendees Info"},
				"comment":{"type":"varchar","maxlen":500,"validation":"maxlength"},
				"siteid":{"type":"varchar","maxlen":35},
				"email":{"type":"varchar","maxlen":250,"validation":"notblank,maxlength"},
				"signupdatetime":{"type":"date"}
			},
			"belongsTo":{"events.events":{}}
		}')>
		<cfreturn this>
	</cffunction>
</cfcomponent>