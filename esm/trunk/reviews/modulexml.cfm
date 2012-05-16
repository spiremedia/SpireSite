<cfsavecontent variable="modulexml">
<module name="reviews" label="Reviews" menuOrder="120" securityitems="Product Reviews,Edit Review,Delete Review">

	<action name="Start Page" template="onecolumnwnavigation">
		<template name="title" title="label" file="starttitle.cfm"/>
		<template name="mainContent" title="Start Page" file="start.cfm"/>
		<template name="mainContent" title="Recent Site Activity" file="recentactivity.cfm"/>
	</action>

	<action name="Search" onMenu="0" isSecurityItem="0" template="twocolumnwnavigation">
		<template name="browseContent" title="Browse" file="browse.cfm"/>
		<template name="browseContent" title="Search" file="search.cfm"/>
		<template name="title" title="Search Results" file="searchtitle.cfm"/>
		<template name="mainContent" title="Search Results" file="searchresults.cfm"/>
	</action>

    <action name="Browse" isSecurityItem="0" template="blankpanels">
		<template name="html" title="Browse" file="browse.cfm"/>
		<template name="html" title="Search" file="search.cfm"/>
	</action>

	<action name="Save Review"/>
	<action name="Delete Review" isSecurityItem="1"/>

	<action name="Edit Review" isSecurityItem="1" isform="1" template="twocolumnwnavigation" formsubmit="saveReview">
		<template name="browseContent" id="browse" title="Browse" file="browse.cfm"/>
		<template name="browseContent" title="Search" file="search.cfm"/>
		<template name="title" title="label" file="titlelabel.cfm"/>
		<template name="title" title="buttons" file="titlebuttons.cfm"/>
		<template name="mainContent" title="Properties" file="properties.cfm"/>
		<template name="mainContent" title="History" file="history.cfm"/>
	</action>
	
	<action name="Product Reviews" onMenu="1" isSecurityItem="1" template="twocolumnwnavigation">
		<template name="browseContent" title="Browse" file="browse.cfm"/>
		<template name="browseContent" title="Search" file="search.cfm"/>
		<template name="title" title="label" file="starttitle.cfm"/>
		<template name="mainContent" title="Start Page" file="start.cfm"/>
		<template name="mainContent" title="Recent Site Activity" file="recentactivity.cfm"/>
	</action>
</module>
</cfsavecontent>

<cfset modulexml = xmlparse(modulexml)>



