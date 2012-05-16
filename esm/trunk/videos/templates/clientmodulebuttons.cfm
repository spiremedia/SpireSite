<cfset lcl.info = getDataItem('editmodel')>
<cfoutput>
<cfif requestObj.getFormUrlVar("view","default") EQ "default">
<input type="button" value="Delete" 
		onClick="verify('Are you sure you wish to delete this item?','../deleteClientModule/?id=#lcl.info.getid()#');">
</cfif>
</cfoutput>