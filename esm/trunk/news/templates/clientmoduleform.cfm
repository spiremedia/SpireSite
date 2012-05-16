<cfset lcl.newsTypesModel = getDataItem('newsTypesModel')>
<cfset lcl.widgetModel = getDataItem('editableModel')>
<cfset lcl.widgetInfo = lcl.widgetModel.getInfo()>

<cfset lcl.form = createWidget("formcreator")>

<cfset lcl.options = structnew()>

<cfset lcl.form.startform()>
<cfset lcl.options = structnew()>
<cfset lcl.newstypes = lcl.newsTypesModel.getAll()>

<cfsilent>
<cfset lcl.options.options = querynew("label,value")>
<cfset queryaddrow(lcl.options.options)>
<cfset querysetcell(lcl.options.options, "label", "Available Feeds")>
<cfset querysetcell(lcl.options.options, "value", "AvailableFeeds")>

<cfloop query="lcl.newstypes">
	<cfset queryaddrow(lcl.options.options)>
	<cfset querysetcell(lcl.options.options, "label", "Paged List : #lcl.newstypes.name#")>
    <cfset querysetcell(lcl.options.options, "value", "type|#lcl.newstypes.id#")>
	
	<cfset queryaddrow(lcl.options.options)>
	<cfset querysetcell(lcl.options.options, "label", "Short List in Box : #lcl.newstypes.name#")>
    <cfset querysetcell(lcl.options.options, "value", "shortlist|#lcl.newstypes.id#")>
</cfloop>

</cfsilent>
<cfset lcl.options.labelskey = 'label'>
<cfset lcl.options.valueskey = 'value'>
<cfset lcl.options.addblank = 1>
<cfset lcl.options.blanktext = "Choose a Display mode">

<cfset lcl.default = lcl.widgetinfo.moduleaction>

<cfif lcl.default EQ "type" OR lcl.default EQ "shortlist" >
	<cfset lcl.default = lcl.default & "|" & lcl.widgetinfo.itemid>
</cfif>

<cfset lcl.form.addformitem('moduleaction', 'Display', false, 'select', lcl.default, lcl.options)>

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
