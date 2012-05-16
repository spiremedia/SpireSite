<cfset lcl.info = getDataItem('info')>
<cfset lcl.form = createWidget("formcreator")>

<cfoutput>
<cfif (NOT requestObj.isFormUrlVarSet('id') AND securityObj.isallowed("news","add news")) 
	OR (requestObj.isFormUrlVarSet('id') AND securityOBj.isallowed("news","edit news"))>
	<input type="submit" value="Save">
</cfif>

	<!--- <cfif securityObj.isallowed("contentGroups","edit news") AND lcl.info.getid() NEQ 0>
		<input type="button" value="Upload File" onClick="openWindow('../uploadFile/?id=#lcl.info.getid()#', 800, 190, 'filename');"> 
		<input type="button" value="Upload File" onClick="openWindow({url:'../uploadFile/?id=#lcl.info.getid()#', name:'filename', width:800, height:190} );">
	</cfif>--->
    
    <cfif securityObj.isallowed("news","delete news")>
		<input type="button" value="Delete" id="deleteBtn" #iif(NOT requestObj.isFormUrlVarSet('id'),DE('style="display:none;"'),DE(''))# onClick="verify('Are you sure you wish to delete this News Item?','../DeleteNews/?id=' + document.myForm.id.value)">
    </cfif>

	<cfset lcl.form.startform()>
	<cfset lcl.form.addformitem('id', 'id', true, 'hidden', lcl.info.getId())>
	<cfset lcl.form.endform()>
</cfoutput>
<cfoutput>#lcl.form.showHTML()#</cfoutput>

<script>
	function switchtoedit(id){
		var i = document.getElementById('deleteBtn');
		if (i) i.style.display="inline";
		document.myForm.id.value = id;	
	}
</script>