<cfset lcl.info = getDataItem('editablesmodel')>
<cfoutput>
<cfif requestObj.getFormUrlVar("view","default") EQ "default">
<input type="button" value="Delete" 
		onClick="verify('Are you sure you wish to delete this item?','../DeleteClientModule/?id=#lcl.info.getid()#');">
</cfif>
</cfoutput>
