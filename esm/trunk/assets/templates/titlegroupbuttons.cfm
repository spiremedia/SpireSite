<cfset lcl.info = getDataItem('info')>
<cfset lcl.userobj = getDataItem('userobj')>
<cfset lcl.form = createWidget("formcreator")>

<cfset lcl.str = "<input type=""hidden"" name=""id"" value=""#lcl.info.getId()#"">">

<cfif (NOT requestObj.isFormUrlVarSet('id') AND securityObj.isallowed("assets","Add Asset Group")) 
	OR (requestObj.isFormUrlVarSet('id') AND securityOBj.isallowed("assets","Edit Asset Group"))>
<!--- <cfif securityObj.isallowed("assets","Add Asset Group") OR securityOBj.isallowed("assets","Edit Asset Group")> --->
	<cfset lcl.str = lcl.str & '<input type="submit" value="Save">'>
</cfif>
	
<cfif securityObj.isallowed("assets","delete Asset Group")>
	<cfset lcl.str = lcl.str & ' <input type="button" id="deleteBtn" #iif(lcl.info.getId() EQ "",DE('style="display:none;'),DE(''))#" value="Delete" onClick="verify(''Are you sure you wish to delete this group?'',''../deleteAssetGroup/?id='' + document.myForm.id.value)">'>
</cfif>

<cfoutput>#lcl.str#</cfoutput>