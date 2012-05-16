<!--- Apologies for the proceduralness DRE --->
<cfset lcl.nav2 = querynew("hi")>
<cfset lcl.nav3 = querynew("hi")>
<cfset lcl.nav4 = querynew("hi")>
<cfset lcl.selectd = structnew()>
<cfset lcl.path = variables.requestObject.getformurlvar('path')>
<cfset lcl.isSubsite = 0>

<cfset lcl.breadcrumbs = listtoarray(pageref.getField('breadcrumbs'),"|")>
<cfif arraylen(lcl.breadcrumbs) EQ 0>
	<cfreturn "">
</cfif>

<cfif arraylen(lcl.breadcrumbs) EQ 1><!--- home page or recycled nav --->
	<cfset nav3 = pageRef.getChildPages(getToken(lcl.breadcrumbs[1], 2, "~"))>
<cfelse><!--- normal --->
	<cfloop from="2" to="#arraylen(lcl.breadcrumbs)#" index="lcl.itm">
		<cfset "lcl.nav#lcl.itm+1#" = pageRef.getChildPages(getToken(lcl.breadcrumbs[lcl.itm], 2, "~"))>
	</cfloop>
</cfif>

<!--- determine if subsite --->
<cfif isArray(lcl.breadcrumbs) AND arraylen(lcl.breadcrumbs) AND (gettoken(lcl.breadcrumbs[1],1,"~") neq 'Home')>
	<cfset lcl.isSubsite = 1>
</cfif>

<cfoutput>
	<cfset variables.title = gettoken(lcl.breadcrumbs[iif((arraylen(lcl.breadcrumbs) LT 2), '1','2')],1,"~")>

	<!--->
	<h2>
		<a href="#gettoken(lcl.breadcrumbs[iif((arraylen(lcl.breadcrumbs) LT 2), '1','2')],3,"~")#" <cfif left(gettoken(lcl.breadcrumbs[iif((arraylen(lcl.breadcrumbs) LT 2), '1','2')],3,"~"),1) EQ "h">target="_blank"</cfif>>
			#gettoken(lcl.breadcrumbs[iif((arraylen(lcl.breadcrumbs) LT 2), '1','2')],1,"~")#
		</a>
	</h2>
	--->
	<cfif lcl.nav3.recordcount>
	<ul class="subnav">
		<cfloop query="lcl.nav3">
			<li class="navlevel3<cfif refindnocase("^#lcl.nav3.displayurlpath#$", "/" & lcl.path)> itemOn</cfif>">
				<a href="#lcl.nav3.displayurlpath#" <cfif left(lcl.nav3.displayurlpath,1) EQ "h">target="_blank"</cfif>>#lcl.nav3.pagename#</a>
			</li>
			<cfif refindnocase("^#lcl.nav3.displayurlpath#", "/" & lcl.path) AND lcl.nav4.recordcount>
				<cfloop query="lcl.nav4">
					<li class="navlevel4<cfif refindnocase("^#lcl.nav4.displayurlpath#$", "/" & lcl.path)> itemOn</cfif>">
						<a href="#lcl.nav4.displayurlpath#" <cfif left(lcl.nav4.displayurlpath,1) EQ "h">target="_blank"</cfif>>#lcl.nav4.pagename#</a>
					</li>
					<cfif refindnocase("^#lcl.nav4.displayurlpath#", "/" & lcl.path) AND lcl.nav5.recordcount>
						<cfloop query="lcl.nav5">
							<li class="navlevel5<cfif refindnocase("^#lcl.nav5.displayurlpath#", "/" & lcl.path)> itemOn</cfif>">
								<a href="#lcl.nav5.displayurlpath#" <cfif left(lcl.nav5.displayurlpath,1) EQ "h">target="_blank"</cfif>>#lcl.nav5.pagename#</a>
							</li>
						</cfloop>
					</cfif> 
				</cfloop>
			</cfif>
		</cfloop>
	</ul>
	</cfif>
	
</cfoutput>