<cfset lcl.info = getDataItem('info')>
<cfset lcl.form = createWidget("formcreator")>

<cfoutput>
<cfif (requestObj.isFormUrlVarSet('id') AND securityOBj.isallowed("reviews","edit review"))>
	<input type="submit" value="Save">
</cfif>
    
<cfif securityObj.isallowed("reviews","delete review")>
	<input type="button" value="Delete" id="deleteBtn" #iif(NOT requestObj.isFormUrlVarSet('id'),DE('style="display:none;"'),DE(''))# onClick="verify('Are you sure you wish to delete this item?','../DeleteReview/?reviewsmodulename=#getDataItem('reviewsmodulename')#&id=' + document.myForm.id.value + '&itemname=#urlencodedformat(getDataItem("itemname"))#')">
</cfif>

<cfset lcl.form.startform()>
<cfset lcl.form.addformitem('id', 'id', true, 'hidden', lcl.info.getId())>
<cfset lcl.form.addformitem('reviewsmodulename', 'reviewsmodulename', true, 'hidden', getDataItem('reviewsmodulename'))>
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