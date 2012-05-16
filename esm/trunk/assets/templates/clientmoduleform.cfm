<cfset lcl.assetsmodel = getDataItem('assetsmodel')>
<cfset lcl.groupTypes = getDataItem('groupTypes')>
<cfset lcl.editablesmodel = getDataItem('editablesmodel')>

<cfset lcl.form = createWidget("formcreator")>

<cfset lcl.options = structnew()>

<cfset lcl.form.startform()>

<cfset lcl.options = structnew()>
<cfset lcl.options.style = "width:400px">
<cfset lcl.form.addformitem('title', 'Title', false, 'text', lcl.editablesmodel.getTitle(), lcl.options)>

<cfset lcl.options = structnew()>
<cfset lcl.options.options = lcl.groupTypes>
<!--- <cfset lcl.options.options = lcl.assetsmodel.getGroupTypes()> --->
<cfset lcl.options.labelskey = 'name'>
<cfset lcl.options.valueskey = 'id'>
<cfset lcl.options.addblank = 1>
<cfset lcl.options.blanktext = "Choose a Group">
<cfset lcl.form.addformitem('assetgroupid', 'Choose an Asset Group', false, 'select', lcl.editablesmodel.getassetgroupid(), lcl.options)>

<cfset lcl.options = structnew()>
<cfset lcl.options.options = lcl.assetsmodel.getClientModuleAssets()>

<cfset lcl.options.labelskey = 'name'>
<cfset lcl.options.valueskey = 'id'>
<cfset lcl.options.groupkey = 'assetgroupid'>
<cfset lcl.options.groupvaluekey = 'assetgroupname'>
<cfset lcl.options.addblank = 1>
<cfset lcl.options.blanktext = "Choose an Asset">
<cfset lcl.form.addformitem('assetids', 'Or individual assets', false, 'listmanager', lcl.editablesmodel.getassetids(), lcl.options)>

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
