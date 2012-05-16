<cfsavecontent variable="modulexml">
<module name="SiteMemberTypes" topnav="true" label="Site Member Types" menuOrder="0" securityitems="Add Member Type,Edit Member Type,Delete Member Type">

	<action name="Start Page" template="twocolumnwnavigation">
		<template name="browseContent" title="Browse" file="browse.cfm"/>
		<template name="title" title="label" file="startlabel.cfm"/>
		<template name="mainContent" title="Start Page" file="start.cfm"/>
		<template name="mainContent" title="Recent Activity" file="recentactivity.cfm"/>
	</action>

	<action name="Add Member Type" onMenu="1" isform="1" template="twocolumnwnavigation" formsubmit="savemembertype">
		<template name="browseContent" title="Browse" file="browse.cfm"/>
			<template name="title" title="label" file="titlelabel.cfm"/>
		<template name="title" title="buttons" file="titlebuttons.cfm"/>
		<template name="mainContent" title="Properties" file="properties.cfm"/>
	</action>

    <action name="Edit Member Type" isform="1" template="twocolumnwnavigation" formsubmit="savemembertype">
		<template name="browseContent" title="Browse" file="browse.cfm"/>
		<template name="title" title="label" file="titlelabel.cfm"/>
		<template name="title" title="buttons" file="titlebuttons.cfm"/>
		<template name="mainContent" title="Properties" file="properties.cfm"/>
		<template name="mainContent" title="History" file="history.cfm"/>
	</action>

	<action name="Save Member Type"/>

	<action name="Delete Member Type" isSecurityItem="1"/>

	<action name="Browse" isSecurityItem="0" template="blankpanels">
		<template name="html" title="Browse" file="browse.cfm"/>
	</action>

</module>
</cfsavecontent>

<cfset modulexml = xmlparse(modulexml)>



