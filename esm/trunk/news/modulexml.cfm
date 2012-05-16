<cfsavecontent variable="modulexml">
<module name="News" label="News" menuOrder="12" securityitems="Add News,Edit News,Delete News,View News Types,Add News Type,Edit News Type,Delete News Type">

	<action name="Start Page" template="twocolumnwnavigation">
		<template name="browseContent" title="Browse" file="browse.cfm"/>
		<template name="browseContent" title="Search" file="search.cfm"/>
		<template name="title" title="Start Page" file="starttitle.cfm"/>
		<template name="mainContent" title="Start Page" file="start.cfm"/>
		<template name="mainContent" title="Recent Site Activity" file="recentactivity.cfm"/>
	</action>

    <action name="Browse" isSecurityItem="0" template="blankpanels">
		<template name="html" title="Browse" file="browse.cfm"/>
		<template name="html" title="Search" file="search.cfm"/>
	</action>

	<!-- news items -->
	<action name="Add News" onMenu="1" isSecurityItem="1" isform="1" template="twocolumnwnavigation" formsubmit="savenews">
		<template name="browseContent" id="browse" title="Browse" file="browse.cfm"/>
		<template name="browseContent" title="Search" file="search.cfm"/>
		<template name="title" title="label" file="titlelabel.cfm"/>
		<template name="title" title="buttons" file="titlebuttons.cfm"/>
		<template name="mainContent" title="Properties" file="properties.cfm"/>
        <template name="mainContent" title="Content" file="html.cfm"/>
        <template name="mainContent" title="Embedded Asset" file="asset.cfm"/>
	</action>

	<action name="Edit News" isform="1" template="twocolumnwnavigation" formsubmit="saveNews">
		<template name="browseContent" id="browse" title="Browse" file="browse.cfm"/>
		<template name="browseContent" title="Search" file="search.cfm"/>
		<template name="title" title="label" file="titlelabel.cfm"/>
		<template name="title" title="buttons" file="titlebuttons.cfm"/>
		<template name="mainContent" title="Properties" file="properties.cfm"/>
        <template name="mainContent" title="Content" file="html.cfm"/>
		<template name="mainContent" title="Embedded Asset" file="asset.cfm"/>
		<template name="mainContent" title="History" file="history.cfm"/>
	</action>

	<action name="Save News"/>
	<action name="Delete News" isSecurityItem="1"/>
	<action name="Upload File Action"/>

	<action name="Search" onMenu="0" isSecurityItem="0" template="twocolumnwnavigation">
		<template name="browseContent" title="Browse" file="browse.cfm"/>
		<template name="browseContent" title="Search" file="search.cfm"/>
		<template name="title" title="Search Results" file="searchtitle.cfm"/>
		<template name="mainContent" title="Search Results" file="searchresults.cfm"/>
	</action>
	<!-- / news items -->


	<!-- / client module -->
	<action name="editClientModule" onMenu="0" template="popup-onecol" formSubmit="saveclientmodule">
		<template name="title" title="label" file="clientmodulelabel.cfm"/>
		<template name="title" title="label" file="clientmodulebuttons.cfm"/>
		<template name="mainContent" title="Properties" file="clientmoduleform.cfm"/>
	</action>

	<action name="upload File" onMenu="0" template="popup-onecol">
		<template name="title" title="label" file="uploadfiletitle.cfm"/>
		<template name="title" title="label" file="uploadfilebuttons.cfm"/>
		<template name="mainContent" title="Properties" file="uploadfileform.cfm"/>
	</action>

    <action name="Save Client Module"/>
    <action name="Delete Client Module"/>
	<!-- / client module -->

    <!-- news types -->
    <action name="View News Types" onMenu="1" template="twocolumnwnavigation">
		<template name="browseContent" title="Browse" file="browsetypes.cfm"/>
		<template name="title" title="Start Page" file="starttypetitle.cfm"/>
		<template name="mainContent" title="Start Page" file="starttypes.cfm"/>
		<template name="mainContent" title="Recent Activity" file="recenttypeactivity.cfm"/>
	</action>

	<action name="Add News Type" onMenu="1" isform="1" template="twocolumnwnavigation" formsubmit="savenewstype">
		<template name="browseContent" id="browse" title="Browse" file="browsetypes.cfm"/>
		<template name="title" title="label" file="titletypelabel.cfm"/>
		<template name="title" title="buttons" file="titletypebuttons.cfm"/>
		<template name="mainContent" title="Properties" file="typeproperties.cfm"/>
	</action>

	<action name="Save News Type"/>

	<action name="Edit News Type" isform="1" template="twocolumnwnavigation" formsubmit="savenewstype">
		<template name="browseContent" id="browse" title="Browse" file="browsetypes.cfm"/>
		<template name="title" title="label" file="titletypelabel.cfm"/>
		<template name="title" title="buttons" file="titletypebuttons.cfm"/>
		<template name="mainContent" title="Properties" file="typeproperties.cfm"/>
		<template name="mainContent" title="History" file="typehistory.cfm"/>
	</action>

	<action name="Delete News Type" isSecurityItem="1"/>

	<action name="Browse Types" isSecurityItem="0" template="blankpanels">
		<template name="html" title="Browse" file="browsetypes.cfm"/>
	</action>

	 <!-- /news types -->

</module>
</cfsavecontent>

<cfset modulexml = xmlparse(modulexml)>



