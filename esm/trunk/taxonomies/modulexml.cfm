<cfsavecontent variable="modulexml">
	<module name="Taxonomies" label="Taxonomies" menuorder="80" topnav="true" securityitems="">

		<action name="Start Page" template="twocolumnwnavigation">
			<template name="browseContent" title="Browse" file="browse.cfm"/>
			<template name="title" title="label" file="starttitle.cfm"/>
			<template name="mainContent" title="Start Page" file="startcontents.cfm"/>
		</action>
		<action name="Add Taxonomy" onMenu="1" isform="1" template="twocolumnwnavigation" formsubmit="saveTaxonomy">
			<template name="browseContent" id="browse" title="Browse" file="browse.cfm"/>
			<template name="browseContent" title="Search" file="search.cfm"/>
			<template name="title" title="label" file="titleTaxonomy.cfm"/>
			<template name="title" title="buttons" file="buttonsTaxonomy.cfm"/>
			<template name="mainContent" title="Properties" file="formTaxonomy.cfm"/>
		</action>
		<action name="Edit Taxonomy" isform="1" template="twocolumnwnavigation" formsubmit="saveTaxonomy">
			<template name="browseContent" id="browse" title="Browse" file="browse.cfm"/>
			<template name="browseContent" title="Search" file="search.cfm"/>
			<template name="title" title="label" file="titleTaxonomy.cfm"/>
			<template name="title" title="buttons" file="buttonsTaxonomy.cfm"/>
			<template name="mainContent" title="Properties" file="formTaxonomy.cfm"/>
			<template name="mainContent" title="Item List" file="listTaxonomyItems.cfm"/>
			<template name="mainContent" title="History" file="history.cfm"/>
		</action>
		<action name="Add Taxonomy Item" isform="1" template="twocolumnwnavigation" formsubmit="saveTaxonomyItem">
			<template name="browseContent" id="browse" title="Browse" file="browseitem.cfm"/>
			<template name="browseContent" title="Search" file="search.cfm"/>
			<template name="title" title="label" file="titleTaxonomyItem.cfm"/>
			<template name="title" title="buttons" file="buttonsTaxonomyItem.cfm"/>
			<template name="mainContent" title="Properties" file="formTaxonomyItem.cfm"/>
		</action>
		<action name="Edit Taxonomy Item" isform="1" template="twocolumnwnavigation" formsubmit="saveTaxonomyItem">
			<template name="browseContent" id="browse" title="Browse" file="browseitem.cfm"/>
			<template name="browseContent" title="Search" file="search.cfm"/>
			<template name="title" title="label" file="titleTaxonomyItem.cfm"/>
			<template name="title" title="buttons" file="buttonsTaxonomyItem.cfm"/>
			<template name="mainContent" title="Properties" file="formTaxonomyItem.cfm"/>
			<template name="mainContent" title="History" file="history.cfm"/>
		</action>
		<action name="Search" onMenu="0" isSecurityItem="1" template="twocolumnwnavigation">
			<template name="browseContent" title="Browse" file="browse.cfm"/>
			<template name="browseContent" title="Search" file="search.cfm"/>
			<template name="title" title="Search Results" file="searchtitle.cfm"/>
			<template name="mainContent" title="Search Results" file="searchresults.cfm"/>
		</action>
		
		<action name="browse"/>
		<action name="browseItem"/>
		<action name="deleteTaxonomy"/>
		<action name="deleteTaxonomyitem"/>
		<action name="saveTaxonomy"/>
		<action name="deleteTaxonomyItem"/>
		<action name="saveTaxonomyItem"/>
		
		<action name="Taxonomy Menus" template="twocolumnwnavigation" onMenu="1">
			<template name="browseContent" title="Browse" file="browsemenu.cfm"/>
			<template name="title" title="label" file="startmenutitle.cfm"/>
			<template name="mainContent" title="Start Page" file="startmenucontents.cfm"/>
		</action>
		
		<action name="Add Taxonomy Menu" onMenu="1" isform="1" template="twocolumnwnavigation" formsubmit="saveTaxonomyMenu">
			<template name="browseContent" id="browse" title="Browse" file="browsemenu.cfm"/>
			<template name="title" title="label" file="titletaxonomymenu.cfm"/>
			<template name="title" title="buttons" file="buttonstaxonomymenu.cfm"/>
			<template name="mainContent" title="Properties" file="formtaxonomymenu.cfm"/>
		</action>
		
		<action name="Edit Taxonomy Menu" isform="1" template="twocolumnwnavigation" formsubmit="saveTaxonomyMenu">
			<template name="browseContent" id="browse" title="Browse" file="browsemenu.cfm"/>
			<template name="title" title="label" file="titletaxonomymenu.cfm"/>
			<template name="title" title="buttons" file="buttonstaxonomymenu.cfm"/>
			<template name="mainContent" title="Properties" file="formtaxonomymenu.cfm"/>
			<template name="mainContent" title="History" file="historymenu.cfm"/>
		</action>
		
		<action name="browseMenu"/>
		<action name="deleteTaxonomyMenu"/>
		<action name="saveTaxonomyMenu"/>
		<action name="saveTaxonomyMenuOrder"/>
		
		<action name="Edit Taxonomy Menu Order" isform="1" template="twocolumnwnavigation" formsubmit="saveTaxonomyMenuOrder">
			<template name="browseContent" id="browse" title="Browse" file="browsemenu.cfm"/>
			<template name="title" title="label" file="titletaxonomymenuorder.cfm"/>
			<template name="title" title="buttons" file="buttonstaxonomymenuorder.cfm"/>
			<template name="mainContent" title="Properties" file="formtaxonomymenuorder.cfm"/>
		</action>
		
		<!-- / client module -->
		<action name="editClientModule" onMenu="0" template="popup-onecol" formSubmit="saveclientmodule">
			<template name="title" title="label" file="clientmodulelabel.cfm"/>
			<template name="title" title="label" file="clientmodulebuttons.cfm"/>
			<template name="mainContent" title="Properties" file="clientmoduleform.cfm"/>
		</action>
		
		<action name="Save Client Module"/>
    	<action name="Delete Client Module"/>
		
	</module>
</cfsavecontent>

<cfset modulexml = xmlparse(modulexml)>
