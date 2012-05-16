<cfsavecontent variable="modulexml">
<module name="Events" label="Events" menuOrder="14" securityitems="Add Event,Edit Event,Delete Event,View Attendees">

	<action name="Start Page" template="twocolumnwnavigation">
		<template name="browseContent" title="Browse" file="browse.cfm"/>
		<template name="browseContent" title="Search" file="search.cfm"/>
		<template name="title" title="Start Page" file="starttitle.cfm"/>
		<template name="mainContent" title="Start Page" file="start.cfm"/>
		<template name="mainContent" title="Recent Site Activity" file="recentActivity.cfm"/>
	</action>

	<action name="Add Event" onMenu="1" isform="1" isSecurityItem="1" formsubmit="SaveEvent" template="twocolumnwnavigation">
		<template name="browseContent" id="browse" title="Browse" file="browse.cfm"/>
		<template name="browseContent" title="Search" file="search.cfm"/>
		<template name="title" title="label" file="formtitlelabel.cfm"/>
		<template name="title" title="buttons" file="formtitlebuttons.cfm"/>
		<template name="mainContent" title="Properties" file="eventproperties.cfm"/>
	</action>

	<action name="Edit Event" isform="1" formsubmit="SaveEvent" template="twocolumnwnavigation">
		<template name="browseContent" id="browse" title="Browse" file="browse.cfm"/>
		<template name="browseContent" title="Search" file="search.cfm"/>
		<template name="title" title="label" file="formtitlelabel.cfm"/>
		<template name="title" title="buttons" file="formtitlebuttons.cfm"/>
		<template name="mainContent" title="Properties" file="eventproperties.cfm"/>
		<template name="mainContent" title="Attendees" file="attendees.cfm"/>
		<template name="mainContent" title="Event History" file="history.cfm"/>
	</action>

	<action name="Browse" isSecurityItem="0" template="blankpanels">
		<template name="html" title="Browse" file="browse.cfm"/>
		<template name="html" title="Search" file="search.cfm"/>
	</action>

	<action name="Event Search" onMenu="0" isSecurityItem="1" template="twocolumnwnavigation">
		<template name="browseContent" title="Browse" file="browse.cfm"/>
		<template name="browseContent" title="Search" file="search.cfm"/>
		<template name="title" title="Search Results" file="searchtitle.cfm"/>
		<template name="mainContent" title="Search Results" file="searchresults.cfm"/>
	</action>

	<action name="Save Event"/>

	<action name="Delete Event" isSecurityItem="1"/>
	<action name="Download XLS" isSecurityItem="1"/>

	<action name="editClientModule" method="editClientModule" onMenu="0" template="popup-onecol" formSubmit="saveclientmodule">
		<template name="title" title="label" file="clientmodulelabel.cfm"/>
		<template name="title" title="label" file="clientmodulebuttons.cfm"/>
		<template name="mainContent" title="Properties" file="clientmoduleform.cfm"/>
	</action>

	<action name="Save Client Module"/>
	<action name="delete Client Module"/>

	<action name="Search" method="search" onMenu="0" isSecurityItem="1" template="twocolumnwnavigation">
		<template name="browseContent" title="Browse" file="browse.cfm"/>
		<template name="browseContent" title="Search" file="search.cfm"/>
		<template name="title" title="Search Results" file="searchtitle.cfm"/>
		<template name="mainContent" title="Search Results" file="searchresults.cfm"/>
	</action>

</module>
</cfsavecontent>


<cfset modulexml = xmlparse(modulexml)>