<cfset lcl.eventsModel = getDataItem('eventsModel')>
<cfset lcl.widgetModel = getDataItem('editableModel')>
<cfset lcl.widgetInfo = lcl.widgetModel.getInfo()>

<cfset lcl.form = createWidget("formcreator")>

<cfset lcl.form.startform()>
<cfset lcl.options = structnew()>

<cfsilent>
	<cfset lcl.options.options = querynew("label,value")>
	<cfset queryaddrow(lcl.options.options)>
	<cfset querysetcell(lcl.options.options, "label", "Paged List")>
    <cfset querysetcell(lcl.options.options, "value", "type")>
	
	<cfset queryaddrow(lcl.options.options)>
	<cfset querysetcell(lcl.options.options, "label", "Short List in Box")>
    <cfset querysetcell(lcl.options.options, "value", "shortlist")>
</cfsilent>
<cfset lcl.options.labelskey = 'label'>
<cfset lcl.options.valueskey = 'value'>
<cfset lcl.options.addblank = 1>
<cfset lcl.options.blanktext = "Choose a Display mode">

<cfset lcl.default = lcl.widgetinfo.moduleaction>

<cfset lcl.form.addformitem('moduleaction', 'Display', false, 'select', lcl.default, lcl.options)>
<!--- <cfset lcl.form.addformitem('moduleaction', '', false, 'hidden', "list")> --->

<cfset lcl.options = structnew()>
<cfset lcl.options.style = "width:300px;">
<cfset lcl.form.addformitem('label', 'Label', false, 'text', lcl.widgetinfo.label, lcl.options)>

<cfset lcl.options = structnew()>

<cfset lcl.options.options = querynew("value,label")>
<cfloop from="1" to="41" index="lcl.count">
	<cfset queryaddrow(lcl.options.options)>
	<cfset querysetcell(lcl.options.options, 'value', lcl.count)>
	<cfset querysetcell(lcl.options.options, 'label',lcl.count)>
</cfloop>

<cfset querysetcell(lcl.options.options, 'value', "all")>
<cfset querysetcell(lcl.options.options, 'label',"all")>

<cfset queryaddrow(lcl.options.options)>

<cfset lcl.form.addformitem('pageing', 'Items per Page', false, 'select', lcl.widgetinfo.pageing, lcl.options)>

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
	window.resizeTo(900, 330);
</script>
