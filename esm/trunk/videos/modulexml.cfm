<cfsavecontent variable="modulexml">
<module name="Videos" label="Videos" menuOrder="20" securityitems="Add Video,Save Video,Edit Video,Delete Video,View Video Groups,Add Video Group,Save Video Group,Edit Video Group,Delete Video Group">
	<action name="Start Page" template="twocolumnwnavigation">
		<template name="browseContent" title="Browse" file="browse.cfm"/>
		<template name="browseContent" title="Search" file="search.cfm"/>
		<template name="title" title="Welcome to the Images Area" file="start.cfm"/>
        <template name="mainContent" title="Start Page" file="start.cfm"/>
        <template name="mainContent" title="Recent Site Activity" file="recenthistory.cfm"/>
	</action>

	<action name="Add Video" onMenu="1" isSecurityItem="1" isform="1" template="twocolumnwnavigation" formsubmit="saveVideo">
		<template name="browseContent" id="browse" title="Browse" file="browse.cfm"/>
		<template name="browseContent" title="Search" file="search.cfm"/>
		<template name="title" title="label" file="titlelabel.cfm"/>
		<template name="title" title="buttons" file="titlebuttons.cfm"/>
		<template name="mainContent" title="Properties" file="properties.cfm"/>
	</action>

	<action name="Save Video"/>

	<action name="Edit Video" isform="1" template="twocolumnwnavigation" formsubmit="saveVideo">
		<template name="browseContent" id="browse" title="Browse" file="browse.cfm"/>
		<template name="browseContent" title="Search" file="search.cfm"/>
		<template name="title" title="label" file="titlelabel.cfm"/>
		<template name="title" title="buttons" file="titlebuttons.cfm"/>
		<template name="mainContent" title="Properties" file="properties.cfm"/>
		<template name="mainContent" title="View Video" file="viewvideo.cfm"/>
		<template name="mainContent" title="History" file="history.cfm"/>
	</action>

    <action name="eaImg"/>
    <action name="view Image" />

	<action name="Delete Video" isSecurityItem="1"/>

	<action name="Upload Video" template="onecolumnwnavigation" fileupload="true" formsubmit="uploadVideoAction">
		<template name="title" title="buttons" file="uploadtitle.cfm"/>
		<template name="title" title="buttons" file="uploadbuttons.cfm"/>
		<template name="mainContent" title="Properties" file="uploadform.cfm"/>
	</action>

	<action name="Upload Video Action" />

	<action name="Browse" isSecurityItem="0" template="blankpanels">
		<template name="html" title="Browse" file="browse.cfm"/>
		<template name="html" title="Search" file="search.cfm"/>
	</action>

	<action name="Search" onMenu="0" isSecurityItem="0" template="twocolumnwnavigation">
		<template name="browseContent" title="Browse" file="browse.cfm"/>
		<template name="browseContent" title="Search" file="search.cfm"/>
		<template name="title" title="Search Results" file="searchtitle.cfm"/>
		<template name="mainContent" title="Search Results" file="searchresults.cfm"/>
	</action>

	<action name="editClientModule" method="editClientModule" onMenu="0" template="popup-onecol" formSubmit="saveclientmodule">
		<template name="title" title="label" file="clientmodulelabel.cfm"/>
		<template name="title" title="label" file="clientmodulebuttons.cfm"/>
		<template name="mainContent" title="Properties" file="clientmoduleform.cfm"/>
	</action>

	<action name="Save Client Module"/>
	<action name="Delete Client Module"/>

	<action name="View Video Groups" onMenu="1" template="twocolumnwnavigation">
		<template name="browseContent" title="Browse" file="browsegroups.cfm"/>
		<template name="browseContent" title="Search" file="searchgroups.cfm"/>
		<template name="title" title="Start Page" file="startgrouptitle.cfm"/>
		<template name="mainContent" title="Start Page" file="startgroups.cfm"/>
		<template name="mainContent" title="Recent Site Activity" file="recentgroupactivity.cfm"/>
	</action>

	<action name="Add Video Group" onMenu="1" isform="1" template="twocolumnwnavigation" formsubmit="saveVideogroup">
		<template name="browseContent" id="browse" title="Browse" file="browsegroups.cfm"/>
		<template name="browseContent" title="Search" file="searchgroups.cfm"/>
		<template name="title" title="label" file="titlegrouplabel.cfm"/>
		<template name="title" title="buttons" file="titlegroupbuttons.cfm"/>
		<template name="mainContent" title="Properties" file="groupproperties.cfm"/>
	</action>

	<action name="Save Video Group"/>

	<action name="Edit Video Group" isform="1" template="twocolumnwnavigation" formsubmit="saveVideogroup">
		<template name="browseContent" id="browse" title="Browse" file="browsegroups.cfm"/>
		<template name="browseContent" title="Search" file="searchgroups.cfm"/>
		<template name="title" title="label" file="titlegrouplabel.cfm"/>
		<template name="title" title="buttons" file="titlegroupbuttons.cfm"/>
		<template name="mainContent" title="Properties" file="groupproperties.cfm"/>
		<template name="mainContent" title="History" file="grouphistory.cfm"/>
	</action>

	<action name="Delete Video Group" isSecurityItem="1"/>

	<action name="BrowseGroups" isSecurityItem="0" template="blankpanels">
		<template name="html" title="Browse" file="browsegroups.cfm"/>
		<template name="html" title="Search" file="searchgroups.cfm"/>
	</action>

	<action name="Group Search" onMenu="0" isSecurityItem="1" template="twocolumnwnavigation">
		<template name="browseContent" id="browse" title="Browse" file="browsegroups.cfm"/>
		<template name="browseContent" title="Search" file="searchgroups.cfm"/>
		<template name="title" title="Search Results" file="searchgrouptitle.cfm"/>
		<template name="mainContent" title="Search Results" file="searchgroupresults.cfm"/>
	</action>

	<images>
		<img name="thmbfilename" maxwidth="90" maxheight="68" extensionmod="_thmb" resize="1" alloweableExtensions="jpg,png" />
		<img name="videofilename" maxwidth="" maxheight="" extensionmod="" resize="0" alloweableExtensions="flv" />
	</images>
</module>
</cfsavecontent>

<cfset modulexml = xmlparse(modulexml)>