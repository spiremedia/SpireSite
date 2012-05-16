<cfset lcl.info = getDataItem('Info')>
<cfset lcl.form = createWidget("formcreator")>

<cfset lcl.options = structnew()>

<cfset lcl.form.startform()>

<cfset lcl.options = structnew()>
<cfset lcl.options.style="width:400px;">
<cfset lcl.form.addformitem('name', 'Title', true, 'text', lcl.info.getName(),lcl.options)>

<cfset lcl.form.addformitem('itemdate', 'Display Date?', true, 'date',  lcl.info.getItemdate(), lcl.options)>

<cfset lcl.options = structnew()>
<cfset lcl.options.style="width:500px;height:200px;">
<cfset lcl.form.addformitem('htmlText', 'Announcement', false, 'tiny-mce', lcl.info.gethtmlText(), lcl.options)>

<cfset lcl.activestuff = structnew()>
<cfset lcl.activestuff.options = querynew('value,label')>
<cfset queryaddrow(lcl.activestuff.options)>
<cfset querysetcell(lcl.activestuff.options,'value','1')>
<cfset querysetcell(lcl.activestuff.options,'label','Yes')>
<cfset lcl.form.addformitem('active', 'Active', false, 'checkbox', lcl.info.getactive(), lcl.activestuff)>

<cfset lcl.form.endform()>
<script>
	function switchtoedit(id){
		var i = document.getElementById('deleteBtn');
		if (i) i.style.display="inline";
		document.myForm.id.value = id;	
	}
</script>
<cfoutput>#lcl.form.showHTML()#</cfoutput>






