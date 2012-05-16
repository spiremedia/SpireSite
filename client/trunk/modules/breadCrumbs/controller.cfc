<cfcomponent name="breadcrumbs" extends="resources.abstractController">
	
	<cffunction name="init">
		<cfargument name="requestObject">
		<cfargument name="parameterList">
		<cfargument name="pageref">
		<cfargument name="possibleModules">
		<cfargument name="data">
		<cfset structappend(variables, arguments)>
		<cfset variables.links = pageref.getbreadcrumbs()>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="showHTML">
		<cfset var a = arraynew(1)>
		<cfset var i = "">
		<cfset var linksa = listtoarray(variables.links,"|")>
		
		<cfset arrayappend(a,"<!-- nosearch -->")>
		<cfset arrayappend(a,"<ul>")>
		<cfloop from = "1" to="#arraylen(linksa)#" index="i">
			<cfif i EQ arraylen(linksa)>
				<cfset arrayappend(a,"<li>" & gettoken(linksa[i],1,"~") & "</li>")>
			<cfelse>
				<cfset arrayappend(a,'<li><a href="#gettoken(linksa[i],3,"~")#">#gettoken(linksa[i],1,"~")#</a>&nbsp;&nbsp;<span class="bcsep">&raquo;</span>&nbsp;</li>')>
			</cfif>
		</cfloop>
		<cfset arrayappend(a,"</ul>")>
		<cfset arrayappend(a,"<!-- nosearch -->")>
		<cfreturn arraytolist(a,"")>
	</cffunction>
	
	<cffunction name="addLink">
		<cfargument name="link">
		<cfargument name="label">
		<cfargument name="id">
		<cfset variables.links = variables.links & '|' & label & '~' & id & '~' & link>
	</cffunction>
</cfcomponent>