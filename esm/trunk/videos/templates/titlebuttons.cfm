<cfset lcl.info = getDataItem('info')>
<cfoutput>

<cfif (NOT requestObj.isFormUrlVarSet('id') AND securityObj.isallowed("videos","Add Video"))
		OR (requestObj.isFormUrlVarSet('id') AND securityObj.isallowed("videos","Edit Video"))>
	<input type="submit" value="Save">
</cfif>
	
<cfif securityObj.isallowed("Videos","Delete Video")>
	<input type="button" id="deleteBtn" #iif(NOT requestObj.isFormUrlVarSet('id'),DE('style="display:none;"'),DE(''))# value="Delete" onClick="verify('Are you sure you wish to delete this video?','/videos/deleteVideo/?id=' + document.myForm.id.value)">
</cfif>

<cfif securityObj.isallowed('Videos', 'Edit Video')>
	<input type="button" id="uploadBtn" #iif(NOT requestObj.isFormUrlVarSet('id'),DE('style="display:none;"'),DE(''))# value="Upload Video and Thumb" onClick="location.href='/videos/uploadVideo/?id=' + document.myForm.id.value">
</cfif>

<!--- <input type="hidden" name="id" value="#lcl.info.getfield('id')#"> --->
</cfoutput>