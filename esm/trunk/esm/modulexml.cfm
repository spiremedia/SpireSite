<cfsavecontent variable="modulexml">
<module name="ESM" label="ESM" menuOrder="100" topnav="true" securityitems="Local Settings,Modules,Download Module">

	<action name="Start Page" template="onecolumnwnavigation">
		<template name="browseContent" title="Browse" file="browse.cfm"/>
		<template name="title" title="label" file="starttitle.cfm"/>
		<template name="mainContent" title="Start Page" file="start.cfm"/>
	</action>

	<action name="Local Settings" isSecurityItem="1" onmenu="1" template="onecolumnwnavigation" formsubmit="updatelocalsettings">
		<template name="browseContent" title="Browse" file="browse.cfm"/>
		<template name="title" title="label" file="settingslabel.cfm"/>
        <template name="title" title="btn" file="settingsbutton.cfm"/>
		<template name="mainContent" title="Data" file="settingsform.cfm"/>
   	</action>

    <action name="updateLocalSettings"/>

    <action name="Modules" isSecurityItem="1" onmenu="1" template="twocolumnwnavigation">
    	<template name="browseContent" title="Browse" file="browsemodules.cfm"/>
		<template name="title" title="label" file="sitemodulestitlestart.cfm"/>
		<template name="mainContent" title="" file="sitemodulescontentstart.cfm"/>
	</action>
	
	 <action name="Tables" isSecurityItem="1" onmenu="1" template="twocolumnwnavigation">
    	<template name="browseContent" title="Browse" file="browsemodules.cfm"/>
		<template name="title" title="label" file="tablestitle.cfm"/>
		<template name="mainContent" title="" file="tablescontent.cfm"/>
	</action>

	<action name="Module" template="twocolumnwnavigation">
		<template name="browseContent" title="Browse" file="browsemodules.cfm"/>
		<template name="title" title="label" file="moduletitle.cfm"/>
		<template name="mainContent" title="Start Page" file="modulecontent.cfm"/>
	</action>

	<action name="View" template="twocolumnwnavigation" formsubmit="saveView">
		<template name="browseContent" title="Browse" file="browsemodules.cfm"/>
		<template name="title" title="label" file="viewtitle.cfm"/>
		<template name="mainContent" title="Start Page" file="viewcontent.cfm"/>
	</action>

	<action name="Action" template="twocolumnwnavigation" formsubmit="saveAction">
		<template name="browseContent" title="Browse" file="browsemodules.cfm"/>
		<template name="title" title="label" file="actiontitle.cfm"/>
		<template name="mainContent" title="Start Page" file="actioncontent.cfm"/>
	</action>

	<action name="Test" template="twocolumnwnavigation" formsubmit="saveTest">
		<template name="browseContent" title="Browse" file="browsemodules.cfm"/>
		<template name="title" title="label" file="testtitle.cfm"/>
		<template name="mainContent" title="Start Page" file="testcontent.cfm"/>
	</action>

	<action name="Model" template="twocolumnwnavigation" formsubmit="saveModel">
		<template name="browseContent" title="Browse" file="browsemodules.cfm"/>
		<template name="title" title="label" file="modeltitle.cfm"/>
		<template name="mainContent" title="Start Page" file="modelcontent.cfm"/>
	</action>

	<action name="Template" template="twocolumnwnavigation" formsubmit="saveTemplate">
		<template name="browseContent" title="Browse" file="browsemodules.cfm"/>
		<template name="title" title="label" file="templatetitle.cfm"/>
		<template name="mainContent" title="Start Page" file="templatecontent.cfm"/>
	</action>

	<action name="Editables" template="twocolumnwnavigation" formsubmit="generateEditables">
		<template name="browseContent" title="Browse" file="browsemodules.cfm"/>
		<template name="title" title="label" file="editablestitle.cfm"/>
		<template name="mainContent" title="Start Page" file="editablescontent.cfm"/>
	</action>
	
	<action name="Download Module" issecurityitem="1" onmenu="1" template="twocolumnwnavigation">
		<template name="browseContent" title="Browse" file="browsemodules.cfm"/>
		<template name="title" title="label" file="downloadmoduletitle.cfm"/>
		<template name="mainContent" title="Start Page" file="downloadmodulecontent.cfm"/>
	</action>
	
	<action name="Install Downloadable Module" template="twocolumnwnavigation">
		<template name="browseContent" title="Browse" file="browsemodules.cfm"/>
		<template name="title" title="label" file="downloadmoduleresultstitle.cfm"/>
		<template name="mainContent" title="Step By Step" file="downloadmoduleResults.cfm"/>
	</action>

    <action name="saveSkeletonModule"/>
	<action name="saveSimpleModule"/>
	<action name="saveModel"/>
	<action name="saveAction"/>
	<action name="saveTest"/>
	<action name="saveView"/>
	<action name="saveTemplate"/>
	<action name="generateeditables"/>
	<action name="gettableinfo"/>
</module>
</cfsavecontent>


<cfset modulexml = xmlparse(modulexml)>
