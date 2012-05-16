<cfcomponent name="Permission Level" output="false" extends="resources.abstractModel">

	<cffunction name="init">
		<cfargument name="request" required="true">
		<cfargument name="userobj" required="true">
		<cfset variables.request = arguments.request>
		<cfset variables.userobj = arguments.userobj>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="getMemberType" output="false">
		<cfargument name="id">
		<cfset var g = "">
	
		<cfquery name="g" datasource="#variables.request.getvar('dsn')#">
			SELECT 
				id, name, description
			FROM memberTypes
			WHERE id = <cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_varchar">
		</cfquery>
		
		<cfreturn g/>
	</cffunction>
    
 	<cffunction name="getMemberTypes" output="false">
		<cfset var g = "">
		
		<cfquery name="g" datasource="#variables.request.getvar('dsn')#">
			SELECT 
				id, name, description
			FROM memberTypes
			ORDER BY name
		</cfquery>
		
		<cfreturn g/>
	</cffunction>
	
	<cffunction name="validate">	
    	<cfargument name="requestvars" required="true">	
		<cfset var lcl = structnew()>
		<cfset var vdtr = createObject('component','utilities.datavalidator').init()>
		<cfset var mylocal = structnew()>
		
		<!--- valiation for new users --->
		
		<cfset vdtr.notblank('name', requestvars.name, 'The Member Types Name is required.')>
		
		<!--- check this name already not used --->
		<cfquery name="mylocal.namecheck" datasource="#variables.request.getvar('dsn')#" result="m">
			SELECT id
			FROM memberTypes 
			WHERE name = <cfqueryparam value="#requestvars.name#" cfsqltype="cf_sql_varchar">
			<cfif requestvars.id NEQ "">
				AND id <> <cfqueryparam value="#requestvars.id#" cfsqltype="cf_sql_varchar">
			</cfif>
		</cfquery>
		
		<cfif mylocal.nameCheck.recordcount>
			<cfset vdtr.addError('name',"This Member Type Name is already in use. Names must be unique." )>
		</cfif>
        	
		<cfreturn vdtr/>
	</cffunction>
	
	<cffunction name="validateDelete" output="false">
		<cfargument name="id" required="true">
		<cfset var eo = createObject('component', 'utilities.datavalidator').init()>
		<cfset var g = "">
        
		<cfquery name="g" datasource="#variables.request.getvar('dsn')#">
			SELECT DISTINCT 'Page : ' + sp.pagename + ' (' + po.name + ')' loc
            FROM pageObjects po
            INNER JOIN sitepages sp ON po.pageid = sp.id
            INNER JOIN memberTypes mt ON mt.name LIKE  '%' + po.memberType + '%'
           	WHERE mt.id = <cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_varchar"> 
		</cfquery>

		<cfif g.recordcount>
        	<cfset eo.addError('name', "This Member Type is set to ""#valuelist(g.loc,", ")#"".  Please delete these associations before deleting this Member Type.")>
        </cfif>

		<cfreturn eo/>
	</cffunction>    
    
	<cffunction name="saveMember">
    	<cfargument name="info" required="true">
		<cfset var id = "">
		<cfif info.id EQ ''>
			<cfset info.id = insertMemberType(info)>
			<cfset variables.observeEvent('insert member type', info)>
		<cfelse>
			<cfset updateMemberType(info)>
			<cfset variables.observeEvent('update member type', info)>
		</cfif>
		<cfreturn info.id>
	</cffunction>
        
	<cffunction name="insertMemberType" output="false">
    	<cfargument name="info" required="true">
		<cfset var grp = "">
		
		<cfset var id = createuuid()>
				
		<!--- update the item record --->
		<cfquery name="grp" datasource="#variables.request.getvar('dsn')#">
			INSERT INTO memberTypes ( 
				id,
				name,
				description
			)VALUES (
				<cfqueryparam value="#id#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#info.name#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#info.description#" cfsqltype="cf_sql_varchar">
			)			
		</cfquery>
		
		<cfset variables.itemdata.id = id>
		
		<cfreturn id/>
	</cffunction>

	<cffunction name="updateMemberType" output="false">
    	<cfargument name="info" required="true">
		<cfset var grp = "">

		<cfquery name="grp" datasource="#variables.request.getvar('dsn')#">
			UPDATE memberTypes SET 
				name = <cfqueryparam value="#info.name#" cfsqltype="cf_sql_varchar">,
				description = <cfqueryparam value="#info.description#" cfsqltype="cf_sql_varchar">
			WHERE 
				id = <cfqueryparam value="#info.id#" cfsqltype="cf_sql_varchar">
		</cfquery>
		
		<cfreturn info.id>
	</cffunction>
   	
	<cffunction name="deleteMemberType" output="false">
		<cfargument name="id" required="true">
		
		<cfset var g = "">
		
		<cfset variables.observeEvent('delete member type',id)>
		
		<cfquery name="g" datasource="#variables.request.getvar('dsn')#">
			DELETE FROM memberTypes
			WHERE id= <cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_varchar"> 
		</cfquery>
	</cffunction>
    
</cfcomponent>
	