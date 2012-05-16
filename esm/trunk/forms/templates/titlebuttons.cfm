<cfset lcl.info = getDataItem('info')>
<cfset lcl.userobj = getDataItem('userobj')>
<cfset lcl.form = createWidget("formcreator")>
<cfset lcl.str = ''>
	

<cfif (NOT requestObj.isFormUrlVarSet('id') AND securityObj.isallowed("forms","add Form")) 
	OR (requestObj.isFormUrlVarSet('id') AND securityOBj.isallowed("forms","edit Form"))>
		<cfset lcl.str = lcl.str & '<input type="submit" value="Save">'>
</cfif>

<cfif requestObj.isFormUrlVarSet('id') AND lcl.userobj.isallowed("forms","Delete Form")>
	<cfset lcl.str = lcl.str & ' <input type="button" value="Delete" onClick="verify(''Are you sure you wish to delete this Form?'',''../DeleteForm/?id=#lcl.info.id#'')">'>
</cfif>	
    

<cfset lcl.form.startform()>
<cfset lcl.form.addcustomformitem(lcl.str)>
<cfset lcl.form.addformitem('id', 'id', true, 'hidden', lcl.info.id)>
<cfset lcl.form.endform()>

<cfoutput>#lcl.form.showHTML()#</cfoutput>