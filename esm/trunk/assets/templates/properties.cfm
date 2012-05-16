<cfset lcl.info = getDataItem('Info')>
<cfset lcl.form = createWidget("formcreator")>
<cfset lcl.assetList = getDataItem('grouptypes')> 

<cfset lcl.form.startform()>
<cfset lcl.form.addformitem('id', 'id', true, 'hidden', lcl.info.getId())>

<cfset lcl.options = structnew()>
<cfset lcl.options.options = lcl.assetList>
<cfset lcl.options.valueskey = 'id'>
<cfset lcl.options.labelskey = 'name'>
<cfset lcl.config.addblank = 1>
<cfset lcl.form.addformitem('assetgroupid', 'Asset Group', true, 'select', lcl.info.getAssetgroupid(),lcl.options)>

<cfset lcl.form.addformitem('startdate', 'Show Date', false, 'date', lcl.info.getStartdate())>
<cfset lcl.form.addformitem('enddate', 'Hide Date', false, 'date', lcl.info.getEnddate())>

<cfset lcl.options = structnew()>
<cfset lcl.options.style= 'width:300px;height:50px;'>
<cfset lcl.form.addformitem('description', 'Search Results<br>List Description', false, 'textarea', lcl.info.getDescription(), lcl.options)>

<cfset lcl.form.endform()>
<cfoutput>#lcl.form.showHTML()#</cfoutput>

<script>

	function switchtoedit(id){
		try{
			document.getElementById('deleteBtn').style.display="inline";
			document.getElementById('uploadBtn').style.display="inline";
		} catch(e){}
		document.myForm.id.value = id;	
	}
</script>








