<cfsavecontent variable="modulexml">
<module name="Assets" label="Assets" menuOrder="11" securityitems="Add Asset,Edit Asset,Delete Asset,View Asset Groups,Add Asset Group,Edit Asset Group,Delete Asset Group,Bulk Upload">

	<action name="Start Page" template="twocolumnwnavigation">
		<template name="browseContent" title="Browse" file="browse.cfm"/>
		<template name="browseContent" title="Search" file="search.cfm"/>
		<template name="title" title="Welcome to the Assets Area" file="start.cfm"/>
        <template name="mainContent" title="Start Page" file="start.cfm"/>
        <template name="mainContent" title="Recent Site Activity" file="recenthistory.cfm"/>
	</action>

	<action name="Add Asset" onMenu="1" isSecurityItem="1" isform="1" template="twocolumnwnavigation" formsubmit="saveasset">
		<template name="browseContent" id="browse" title="Browse" file="browse.cfm"/>
		<template name="browseContent" title="Search" file="search.cfm"/>
		<template name="title" title="label" file="titlelabel.cfm"/>
		<template name="title" title="buttons" file="titlebuttons.cfm"/>
		<template name="mainContent" title="Properties" file="properties.cfm"/>
	</action>

	<action name="Save Asset"/>

	<action name="Edit Asset" isform="1" template="twocolumnwnavigation" formsubmit="saveasset">
		<template name="browseContent" id="browse" title="Browse" file="browse.cfm"/>
		<template name="browseContent" title="Search" file="search.cfm"/>
		<template name="title" title="label" file="titlelabel.cfm"/>
		<template name="title" title="buttons" file="titlebuttons.cfm"/>
		<template name="mainContent" title="Properties" file="properties.cfm"/>
        <template name="mainContent" title="Edit" file="editasset.cfm"/>
		<template name="mainContent" title="Download" file="download.cfm"/>
		<template name="mainContent" title="History" file="history.cfm"/>
	</action>
    
    <action name="eaImg"/>
        
	<action name="Delete Asset" isSecurityItem="1"/>
	<action name="view Image" />

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
	
	<action name="View Asset Groups" onMenu="1" template="twocolumnwnavigation">
		<template name="browseContent" title="Browse" file="browsegroups.cfm"/>
		<template name="browseContent" title="Search" file="searchgroups.cfm"/>
		<template name="title" title="Start Page" file="startgrouptitle.cfm"/>
		<template name="mainContent" title="Start Page" file="startgroups.cfm"/>
		<template name="mainContent" title="Recent Site Activity" file="recentgroupactivity.cfm"/>
	</action>
	
	<action name="Add Asset Group" onMenu="1" isform="1" template="twocolumnwnavigation" formsubmit="saveassetgroup">
		<template name="browseContent" id="browse" title="Browse" file="browsegroups.cfm"/>
		<template name="browseContent" title="Search" file="searchgroups.cfm"/>
		<template name="title" title="label" file="titlegrouplabel.cfm"/>
		<template name="title" title="buttons" file="titlegroupbuttons.cfm"/>
		<template name="mainContent" title="Properties" file="groupproperties.cfm"/>
	</action>
	
	<action name="Save Asset Group"/>
	
	<action name="Edit Asset Group" isform="1" template="twocolumnwnavigation" formsubmit="saveAssetgroup">
		<template name="browseContent" id="browse" title="Browse" file="browsegroups.cfm"/>
		<template name="browseContent" title="Search" file="searchgroups.cfm"/>
		<template name="title" title="label" file="titlegrouplabel.cfm"/>
		<template name="title" title="buttons" file="titlegroupbuttons.cfm"/>
		<template name="mainContent" title="Properties" file="groupproperties.cfm"/>
		<template name="mainContent" title="History" file="grouphistory.cfm"/>
	</action>
	
	<action name="Delete Asset Group" isSecurityItem="1"/>

	<action name="BrowseGroups" isSecurityItem="0" template="blankpanels">
		<template name="html" title="Browse" file="browsegroups.cfm"/>
		<template name="html" title="Search" file="searchgroups.cfm"/>
	</action>

	<action name="Group Search" onMenu="0" isSecurityItem="1" template="twocolumnwnavigation">
		<template name="browseContent" title="Browse" file="browsegroups.cfm"/>
		<template name="browseContent" title="Search" file="searchgroups.cfm"/>
		<template name="title" title="Search Results" file="searchgrouptitle.cfm"/>
		<template name="mainContent" title="Search Results" file="searchgroupresults.cfm"/>
	</action>
    
    <action name="tinyMCEUpload" onMenu="0" isSecurityItem="1" template="plain">
		<template name="html" title="tinyMCE Upload" file="tmceuploadform.cfm"/>
	</action>
	
	<action name="ListedAssetUpload" onMenu="0" isSecurityItem="1" template="plain">
		<template name="html" title="tinyMCE Upload" file="listedassetuploadform.cfm"/>
	</action>
    
    <action name="tinyMCEUploadAction" />
	
	<action name="listedAssetUploadAction" />
    <action name="assetListingHtml" />
    
    <action name="Upload Asset" template="onecolumnwnavigation">
		<template name="title" title="buttons" file="uploadtitle.cfm"/>
		<template name="title" title="buttons" file="uploadbuttons.cfm"/>
		<template name="mainContent" title="Properties" file="uploadform.cfm"/>
	</action>
	
	<action name="Upload Asset Action" />
	
	<action name="Bulk Upload" onMenu="1" isSecurityItem="1" template="twocolumnwnavigation" fileupload="true" formsubmit="bulkuploadaction">
		<template name="browseContent" title="Browse" id="browse" file="browse.cfm"/>
		<template name="browseContent" title="Search" file="search.cfm"/>
		<template name="title" title="buttons" file="bulkuploadtitle.cfm"/>
		<template name="title" title="buttons" file="bulkuploadbuttons.cfm"/>
		<template name="mainContent" title="Properties" file="bulkuploadform.cfm"/>
	</action>
	
	<action name="Bulk Upload Action" />

</module>
</cfsavecontent>

<cfset modulexml = xmlparse(modulexml)>



