<cfset lcl.images = getDataItem('images')>
<cfset lcl.editablesmodel = getDataItem('editablesmodel')>

<cfset lcl.form = createWidget("formcreator")>

<cfset lcl.options = structnew()>

<cfset lcl.form.startform()>

<cfset lcl.options = structnew()>
<cfset lcl.options.options = lcl.images>

<cfset lcl.options.groupkey = 'assetgroup_id'>
<cfset lcl.options.groupvaluekey = 'assetgroup_name'>
<cfset lcl.options.labelskey = 'name'>
<cfset lcl.options.valueskey = 'id'>
<cfset lcl.options.addblank = 1>
<cfset lcl.options.blanktext = "Choose an Image Asset">

<cfset lcl.form.addformitem('assetid', 'The image to embed', false, 'select', lcl.editablesmodel.getAssetId(), lcl.options)>

<cfset lcl.options = structnew()>
<cfset lcl.options.url = "/pages/urlPathMatch/">
<cfset lcl.form.addformitem('link', 'Redirect (start with /)', false, 'autocomplete', lcl.editablesmodel.getLink(), lcl.options)>

<cfset lcl.form.addformitem('id', '', false, 'hidden', lcl.editablesmodel.getid())>

<!--- this is for block admin.  --->
<cfif requestObj.getFormUrlVar("view", "default") EQ "block">
	<cfset lcl.form.addformitem('view', '', false, 'hidden', "block")>
</cfif>

<cfset lcl.form.endform()>	
<cfoutput>#lcl.form.showHTML()#</cfoutput>
<input type="button" onclick="self.close()" value="Cancel">
<input type="submit" value="Save">

<script>
	window.resizeTo(870, 310);
</script>
