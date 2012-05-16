<cfsavecontent variable="modulexml">
<module name="Search" label="Search" menuOrder="24" topnav="false" securityitems="Edit Key Phrases,Local Searches">

	<action name="Start Page" template="twocolumnwnavigation">
		<template name="browseContent" title="Browse" file="browse.cfm"/>
		<template name="title" title="label" file="starttitle.cfm"/>
		<template name="mainContent" title="Start Page" file="start.cfm"/>
	</action>
	
	<action name="Indexed Data" template="twocolumnwnavigation" onmenu="1">
		<template name="browseContent" title="Browse" file="indexablesearch.cfm"/>
		<template name="title" title="label" file="indexabletitle.cfm"/>
		<template name="mainContent" title="Indexables" file="indexableslist.cfm"/>
	</action>
	
	<action name="View Indexable" template="twocolumnwnavigation">
		<template name="browseContent" title="Browse" file="indexablesearch.cfm"/>
		<template name="title" title="label" file="indexabletitle.cfm"/>
		<template name="mainContent" title="Indexable" file="indexableItem.cfm"/>
	</action>

	<action name="Edit Key Phrases" method="keyphrases" label="Edit Key Phrases" isSecurityItem="1" onmenu="1" template="twocolumnwnavigation" formsubmit="keyphrasessave">
		<template name="browseContent" title="Browse" file="browse.cfm"/>
		<template name="title" title="label" file="keyphraseslabel.cfm"/>
        <template name="title" title="btn" file="keyphrasesbutton.cfm"/>
		<template name="mainContent" title="Data" file="keyphrasesform.cfm"/>
   	</action>

    <action name="Site Search View By Month" isSecurityItem="1" template="twocolumnwnavigation">
		<template name="browseContent" title="Browse" file="sitesearchbrowse.cfm"/>
		<template name="browseContent" title="Search" file="sitesearchsearch.cfm"/>
		<template name="title" title="label" file="sitesearchtitlelabel.cfm"/>
		<template name="mainContent" title="" file="sitesearchbymonth.cfm"/>
	</action>

    <action name="Local Searches" method="sitesearchstart" onmenu="1" isSecurityItem="1" template="twocolumnwnavigation">
		<template name="browseContent" title="Browse" file="sitesearchbrowse.cfm"/>
		<template name="browseContent" title="Search" file="sitesearchsearch.cfm"/>
		<template name="title" title="label" file="sitesearchtitlelabel.cfm"/>
		<template name="mainContent" title="" file="sitesearchstart.cfm"/>
	</action>

	<action name="SiteSearchsearch" isSecurityItem="1" template="twocolumnwnavigation">
		<template name="browseContent" title="Browse" file="sitesearchbrowse.cfm"/>
		<template name="browseContent" title="Search" file="sitesearchsearch.cfm"/>
		<template name="title" title="label" file="sitesearchtitlelabel.cfm"/>
		<template name="mainContent" title="" file="sitesearchsearchresults.cfm"/>
	</action>

    <action name="keyphrasessave"/>

	<action name="editClientModule" method="editClientModule" onMenu="0" template="popup-onecol" formSubmit="saveclientmodule">
		<template name="title" title="label" file="clientmodulelabel.cfm"/>
		<template name="title" title="label" file="clientmodulebuttons.cfm"/>
		<template name="mainContent" title="Properties" file="clientmoduleform.cfm"/>
	</action>

	<action name="Save Client Module"/>
	<action name="delete Client Module"/>

</module>
</cfsavecontent>


<cfset modulexml = xmlparse(modulexml)>