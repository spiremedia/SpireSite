<cfsavecontent variable="modulexml">
<moduleInfo searchable="1">
	
	<action match="^system/refreshSearch/[a-z]+">
		<loadcfc>refreshSearch</loadcfc>
	</action>
	
	<action match="^search/">
		<loadcfc>siteSearch</loadcfc>
	</action>
	
</moduleInfo>
</cfsavecontent>

<cfset modulexml = xmlparse(modulexml)>