<cfcomponent name="model" output="false" extends="resources.abstractmodel">

	<cffunction name="init">
		<cfargument name="requestObj" required="true">
		<cfargument name="userObj" required="true">
		
		<cfset variables.requestObj = arguments.requestObj>
		<cfset variables.userObj = arguments.userObj>
			
		<cfset setTableMetaData('{	
			"tableName":"reviews",
			"fields":{
				"siteid":{"MAXLEN":35,"TYPE":"varchar","VALIDATION":"maxlength,notblank"},
				"deleted":{"type":"bit","default":0},
				"active":{"type":"bit","default":0},
				"created":{"type":"date"},
				"modified":{"type":"date"},
				"modulename":{"MAXLEN":30,"TYPE":"varchar"},
				"moduleitemid":{"MAXLEN":35,"TYPE":"varchar"},
				"reviewerid":{"MAXLEN":35,"TYPE":"varchar"},
				"reviewername":{"MAXLEN":100,"TYPE":"varchar"},
				"rating":{"TYPE":"integer"},
				"comments":{"TYPE":"varchar"}
			},
			"belongsTo":{"productcatalog.products":{"joinfields":"title","foreignkey":"moduleitemid"}}
		}')>
		
		<cfreturn this>
	</cffunction>
	
	<cffunction name="getProductReviews" output="false">
		<cfset var sg = "">
	
		<cfquery name="sg" datasource="#variables.requestObj.getvar('dsn')#" result="r">			
			SELECT reviews.id, reviews.modified, reviews.created, reviews.active, reviews.modulename, reviews.rating, reviews.reviewername,
				products.title as itemname
			FROM reviews
			INNER JOIN products on reviews.moduleitemid = products.id
			WHERE reviews.siteid = '#variables.userObj.getCurrentSiteID()#' 
				AND reviews.modulename = 'products' 
				AND reviews.deleted = 0
			ORDER BY reviews.active, reviews.created desc
		</cfquery>
		<cfreturn sg/>
	</cffunction>
	
	<cffunction name="searchProductReviews" output="false">
		<cfargument name="criteria" required="no">
		<cfset var sg = "">
	
		<cfquery name="sg" datasource="#variables.requestObj.getvar('dsn')#" result="r">			
			SELECT reviews.id, reviews.modified, reviews.created, reviews.active, reviews.modulename, reviews.rating, reviews.reviewername,
				products.title AS itemname
			FROM reviews
			INNER JOIN products on reviews.moduleitemid = products.id
			WHERE reviews.siteid = '#variables.userObj.getCurrentSiteID()#' 
				AND reviews.modulename = 'products' 
				AND reviews.deleted = 0
				<cfif structKeyExists(arguments, 'criteria')>
					AND (products.title LIKE <cfqueryparam value="%#arguments.criteria#%" cfsqltype="cf_sql_varchar"> 
						OR products.name LIKE <cfqueryparam value="%#arguments.criteria#%" cfsqltype="cf_sql_varchar"> 
						OR reviews.title LIKE <cfqueryparam value="%#arguments.criteria#%" cfsqltype="cf_sql_varchar"> 
						OR reviews.reviewername LIKE <cfqueryparam value="%#arguments.criteria#%" cfsqltype="cf_sql_varchar">
					)
				</cfif>
			ORDER BY reviews.active, reviews.created desc
		</cfquery>
		<cfreturn sg/>
	</cffunction>
	
</cfcomponent>
	