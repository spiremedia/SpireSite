<cfsavecontent variable="modulexml">
<module name="SiteMaps" label="Site Map" menuOrder="0" securityitems="">
	<action name="editClientModule" method="editClientModule" onMenu="0" template="popup-onecol" formsubmit="saveclientmodule">
		<template name="title" title="label" file="clientmodulelabel.cfm"/>
		<template name="title" title="label" file="clientmodulebuttons.cfm"/>
		<template name="mainContent" title="Properties" file="clientmoduleform.cfm"/>
	</action>

	<action name="Save Client Module"/>
	<action name="delete Client Module"/>
</module>
</cfsavecontent>


<cfset modulexml = xmlparse(modulexml)>



