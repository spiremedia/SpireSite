<cfset lcl.item = getDataItem('item')>
<cfset lcl.form = createWidget("formcreator")>
<cfset lcl.str = "">
<cfset lcl.id = lcl.item.getId()>

<cfif (NOT requestObj.isFormUrlVarSet('id') AND securityObj.isallowed("permissionlevel","Add Permission Level")) 
	OR (requestObj.isFormUrlVarSet('id') AND securityOBj.isallowed("permissionlevel","Edit Permission Level"))>
	<cfset lcl.str = '<input type="submit" value="Save">'>
</cfif>

<cfif securityObj.isallowed("permissionlevel","Delete Permission Level")>
	<cfset lcl.str = lcl.str & ' <input type="button" id="deleteBtn" #iif(lcl.id EQ "",DE('style="display:none;'),DE(''))#" value="Delete" onClick="verify(''Are you sure you wish to delete this group?'',''/permissionLevel/DeletePermissionLevel/?id='' + document.myForm.id.value)">'>
</cfif>

<cfset lcl.form.startform()>
<cfset lcl.form.addcustomformitem(lcl.str)>
<cfset lcl.form.addformitem('id', 'id', true, 'hidden', lcl.id)>
<cfset lcl.form.endform()>

<cfoutput>#lcl.form.showHTML()#</cfoutput>