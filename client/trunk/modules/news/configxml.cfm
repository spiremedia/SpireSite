<cfsavecontent variable="modulexml">
<moduleInfo searchable="1">
	<itempath>NewsAndEvents/News/</itempath>
	<action match="^NewsAndEvents/News/[A-Z0-9\-]{35}/?$">
		<loadcfc>newsView</loadcfc>
		<template>Interior2Column</template>
		<title>News</title>
		<pagename>News Item</pagename>
		<description>News</description>
		<keywords>news, happenings</keywords>
	</action>
    <action match="^rss/news/[A-Z0-9\-]{35}/?$">
		<loadcfc>rssView</loadcfc>
		<template>_blank</template>
	</action>
</moduleInfo>
</cfsavecontent>

<cfset modulexml = xmlparse(modulexml)>