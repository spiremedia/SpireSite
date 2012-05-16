<cfset lcl.editmodel = getDataItem('editmodel')>

<cfset lcl.form = createWidget("formcreator")>

<cfset lcl.options = structnew()>

<cfset lcl.form.startform()>

<cfset lcl.options.style = "width:300px;">
<cfset lcl.form.addformitem('feedurl', 'Feed Url', false, 'text', lcl.editmodel.getfeedurl(), lcl.options)>

<cfset lcl.options = structnew()>
<cfset lcl.options.options = "Show Title,Show Description">
<cfset lcl.form.addformitem('DESCRIPTIONOPTIONS', 'Description Options', false, 'checkbox', lcl.editmodel.getdescriptionoptions(), lcl.options)>

<cfset lcl.options = structnew()>
<cfset lcl.options.options = "All,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20">
<cfset lcl.form.addformitem('rowcount', 'Show Records', false, 'select', lcl.editmodel.getrowcount(), lcl.options)>

<cfset lcl.options = structnew()>
<cfset lcl.options = structnew()>
<cfset lcl.options.options = "None,All,40,75,130,200,300,400">
<cfset lcl.form.addformitem('rowmaxlen', 'Record Max Length', false, 'select', lcl.editmodel.getrowmaxlen(), lcl.options)>

<!--- this is for block admin.  --->
<cfif requestObj.getFormUrlVar("view", "default") EQ "block">
	<cfset lcl.form.addformitem('view', '', false, 'hidden', "block")>
</cfif>

<cfset lcl.form.addformitem('id', '', false, 'hidden', lcl.editmodel.getid())>

<cfset lcl.form.endform()>
<cfoutput>#lcl.form.showHTML()#</cfoutput>
<input type="button" onclick="self.close()" value="Cancel">
<input type="button" onclick="showfeed()" value="View">
<input type="submit" value="Save">

<div id="feedResult" style="height:200px;border:1px solid gray;width:700px;overflow:auto;margin:10px;">
</div>

<script>
	function showfeed(){
		var myForm = $('#myForm').serialize();
		$("#feedResult").load('/feedreader/testFeed/', myForm )
	}

	window.resizeTo(880, 580);
</script>
