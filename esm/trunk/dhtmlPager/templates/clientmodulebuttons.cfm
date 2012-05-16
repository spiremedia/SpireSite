<cfset lcl.info = getDataItem('editablemodel')>
<cfoutput>

<input type="submit" value="Save">
<cfif requestObj.getFormUrlVar("view","default") EQ "default">
<input type="button" value="Delete" 
		onClick="verify('Are you sure you wish to delete this item?','../DeleteClientModule/?id=#lcl.info.getid()#');">
</cfif>
<input type="button" onclick="self.close()" value="Cancel">
</cfoutput>