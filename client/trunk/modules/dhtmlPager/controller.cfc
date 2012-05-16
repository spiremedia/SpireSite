<cfcomponent name="dhtmlPager" extends="resources.abstractController">
	<cffunction name="accordion">
		<cfset variables.pageRef.addToHeader('<script type="text/javascript" src="/ui/js/jquery.accordion.min.1.7.1.js"></script>')>
		<cfreturn this>
	</cffunction>
	<cffunction name="tabs">
		<cfset variables.pageRef.addToHeader('<script type="text/javascript" src="/ui/js/jquery.tabs.min.1.7.1.js"></script>')>
		<cfreturn this>
	</cffunction>
	<cffunction name="showHTML">
		<cfparam name="variables.data.items" type="array" default="#arrayNew(1)#">
		<cfreturn parseforlanguage(super.showHTML(argumentCollection = arguments))>
	</cffunction>
</cfcomponent>