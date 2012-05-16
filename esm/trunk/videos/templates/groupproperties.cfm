<cfset lcl.info = getDataItem('Info')>
<cfset lcl.videos = getDataItem('videolist')>
<cfset lcl.form = createWidget("formcreator")>


<cfset lcl.form.startform()>

<cfset lcl.options = structnew()>
<cfset lcl.options.style = "width:300px;">
<cfset lcl.form.addformitem('Title', 'Title', true, 'text', lcl.info.getTitle(), lcl.options)>

<cfset lcl.options = structnew()>
<cfset lcl.options.style = "width:300px;">
<cfset lcl.form.addformitem('Description', 'Description', true, 'textarea', lcl.info.getdescription(),lcl.options)>

<cfset lcl.options = structnew()>
<cfset lcl.options.options = lcl.videos>
<cfset lcl.options.valueskey = 'id'>
<cfset lcl.options.labelskey = 'name'>
<cfset lcl.options.orderable = 1>
<cfset lcl.form.addformitem('videoids', 'Associated Videos', false, 'listmanager',lcl.info.getvideoids(),lcl.options)>


<cfset lcl.form.endform()>
<cfoutput>#lcl.form.showHTML()#</cfoutput>

<script>
	function switchtoedit(id){
		var i = document.getElementById('deleteBtn');
		if (i) i.style.display="inline";
		document.myForm.id.value = id;	
	}
</script>
