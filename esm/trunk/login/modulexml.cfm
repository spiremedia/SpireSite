<cfsavecontent variable="modulexml">
<module name="Login" label="Login" menuOrder="1" topnav="true" securityitems="Change Password,Add Announcement,Edit Announcement,Delete Announcement">

	<action name="Start Page" isSecurityItem="1" isform="1" template="onecolumnwnavigation">
		<template name="title" title="label" file="startlabel.cfm"/>
		<template name="mainContent" title="" file="editablelist.cfm"/>
	</action>

	<action name="Login Form" template="onecolumnnonav" formsubmit="checkLogin">
		<template name="mainContent" title="loginForm" file="loginform.cfm"/>
	</action>

	<action name="Welcome" template="onecolumnwnavigation">
		<template name="title" title="welcome" file="welcomelabel.cfm"/>
		<template name="mainContent" title="Announcements" file="welcomecontent.cfm"/>
	</action>

	<action name="Choose Site" template="onecolumnnonav">
		<template name="mainContent" title="Choose Site" file="choosesitelist.cfm"/>
	</action>

	<action name="checkLogin"/>

	<action name="dumpUser"/>

	<action name="Add Announcement" onMenu="1" isSecurityItem="1" isform="1" template="onecolumnwnavigation" formsubmit="saveAnnouncement">
		<template name="title" title="label" file="titlelabel.cfm"/>
		<template name="title" title="buttons" file="titlebuttons.cfm"/>
		<template name="mainContent" title="Properties" file="properties.cfm"/>
	</action>

	<action name="Save Announcement"/>

	<action name="Edit Announcement" isform="1" template="onecolumnwnavigation" formsubmit="saveAnnouncement">
		<template name="title" title="label" file="titlelabel.cfm"/>
		<template name="title" title="buttons" file="titlebuttons.cfm"/>
		<template name="mainContent" title="Properties" file="properties.cfm"/>
	</action>

	<action name="Update Password"/>

	<action name="Change Password" onMenu="1" isSecurityItem="1" isform="1" template="onecolumnwnavigation" formsubmit="UpdatePassword">
		<template name="title" title="label" file="passwordtitlelabel.cfm"/>
		<template name="title" title="buttons" file="passwordtitlebuttons.cfm"/>
		<template name="mainContent" title="Properties" file="passwordproperties.cfm"/>
	</action>

	<action name="Delete Announcement" isSecurityItem="1"/>

</module>
</cfsavecontent>

<cfset modulexml = xmlparse(modulexml)>



