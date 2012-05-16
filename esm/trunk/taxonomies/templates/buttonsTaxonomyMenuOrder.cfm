<cfif (NOT requestObj.isFormUrlVarSet('id') AND securityObj.isallowed('taxonomies', 'Add Taxonomy Menu')) OR 
		(requestObj.isFormUrlVarSet('id') AND securityObj.isallowed('taxonomies', 'Edit Taxonomy Menu'))>
	<input type="submit" value="Save">
</cfif>	
