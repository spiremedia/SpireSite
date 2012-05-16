<cfset lcl.info = getDataItem('info')>
<cfset lcl.form = createWidget("formcreator")>

<cfoutput>
	<cfif (NOT requestObj.isFormUrlVarSet('id') AND securityObj.isallowed("login","add Announcement")) 
	OR (requestObj.isFormUrlVarSet('id') AND securityOBj.isallowed("login","edit Announcement"))>
		<input type="submit" value="Save">
	</cfif>
	<input type="button" value="Back To List" onClick="location.href='../StartPage/'">	
	<cfif securityObj.isallowed('login','Delete Announcement')>
		<input type="button" id="deleteBtn" #iif(NOT requestObj.isFormUrlVarSet('id'),DE('style="display:none;'),DE(''))#" value="Delete" onClick="verify('Are you sure you wish to delete this Announcement?','../DeleteAnnouncement/?id=' + document.myForm.id.value)">
	</cfif>
	<cfset lcl.form.startform()>
	<cfset lcl.form.addformitem('id', 'id', true, 'hidden', lcl.info.getId())>
	<cfset lcl.form.endform()>
</cfoutput>
<cfoutput>#lcl.form.showHTML()#</cfoutput>
