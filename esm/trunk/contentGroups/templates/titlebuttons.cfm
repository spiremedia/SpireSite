<cfset lcl.info = getDataItem('info')>
<cfset lcl.form = createWidget("formcreator")>

<cfset lcl.str = "">

<cfif (NOT requestObj.isFormUrlVarSet('id') AND securityObj.isallowed("contentGroups","Add Content Group"))
	OR (requestObj.isFormUrlVarSet('id') AND securityOBj.isallowed("contentGroups","Edit Content Group"))>
	<cfset lcl.str = '<input type="submit" value="Save">'>
</cfif>

<cfif securityObj.isallowed("contentGroups","Delete Content Group")>
	<cfset lcl.id = getdataitem('id')>
	<cfset lcl.str = lcl.str & ' <input type="button" id="deleteBtn" value="Delete" #iif(getdataitem('id') EQ 0,DE('style="display:none;"'),DE(''))# onClick="verify(''Are you sure you wish to delete this group?'',''/contentGroups/deleteContentGroup/?id='' + document.myForm.id.value)">'>
</cfif>

<cfset lcl.form.startform()>
<cfset lcl.form.addcustomformitem(lcl.str)>
<cfset lcl.form.addformitem('id', 'id', true, 'hidden', lcl.info.id)>
<cfset lcl.form.endform()>

<cfoutput>#lcl.form.showHTML()#</cfoutput>