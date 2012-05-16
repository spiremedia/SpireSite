<cfset lcl.groupmodel = getDataItem('groupmodel')>
<cfset lcl.widgetModel = getDataItem('editmodel')>
<cfset lcl.widgetInfo = lcl.widgetModel.getInfo()>

<cfset lcl.form = createWidget("formcreator")>

<cfset lcl.options = structnew()>

<cfset lcl.form.startform()>

<cfset lcl.options = structnew()>
<cfset lcl.options.options = lcl.groupmodel.getAll()>
<cfset lcl.options.labelskey = 'name'>
<cfset lcl.options.valueskey = 'id'>
<cfset lcl.options.addblank = 1>
<cfset lcl.options.blanktext = "Choose a Group">
<cfset lcl.form.addformitem('groupid', 'Choose a Group', false, 'select', lcl.widgetinfo.groupid, lcl.options)>

<cfset lcl.form.addformitem('id', '', false, 'hidden', lcl.widgetModel.getid())>

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
