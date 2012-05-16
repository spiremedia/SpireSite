<cfsilent>

	<cfset lcl.acc = createWidget('accordion')>
	<cfset lcl.acc.setID('browselist')>
	<cfset lcl.list = getDataItem('list')>
	
	<cfif isdataItemSet('id')>
		<cfset lcl.id = getDataItem('id')>
	<cfelse>
		<cfset lcl.id = 0>
	</cfif>

	<cfset lcl.count = 0>

	<cfset lcl.s = structnew()>
	<cfif lcl.list.recordcount>
		<cfoutput query="lcl.list" group="newstypename">
			<cfset lcl.count = lcl.count + 1>
			<cfsavecontent variable="lcl.s.html">
				<div class="nav">
				<ul>
				<cfoutput>
					<li><a <cfif lcl.id EQ lcl.list.id[lcl.list.currentrow]>class="selected" <cfset lcl.acc.setselected(lcl.count)></cfif> href="../editNews/?id=#id#">#name#<cfif onhomepage> (hp)</cfif></a></li>
				</cfoutput>
				</ul>
				</div>
			</cfsavecontent>
			<cfset lcl.acc.add(newstypename,lcl.s.html)>
		</cfoutput>
	<cfelse>
		
		<cfset lcl.acc.add('No News Loaded',"")>
	</cfif>
</cfsilent>

<cfoutput>#lcl.acc.showHTML()#</cfoutput>