<cfset lcl.mdl = getDataItem('mdl')>
<cfoutput>
<input type="button" value="Delete" 
		onClick="verify('Are you sure you wish to delete this item?','../deleteClientModule/?id=#lcl.mdl.getid()#');">
</cfoutput>