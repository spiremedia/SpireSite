<cfset lcl.info = getDataItem('Info')>
<cfset lcl.form = createWidget("formcreator")>


<cfset lcl.form.startform()>
<cfset lcl.form.addformitem('id', 'id', true, 'hidden', lcl.info.getfield('id'))>

<cfset lcl.options = structnew()>
<cfset lcl.options.style= 'width:300px'>
<cfset lcl.form.addformitem('title', 'Title', true, 'text', lcl.info.getfield('title'), lcl.options)>

<cfset lcl.options = structnew()>
<cfset lcl.options.style= 'width:300px;height:50px;'>
<cfset lcl.form.addformitem('description', 'Description', true, 'textarea', lcl.info.getfield('description'), lcl.options)>

<cfset lcl.form.addformitem('vidlength', 'Length of Vid<br>(ex 3:04)', true, 'text', lcl.info.getfield('vidlength'))>


<!--- <cfset lcl.options = structnew()>
<cfset lcl.options.options = lcl.assetList>
<cfset lcl.options.valueskey = 'id'>
<cfset lcl.options.labelskey = 'name'>
<cfset lcl.config.addblank = 1>
<cfset lcl.form.addformitem('videogroupids', 'Associated Groups', true, 'listmanager',lcl.info.getfield('videogroupids'),lcl.options)>
 --->
<cfset lcl.form.endform()>
<cfoutput>#lcl.form.showHTML()#</cfoutput>

<script>	
	function switchtoedit(id){
		var i = document.getElementById('deleteBtn');
		var j = document.getElementById('uploadBtn');
		if (i) i.style.display="inline";
		if (j) j.style.display="inline";
		document.myForm.id.value = id;	
	}
</script>








