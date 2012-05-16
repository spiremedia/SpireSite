<cfsavecontent variable="modulexml">
<moduleInfo>
	<action match="^system/blockpreview/[A-Z0-9\-]{35}/?$">
		<loadcfc>blockPreview</loadcfc>
		<template>Interior2Column</template>
		<title>Block Preview</title>
		<pagename>Block Preview</pagename>
		<description></description>
		<keywords></keywords>
		<breadcrumbs></breadcrumbs>
	</action>
</moduleInfo>
</cfsavecontent>

<cfset modulexml = xmlparse(modulexml)>