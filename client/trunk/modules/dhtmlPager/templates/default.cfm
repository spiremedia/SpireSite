<cfoutput>
<cfif arraylen(variables.data.items)>
	<ul>
		<cfloop from="1" to="#arraylen(variables.data.items)#" index="lcl.cntr">
			<li>
				<b>#variables.data.items[lcl.cntr].title#</b>
				<div>
					#variables.data.items[lcl.cntr].content#
				</div>
			</li>
		</cfloop>
	</ul>
</cfif>
</cfoutput>