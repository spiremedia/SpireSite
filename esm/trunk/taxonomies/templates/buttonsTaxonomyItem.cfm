<cfoutput>
<cfif (NOT requestObj.isFormUrlVarSet('id') AND securityObj.isallowed('taxonomies', 'Add Taxonomy Item')) OR 
		(requestObj.isFormUrlVarSet('id') AND securityObj.isallowed('taxonomies', 'Edit Taxonomy Item'))>
	<input type="submit" value="Save">
</cfif>	

<cfif securityObj.isallowed('taxonomies', 'delete Taxonomy item')>
	<cfoutput>
    <input type="button" id="deleteBtn" #iif(NOT requestObj.isFormUrlVarSet('id'),DE('style="display:none;'),DE(''))#" value="Delete" onClick="verify('Are you sure you wish to delete this item?','/taxonomies/deleteTaxonomyItem/?taxid=#requestObj.getFormUrlVar("taxid")#&id=' + document.myForm.id.value)">
    </cfoutput>
</cfif>
<input type="button" id="backToList" value="Back to list" onClick="location.href='../startpage'">
<cfif (requestObj.isFormUrlVarSet('taxid') AND securityObj.isallowed('taxonomies', 'Add Taxonomy Item'))>
	<input type="button" id="addMoreBtn" #iif(NOT requestObj.isFormUrlVarSet('id'),DE('style="display:none;"'),DE(''))# onclick="location.href='/taxonomies/addTaxonomyItem/?taxid=#requestObj.getFormUrlVar("taxid")#&id=';" value="Add More?">
</cfif>	
</cfoutput>  
<!---
<cfif securityObj.isallowed('taxonomies', 'delete Taxonomy Item')>
	<cfoutput>
    <input type="button" id="deleteBtn" #iif(NOT requestObj.isFormUrlVarSet('id'),DE('style="display:none;'),DE(''))#" value="Delete" onClick="verify('Are you sure you wish to delete this item?','/taxonomies/deleteTaxonomy/?id=' + document.myForm.id.value)">
    </cfoutput>
</cfif>
--->

