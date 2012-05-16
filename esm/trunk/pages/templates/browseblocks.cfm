<cfsilent>
	<cfset lcl.acc = createWidget('accordion')>
	<cfset lcl.acc.setID('browselist')>
	<cfset lcl.list = getDataItem('list')>
	
	<cfset lcl.id = requestObj.getFormUrlVar('id', 0)>
	
	<cfset lcl.count = 0>

	<cfset lcl.s = structnew()>
	<cfif lcl.list.recordcount>
		<cfoutput query="lcl.list" group="location">
			<cfset lcl.count = lcl.count + 1>
			<cfsavecontent variable="lcl.s.html">
				<div class="nav">
				<ul>
				<cfoutput>
					<li><a <cfif lcl.id EQ lcl.list.id[lcl.list.currentrow]>class="selected" <cfset lcl.acc.setselected(lcl.count)></cfif> href="../editBlock/?id=#id#">#blockname#</a></li>
				</cfoutput>
				</ul>
				</div>
			</cfsavecontent>
			<cfset lcl.acc.add(location,lcl.s.html)>
		</cfoutput>
	<cfelse>
		<cfset lcl.acc.add('No Blocks Loaded',"")>
	</cfif>
</cfsilent>

<cfoutput>#lcl.acc.showHTML()#</cfoutput>