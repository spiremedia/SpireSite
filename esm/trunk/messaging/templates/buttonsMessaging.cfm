<cfset lcl.Messaging = getDataItem('Messaging')>

<cfif (NOT requestObj.isFormUrlVarSet('id') AND securityObj.isallowed('messaging', 'Add Messaging')) OR 
		(requestObj.isFormUrlVarSet('id') AND securityObj.isallowed('messaging', 'Edit Messaging'))>
	<input type="submit" value="Save">
</cfif>	
<cfif securityObj.isallowed('messaging', 'delete Messaging')>
	<cfoutput>
    <input type="button" id="deleteBtn" #iif(NOT requestObj.isFormUrlVarSet('id'),DE('style="display:none;'),DE(''))#" value="Delete" onClick="verify('Are you sure you wish to delete this item?','/messaging/deleteMessaging/?id=' + document.myForm.id.value)">
    </cfoutput>
</cfif>

