<cfset lcl.info = getDataItem('info')>
<cfset lcl.form = createWidget("formcreator")>

<cfset lcl.str = "">

<cfif (NOT requestObj.isFormUrlVarSet('id') AND securityObj.isallowed("news","add News Type")) 
	OR (requestObj.isFormUrlVarSet('id') AND securityOBj.isallowed("news","edit News Type"))>
	<cfset lcl.str = '<input type="submit" value="Save">'>
</cfif>

<cfif securityObj.isallowed("news","delete News Type")>
	<cfset lcl.str = lcl.str & ' <input type="button" id="deleteBtn" #iif(lcl.info.getId() EQ "",DE('style="display:none;"'),DE(''))# value="Delete" onClick="verify(''Are you sure you wish to delete this News Type?'',''../deletenewstype/?id='' + document.myForm.id.value)">'>
</cfif>

<cfset lcl.form.startform()>
<cfset lcl.form.addcustomformitem(lcl.str)>
<cfset lcl.form.addformitem('id', 'id', true, 'hidden', lcl.info.getId())>
<cfset lcl.form.endform()>

<cfoutput>#lcl.form.showHTML()#</cfoutput>

<script>
	function switchtoedit(id){
		var i = document.getElementById('deleteBtn');
		if (i) i.style.display="inline";
		document.myForm.id.value = id;	
	}
</script>