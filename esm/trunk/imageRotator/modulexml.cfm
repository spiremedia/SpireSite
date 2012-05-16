<cfsavecontent variable="modulexml">
	<module name="imageRotator" label="Image Rotator" menuorder="101" topnav="false" securityitems="Add Image,Edit Image,Delete Image">

		<action name="Start Page" template="twocolumnwnavigation">
			<template name="browseContent" title="Browse" file="browse.cfm"/>
			<template name="browseContent" title="Search" file="search.cfm"/>
			<template name="title" title="label" file="starttitle.cfm"/>
			<template name="mainContent" title="Start Page" file="startcontents.cfm"/>
		</action>
		<action name="Add Image" onMenu="1" isform="1" template="twocolumnwnavigation" formsubmit="saveImage">
			<template name="browseContent" id="browse" title="Browse" file="browse.cfm"/>
			<template name="browseContent" title="Search" file="search.cfm"/>
			<template name="title" title="label" file="titleImage.cfm"/>
			<template name="title" title="buttons" file="buttonsImage.cfm"/>
			<template name="mainContent" title="Properties" file="formImage.cfm"/>
		</action>
		<action name="Edit Image" isform="1" template="twocolumnwnavigation" formsubmit="saveImage">
			<template name="browseContent" id="browse" title="Browse" file="browse.cfm"/>
			<template name="browseContent" title="Search" file="search.cfm"/>
			<template name="title" title="label" file="titleImage.cfm"/>
			<template name="title" title="buttons" file="buttonsImage.cfm"/>
			<template name="mainContent" title="Properties" file="formImage.cfm"/>
			<template name="mainContent" title="View Image" file="viewimage.cfm"/>
			<!--- <template name="mainContent" title="History" file="history.cfm"/> --->
		</action>
		<action name="Search" onMenu="0" isSecurityItem="1" template="twocolumnwnavigation">
			<template name="browseContent" title="Browse" file="browse.cfm"/>
			<template name="browseContent" title="Search" file="search.cfm"/>
			<template name="title" title="Search Results" file="searchtitle.cfm"/>
			<template name="mainContent" title="Search Results" file="searchresults.cfm"/>
		</action>

		<action name="Upload Image" template="onecolumnwnavigation" fileupload="true" formsubmit="uploadImageAction">
			<template name="title" title="buttons" file="uploadtitle.cfm"/>
			<template name="title" title="buttons" file="uploadbuttons.cfm"/>
			<template name="mainContent" title="Properties" file="uploadform.cfm"/>
		</action>
		
		<action name="editClientModule" method="editClientModule" onMenu="0" template="popup-onecol" formSubmit="saveclientmodule">
			<template name="title" title="label" file="clientmodulelabel.cfm"/>
			<template name="title" title="label" file="clientmodulebuttons.cfm"/>
			<template name="mainContent" title="Properties" file="clientmoduleform.cfm"/>
		</action>
		
		<action name="Save Client Module"/>
		<action name="delete Client Module"/>
		
		<action name="Upload Image Action" />

		<action name="browse"/>
		<action name="deleteImage"/>
		<action name="saveImage"/>
		<images>
			<img name="filename" maxwidth="606" maxheight="210" extensionmod="" resize="1" alloweableExtensions="jpg,gif,png" />
		</images>
	</module>
</cfsavecontent>

<cfset modulexml = xmlparse(modulexml)>
