<cfcomponent name="form2text" extends="utilities.forms2.leaf">
	
	<cffunction name="showHTML">
		<cfset var lcl = structnew()>
	
		<cfoutput>
		<cfsavecontent variable="lcl.h">
			<script language="javascript">
			#variables.forminfo.js#
			</script>
		</cfsavecontent>
		</cfoutput>
	
		<cfreturn lcl.h>
	</cffunction>
	
	<cffunction name="setJavascript">	
		<cfargument name="js" required="true">
		<cfset variables.forminfo.js = js>
	</cffunction>
	
</cfcomponent>