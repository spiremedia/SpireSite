<cfset lcl.Taxonomy = getDataItem('Taxonomy')>

<cfif (NOT requestObj.isFormUrlVarSet('id') AND securityObj.isallowed('taxonomies', 'Add Taxonomy')) OR 
		(requestObj.isFormUrlVarSet('id') AND securityObj.isallowed('taxonomies', 'Edit Taxonomy'))>
	<input type="submit" value="Save">
</cfif>	
<cfif securityObj.isallowed('taxonomies', 'delete Taxonomy')>
	<cfoutput>
    <input type="button" id="deleteBtn" #iif(NOT requestObj.isFormUrlVarSet('id'),DE('style="display:none;'),DE(''))#" value="Delete" onClick="verify('Are you sure you wish to delete this item?','/taxonomies/deleteTaxonomy/?id=' + document.myForm.id.value)">
    </cfoutput>
</cfif>
<cfif requestObj.isFormUrlVarSet("id") AND securityObj.isallowed('taxonomies', 'Add Taxonomy Item')>
	<cfoutput>
    <input type="button" id="addTaxBtn" value="Add Item" onClick="location.href='../addTaxonomyItem/?taxid=#requestObj.getFormUrlVar('id')#&id='">
    </cfoutput>
</cfif>
