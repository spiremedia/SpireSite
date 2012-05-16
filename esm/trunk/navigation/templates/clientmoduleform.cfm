
<cfset lcl.widgetModel = getDataItem('editableModel')>
<cfset lcl.widgetInfo = lcl.widgetModel.getInfo()>

<cfset lcl.form = createWidget("formcreator")>

<cfset lcl.options = structnew()>

<cfset lcl.form.startform()>

<cfset lcl.options.options = "dhtmlnav,flatnav,subnav">
<cfset lcl.options.addblank = 1>
<cfset lcl.options.blanktext = "Choose a Display mode">

<cfset lcl.form.addformitem('moduleaction', 'Nav View', false, 'select', lcl.widgetInfo.moduleaction, lcl.options)>
<cfset lcl.form.addformitem('id', '', false, 'hidden', lcl.widgetinfo.id)>

<!--- this is for block admin.  --->
<cfif requestObj.getFormUrlVar("view", "default") EQ "block">
	<cfset lcl.form.addformitem('view', '', false, 'hidden', "block")>
</cfif>

<cfset lcl.form.endform()>
<cfoutput>#lcl.form.showHTML()#</cfoutput>
<input type="button" onclick="self.close()" value="Cancel">
<input type="submit" value="Save">

<script>
	window.resizeTo(900, 300);
</script>
