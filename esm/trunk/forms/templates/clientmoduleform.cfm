<cfset lcl.formsModel = getDataItem('formsModel')>
<cfset lcl.editablemodel = getDataItem('editablemodel')>

<cfset lcl.form = createWidget("formcreator")>

<cfset lcl.options = structnew()>

<cfset lcl.form.startform()>

<cfset lcl.options = structnew()>
<cfset lcl.options.options = lcl.formsmodel.getForms()>

<cfset lcl.form.addformitem('title', 'Title', true, 'text', lcl.editablemodel.getTitle())>

<cfset lcl.options.labelskey = 'name'>
<cfset lcl.options.valueskey = 'id'>
<cfset lcl.options.addblank = 1>
<cfset lcl.options.blanktext = "">
<cfset lcl.form.addformitem('formid', 'Choose a form', true, 'select', lcl.editablemodel.getformid(), lcl.options)>
<cfset lcl.form.addformitem('id', '', false, 'hidden', lcl.editablemodel.getid())>
<cfset lcl.form.endform()>
<cfoutput>#lcl.form.showHTML()#</cfoutput>
<input type="button" onclick="self.close()" value="Cancel">
<input type="submit" value="Save">

<script>
	window.resizeTo(870, 288);
</script>
