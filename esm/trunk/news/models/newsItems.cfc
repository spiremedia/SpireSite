<cfcomponent name="model" output="false" extends="resources.abstractmodel">

	<cffunction name="init">
		<cfargument name="requestObj" required="true">
		<cfargument name="userObj" required="true">
		
		<cfset variables.requestObj = arguments.requestObj>
		<cfset variables.userObj = arguments.userObj>
			
		<cfset setTableMetaData('{	
			"tableName":"newsItems",
			"fields":{
				"name":{"type":"varchar","maxlen":50,"validation":"notblank,maxlength","label":"Name"},
				"title":{"type":"varchar","maxlen":255,"validation":"notblank,maxlength","label":"Title"},
				"description":{"type":"varchar","maxlen":500,"validation":"maxlength","label":"Description","wysiwyg":1},
				"htmlText":{"type":"varchar","label":"Html Content","wysiwyg":1},
				"changedby":{"MAXLEN":35,"TYPE":"varchar","LABEL":"Changedby","VALIDATION":"maxlength,notblank"},
				"deleted":{"type":"bit","default":0},
				"active":{"type":"bit","default":1},
				"itemdate":{"type":"date","validation":"notblank,isvaliddate","label":"Item Date"},
				"startdate":{"type":"date","label":"Start Date"},
				"enddate":{"type":"date","label":"End Date"},
				"created":{"type":"date"},
				"modified":{"type":"date"},
				"siteid":{"MAXLEN":35,"TYPE":"varchar","LABEL":"Siteid","VALIDATION":"maxlength,notblank"},
				"onhomepage":{"TYPE":"bit","LABEL":"Onhomepage"},
				"author":{"LABEL":"Author"},
				"linkpageid":{"MAXLEN":35,"TYPE":"varchar","LABEL":"Linkpageid","VALIDATION":"maxlength"},
				"assetid":{"MAXLEN":35,"TYPE":"varchar","LABEL":"Assetid","VALIDATION":"maxlength"}
			},
			"habtm":{"news.NewsTypes":{}}
		}')>
		
		<cfreturn this>
	</cffunction>
	
	<cffunction name="getNewsItems" output="false">
		<cfset var sg = "">
	
		<cfquery name="sg" datasource="#variables.requestObj.getvar('dsn')#">
            SELECT 
				news.id, news.author, news.name, news.title, news.itemdate, news.description, news.changedby, news.active, news.startdate, news.enddate, news.onhomepage, news.htmlText, news.assetid,
                newstypejoin.newstypename
			FROM newsItems news
            LEFT OUTER JOIN (
            				SELECT 
                            	inewstypes.name newstypename, 
                                inewstonewstypes.newsItemid
                            FROM newstypes inewstypes
                            INNER JOIN newsitemstonewstypes inewstonewstypes ON inewstonewstypes.newstypeid = inewstypes.id 
							WHERE inewstypes.deleted = 0)  newstypejoin ON newstypejoin.newsItemid = news.id
			WHERE news.siteid = <cfqueryparam value="#userobj.getCurrentSiteId()#" cfsqltype="cf_sql_varchar">  
            	AND news.deleted = 0
			ORDER BY newstypename, news.title
		</cfquery>
		
        <cfloop query="sg">
        	<cfif sg.newstypename EQ "">
        		<cfset sg.newstypename[currentrow] = "Unassociated">
			</cfif>
        </cfloop>
		<cfreturn sg/>
	</cffunction>

	<cffunction name="validate">		
		<cfset var lcl = structnew()>
		<cfset var requestvars = variables.itemData>
		<cfset var vdtr = this.getValidator()>
		<cfset var mylocal = structnew()>
				
		<cfif requestvars.startdate NEQ "">
			<cfset vdtr.isvaliddate('startdate', requestvars.startdate, 'If provided, the Start Date must be valid.')>
		</cfif>
		
		<cfif requestvars.enddate NEQ "">
			<cfset vdtr.isvaliddate('enddate', requestvars.enddate, 'If provided, the End Date must be valid.')>
		</cfif>
		
		<cfreturn vdtr/>
	</cffunction>
	
	<cffunction name="getNewsTypes" output="false">

		<cfset var g = "">
			
		<cfquery name="g" datasource="#variables.request.getvar('dsn')#">
			SELECT id, name FROM newstypes
			WHERE  
				deleted = 0 AND 
				siteid = <cfqueryparam value="#variables.userObj.getCurrentSiteId()#" cfsqltype="cf_sql_varchar">
		</cfquery>
		
		<cfreturn g>
	</cffunction>
</cfcomponent>
	