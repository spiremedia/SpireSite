<cfsavecontent variable="modulexml">
<moduleInfo searchable="1">
	<itempath>NewsAndEvents/Events/</itempath>
	<action match="^NewsAndEvents/Events/[A-Z0-9\-]{35}/?">
		<loadcfc>eventView</loadcfc>
		<template>Interior2Column</template>
		<title>Events &amp; Registration</title>
		<pagename>Events &amp; Registration</pagename>
		<description>Applejack Events</description>
		<keywords>events, happenings</keywords>
	</action>
	<action match="^NewsAndEvents/Events/Register/[A-Z0-9\-]{35}/?">
		<loadcfc>eventView</loadcfc>
		<template>Interior2Column</template>
		<title>Events &amp; Registration</title>
		<pagename>Events &amp; Registration</pagename>
		<description>Events</description>
		<keywords>events, happenings</keywords>
		<onSuccess>NewsAndEvents/Thanks/</onSuccess>
	</action>
	<action match="^NewsAndEvents/Events/Thanks/[A-Z0-9\-]{35}/?">
		<loadcfc>eventView</loadcfc>
		<template>Interior2Column</template>
		<title>Events Confirmation</title>
		<pagename>Events Confirmation</pagename>
		<description>Events</description>
		<keywords>events, happenings</keywords>
	</action>
</moduleInfo>
</cfsavecontent>

<cfset modulexml = xmlparse(modulexml)>