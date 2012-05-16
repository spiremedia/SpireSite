<cfset lcl.block = getDataItem('block')>

<cfoutput>
<cfif (NOT requestObj.isFormUrlVarSet('id') AND securityObj.isallowed("pages","add Block")) 
	OR (requestObj.isFormUrlVarSet('id') AND securityOBj.isallowed("pages","Edit Block"))>
<!--- <cfif lcl.userobj.isallowed("pages","add Page") OR lcl.userobj.isallowed("pages","Edit Page")> --->
	<input type="submit" value="Save">
</cfif>

<cfif securityobj.isallowed("pages","delete block") AND lcl.block.getid() NEQ "">
	<input type="button" value="Edit" onClick="openWindow({scroll:true,url:'/#lcl.block.getModule()#/editClientModule/?id=#lcl.block.getId()#&view=block'})">
	<input type="button" value="Delete" onClick="verify('Are you sure you wish to delete this Block?','/pages/DeleteBlock/?id=#lcl.block.getid()#')">
</cfif>

<cfif securityobj.isallowed("pages","publish block") AND lcl.block.getId() NEQ "" AND lcl.block.getData() NEQ "">
	<input type="button" value="Publish" onClick="sendPublish()">
</cfif>

<input type='hidden' name='id' id='id' value="#lcl.block.getid()#">

<script>
	function sendPublish(){
		$("##myForm ##publish").val(1);
		submitAjaxForm();
		$("##myForm ##publish").val(0);
	}
</script>

</cfoutput>