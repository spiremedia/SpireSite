<cfsavecontent variable="modulexml">
<moduleInfo>
	<action match="^forms2/(.*)$">
		<loadcfc>formsubmission</loadcfc>
	</action>
</moduleInfo>
</cfsavecontent>

<cfset modulexml = xmlparse(modulexml)>