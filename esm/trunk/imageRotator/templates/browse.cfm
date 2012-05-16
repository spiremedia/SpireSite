<cfsilent>
	<cfset lcl.acc = createWidget('accordion')>
	<cfset lcl.browse = getDataItem('browse')>
	
	<cfif requestObj.isFormUrlVarSet('id')>
		<cfset lcl.id = requestObj.getFormUrlVar('id')>
	<cfelse>
		<cfset lcl.id = 0>
	</cfif>
	
	<cfif lcl.browse.recordcount>
		<cfset lcl.count = 0>
	
		<cfset lcl.s = structnew()>
	
		<cfsavecontent variable="lcl.s.html">
			<div class="nav">
			<ul>
			<cfoutput query="lcl.browse">
				<li><a <cfif lcl.id EQ lcl.browse.id[lcl.browse.currentrow]>class="selected" <cfset lcl.acc.setselected(lcl.count)></cfif> href="../editImage/?id=#id#">#name#</a></li>
			</cfoutput>
			</ul>
			</div>
		</cfsavecontent>
		
		<cfset lcl.acc.add("Title",lcl.s.html)>
		<cfset lcl.acc.setSelected(1)>
	<cfelse>
		<cfif lcl.browse.recordcount EQ 0>
			<cfset lcl.acc.add("No Data Loaded","")>
		</cfif>
	</cfif>
</cfsilent>

<cfoutput>#lcl.acc.showHTML()#</cfoutput>

