<cfset lcl.info = getDataItem('Info')>

<cfset lcl.form = createWidget("formcreator")>

<cfset lcl.options = structnew()>

<cfset lcl.form.startform()>

<cfset lcl.form.addformitem('Description', 'Description', false, 'textarea', lcl.info.getDescription())>

<cfset lcl.form.endform()>
<cfoutput>#lcl.form.showHTML()#</cfoutput>

<script>
	function switchtoedit(id){
		var i = document.getElementById('deleteBtn');
		if (i) i.style.display="inline";
		document.myForm.id.value = id;	
	}
</script>