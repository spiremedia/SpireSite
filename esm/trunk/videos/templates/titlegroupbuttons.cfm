<cfset lcl.info = getDataItem('info')>
<cfset lcl.userobj = getDataItem('userobj')>
<cfset lcl.form = createWidget("formcreator")>

<cfset lcl.str = "">

<cfif (lcl.info.getid() EQ "" AND securityObj.isallowed("videos","add video group"))
	 OR (lcl.info.getid() NEQ "" AND securityOBj.isallowed("videos","edit video Group"))>
	<cfset lcl.str = '<input type="submit" value="Save">'>
</cfif>
	
<cfif securityObj.isallowed("videos", "delete video group")>
	<cfset lcl.str = lcl.str & ' <input type="button" id="deleteBtn" #iif(NOT requestObj.isFormUrlVarSet('id'),DE('style="display:none;'),DE(''))#" value="Delete" onClick="verify(''Are you sure you wish to delete this group?'',''../deleteVideoGroup/?id='' + document.myForm.id.value)">'>
</cfif>

<cfset lcl.form.startform()>
<cfset lcl.form.addcustomformitem(lcl.str)>
<cfset lcl.form.addformitem('id', 'id', true, 'hidden', lcl.info.getid())>
<cfset lcl.form.endform()>

<cfoutput>#lcl.form.showHTML()#</cfoutput>

