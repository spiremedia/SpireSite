<cfcomponent name="model" output="false" extends="resources.abstractEditableModel">
	<cffunction name="init">
		<cfargument name="requestObj" required="true">
		<cfargument name="userObj" required="true">

		<cfset super.init(requestObj, userObj, '{
			"fields":{
				"src":{"label":"Location","validation":"notblank","parseforwysiwyg":"1"}
			}
		}')>
		
		<cfreturn this>
	</cffunction>
	
	<cffunction name="validateSave">		
		
		<cfset var vdtr = this.getValidator()>
		
		<cfset super.validateSave()> 
		<cfif trim(this.getSrc()) neq ''>
			<cfset vdtr.regexnomatchtest('redirect', '^https?:\/\/', this.getSrc(), 'The Location should be an absolute path (ie. http://www.spiremedia.com/).')> 
		</cfif>
		
	</cffunction> 
</cfcomponent>