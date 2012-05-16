<cfcomponent name="modulespage" extends="resources.page">
	<cffunction name="preObjectLoad">
		<cfif NOT requestObject.getVar("debug",0)>
			System must be in debug mode<cfabort>
		</cfif>
		<cfoutput>
			<cfdump var=#application.views.dump()#>
			<cfdump var=#application.modules.dump()#><cfabort>
			#createObject('component', 'utilities.json').encode(application.modules.getEmbedeableModules())#
		</cfoutput>
		<cfabort>
	</cffunction>
</cfcomponent>