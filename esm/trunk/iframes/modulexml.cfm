<cfsavecontent variable="modulexml">
<module name="IFrames" label="IFrames" menuOrder="0" securityitems="">
	<action name="editClientModule" isform="1" template="popup-onecol" formsubmit="saveClientModule">
		<template name="title" title="label" file="titlelabel.cfm"/>
		<template name="title" title="label" file="titlebuttons.cfm"/>
		<template name="mainContent" title="Properties" file="editform.cfm"/>
	</action>
	<action name="Save Client Module"/>
	<action name="Delete Client Module"/>
</module>
</cfsavecontent>

<cfset modulexml = xmlparse(modulexml)>



