<cfsavecontent variable="modulexml">
	<module name="messaging" label="Messaging" menuorder="15" topnav="true" securityitems="Add Messaging,Edit Messaging,Delete Messaging">
	
		<action name="Start Page" template="twocolumnwnavigation">
			<template name="browseContent" title="Browse" file="browse.cfm"/>
			<template name="title" title="label" file="starttitle.cfm"/>
			<template name="mainContent" title="Start Page" file="startcontents.cfm"/>
		</action>
		<action name="Add Messaging" isSecurityItem="1" onMenu="1" isform="1" template="twocolumnwnavigation" formsubmit="saveMessaging">
			<template name="browseContent" id="browse" title="Browse" file="browse.cfm"/>
			<template name="browseContent" title="Search" file="search.cfm"/>
			<template name="title" title="label" file="titleMessaging.cfm"/>
			<template name="title" title="buttons" file="buttonsMessaging.cfm"/>
			<template name="mainContent" title="Properties" file="formMessaging.cfm"/>
		</action>
		<action name="Edit Messaging" isform="1" template="twocolumnwnavigation" formsubmit="saveMessaging">
			<template name="browseContent" id="browse" title="Browse" file="browse.cfm"/>
			<template name="browseContent" title="Search" file="search.cfm"/>
			<template name="title" title="label" file="titleMessaging.cfm"/>
			<template name="title" title="buttons" file="buttonsMessaging.cfm"/>
			<template name="mainContent" title="Properties" file="formMessaging.cfm"/>
			<template name="mainContent" title="History" file="history.cfm"/>
		</action>		
		<action name="Search"  onMenu="0" isSecurityItem="1" template="twocolumnwnavigation">
			<template name="browseContent" title="Browse" file="browse.cfm"/>
			<template name="browseContent" title="Search" file="search.cfm"/>
			<template name="title" title="Search Results" file="searchtitle.cfm"/>
			<template name="mainContent" title="Search Results" file="searchresults.cfm"/>
		</action>	
		<action name="browse"/>	
		<action name="delete Messaging"/>	
		<action name="save Messaging"/>
		
	</module>
</cfsavecontent>

<cfset modulexml = xmlparse(modulexml)>
