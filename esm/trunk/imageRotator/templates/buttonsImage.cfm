<cfset lcl.HomeImage = getDataItem('Image')>

<cfif (NOT requestObj.isFormUrlVarSet('id') AND securityObj.isallowed('imagerotator', 'Add Image')) OR
		(requestObj.isFormUrlVarSet('id') AND securityObj.isallowed('imagerotator', 'Edit Image'))>
	<input type="submit" value="Save">
</cfif>
<cfoutput>
<cfif securityObj.isallowed('imagerotator', 'delete Image') AND requestObj.getFormUrlVar("view","default") EQ "default">
    <input type="button" id="deleteBtn" #iif(NOT requestObj.isFormUrlVarSet('id'),DE('style="display:none;'),DE(''))#" value="Delete" onClick="verify('Are you sure you wish to delete this item?','/imageRotator/deleteImage/?id=' + document.myForm.id.value)">
</cfif>

<cfif securityObj.isallowed('imagerotator', 'Edit Image')>
<input type="button" id="uploadBtn" #iif(NOT requestObj.isFormUrlVarSet('id'),DE('style="display:none;"'),DE(''))# value="Upload Image" onClick="location.href='../uploadImage/?id=' + document.myForm.id.value">
</cfif>
</cfoutput>

