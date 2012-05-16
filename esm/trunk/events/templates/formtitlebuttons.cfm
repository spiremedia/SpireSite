<cfset lcl.info = getDataItem('info')>
<cfset lcl.form = createWidget("formcreator")>

<cfoutput>
<cfif (NOT requestObj.isFormUrlVarSet('id') AND securityObj.isallowed("Events","add Event")) 
	OR (requestObj.isFormUrlVarSet('id') AND securityOBj.isallowed("Events","edit Event"))>
	<input type="submit" value="Save">
</cfif>

<cfif securityObj.isallowed("Events","delete Event")>
	<input type="button" value="Delete" id="deleteBtn" #iif(NOT requestObj.isFormUrlVarSet('id'),DE('style="display:none;"'),DE(''))# onClick="verify('Are you sure you wish to delete this event?','../deleteEvent/?id=' + document.myForm.id.value)">
</cfif>
</cfoutput>

	<!--- <cfset lcl.form.startform()>
	<cfset lcl.form.addformitem('id', 'id', true, 'hidden', lcl.info.getId())>
	<cfset lcl.form.endform()>
<cfoutput>#lcl.form.showHTML()#</cfoutput> --->

