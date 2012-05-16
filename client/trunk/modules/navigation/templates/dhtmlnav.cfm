<cfset lcl.path = variables.requestObject.getformurlvar('path')>
<cfset lcl.cntrs = 1>
<cfset lcl.tclass = arraynew(1)>

<cfset lcl.breadcrumbs = pageref.getField('breadcrumbs')>
<cfset lcl.breadcrumbs = listtoarray(lcl.breadcrumbs,"|")>
<cfset lcl.topid = "">
<cfif (isArray(lcl.breadcrumbs) AND arraylen(lcl.breadcrumbs))>
	<cfset lcl.topid = gettoken(lcl.breadcrumbs[1],2,"~")>
</cfif>
<cfset lcl.dhtmlnav = pageref.getDHTMLnav(id = lcl.topid)>


<ul id="nav" >
<cfoutput query="lcl.dhtmlnav" group="secondLevelid">
   	<cfset arrayclear(lcl.tclass)>
   	<cfif lcl.dhtmlnav.currentrow EQ 1><cfset arrayappend(lcl.tclass, 'first')></cfif>
       <cfif refindnocase("^#lcl.dhtmlnav.secondurlpath#", lcl.path)><cfset arrayappend(lcl.tclass, 'itemOn')></cfif>
	<li <cfif arraylen(lcl.tclass)>class="#arraytolist(lcl.tclass," ")#"</cfif>><a href="#lcl.dhtmlnav.secondurlpath#">#lcl.dhtmlnav.secondpagename#</a>
	<cfif lcl.dhtmlnav.thirdurlpath NEQ "">
	<cfset lcl.cntrs = 0>
	<cfoutput>
		<cfset lcl.cntrs = lcl.cntrs + 1>
		<cfif lcl.cntrs EQ 1>
			<!---<div>--->
			<ul class="sub">
			<li class="first"><a href="#lcl.dhtmlnav.thirdurlpath#">#lcl.dhtmlnav.thirdpagename#</a></li>
		<cfelse>
			<li><a href="#lcl.dhtmlnav.thirdurlpath#">#lcl.dhtmlnav.thirdpagename#</a></li>
		</cfif>
	</cfoutput>
	<cfif lcl.cntrs>
		</ul>
		<!---</div>--->
	</cfif>
	</cfif>
	</li>
</cfoutput>
</ul>