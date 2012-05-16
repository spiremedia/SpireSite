<cfset lcl.info = getDataItem('info')>
<cfset lcl.str = "">

<cfoutput>
<cfif (NOT requestObj.isFormUrlVarSet('id') AND securityObj.isallowed("assets","add asset")) 
	OR (requestObj.isFormUrlVarSet('id') AND securityOBj.isallowed("assets","edit asset"))>
	<!--- <cfif securityObj.isallowed("assets","add asset") OR securityObj.isallowed("assets","Edit asset")> --->
		<input type="submit" value="Save">
	</cfif>
		
	<cfif securityObj.isallowed("assets","delete asset")>
		<input type="button" id="deleteBtn" #iif(lcl.info.getId() EQ "",DE('style="display:none;'),DE(''))#" value="Delete" onClick="verify('Are you sure you wish to delete this Asset?','../DeleteAsset/?id=' + document.myForm.id.value)">
	</cfif>

	<cfif securityObj.isallowed("assets","Edit asset")>
		<input type="button" id="uploadBtn" #iif(lcl.info.getId() EQ "",DE('style="display:none;'),DE(''))#" value="Upload Asset File" onClick="location.href='/assets/uploadAsset/?id=' + document.myForm.id.value">
	</cfif>
</cfoutput>