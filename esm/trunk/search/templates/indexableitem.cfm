<cfset lcl.item = variables.getDataItem('item')>
<cfoutput>
<cfloop list="#lcl.item.columnlist#" index="lcl.itm">
	<p><b>#lcl.itm# :</b>
	<cfif right(lcl.itm, 3) EQ "xml">
		<cfif isxml(lcl.item[lcl.itm][1])>
			<cfdump var=#xmlparse(lcl.item[lcl.itm][1])#>
		<cfelse>
			#xmlformat(lcl.item[lcl.itm][1])#
		</cfif>
	<cfelseif right(lcl.itm, 3) EQ "json" AND left(lcl.item[lcl.itm][1],1) EQ '{'>
		<cfdump var=#deserializejson(lcl.item[lcl.itm][1])#>
	<cfelse>
		#lcl.item[lcl.itm][1]#
	</cfif>
	</p>
</cfloop>
</cfoutput>
