<cfcomponent name="Videos" extends="resources.abstractController">
	<cffunction name="default">
		<cfparam name="variables.data.groupid" default="0">
		<cfset variables.videolist = this.getVideosModel("videos").getGroupVideos(variables.data.groupid)>
		<cfset variables.pageRef.addToHeader('<link rel="stylesheet" href="/ui/css/videos.css" type="text/css" />')>
		<cfset variables.pageRef.addToHeader('<script type="text/javascript" src="/ui/js/jquery.videos.js"></script>')>
		<cfset variables.pageRef.addToHeader('<script type="text/javascript" src="/ui/js/swfobject.js"></script>')>
		<cfreturn this>
	</cffunction>
</cfcomponent>