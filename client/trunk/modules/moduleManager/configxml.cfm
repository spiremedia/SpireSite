<cfsavecontent variable="modulexml">
<moduleInfo embedeable="false">
	<action match="^system/modules/">
		<loadcfc>mgr</loadcfc>
		<title>Module Mgr</title>
		<template>_esm</template>
	</action>
</moduleInfo>
</cfsavecontent>

<cfset modulexml = xmlparse(modulexml)>

