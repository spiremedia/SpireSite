<cfsavecontent variable="modulexml">
<moduleInfo searchable="0">
	<action match="^navrelocate">
		<loadcfc>relocate</loadcfc>
	</action>
</moduleInfo>
</cfsavecontent>

<cfset modulexml = xmlparse(modulexml)>