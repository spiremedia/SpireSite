<cfset lcl.block = getDataItem('block')>

<!---<cfset lcl.pages = getDataItem('availablePages')>--->
<cfset lcl.form = createWidget("formcreator")>

<cfset lcl.form.setRequestAndUserObjects(requestObj, securityObj)>

<cfset lcl.form.startform()>

<cfset lcl.config = structnew()>
<cfset lcl.config.options = getDataItem('modulesntspots')>
<cfset lcl.config.addblank = true>
<cfset lcl.config.blanktext = "Choose a template spot / module combination">
<cfset lcl.form.addformitem('name_module', 'Template Spot / Module', true, 'select', lcl.block.getModule() & " : " & lcl.block.getName(), lcl.config)>

<!--->
<cfset lcl.config = structnew()>
<cfloop query="lcl.pages">
	<cfset lcl.pages.urlpath[lcl.pages.currentrow] = "/" & lcl.pages.urlpath[lcl.pages.currentrow]>
</cfloop>
--->
<cfset lcl.config.url = "/pages/urlPathMatch/"><!--- valuelist(lcl.pages.urlpath)> --->
<!--- <cfset lcl.config.valueskey = 'urlpath'>
<cfset lcl.config.labelskey = 'pagename'>
<cfset lcl.config.addblank = true>
<cfset lcl.config.blanktext = "No Relocation"> --->
<cfset lcl.form.addformitem('location', 'Path (start with /)', true, 'autocomplete', lcl.block.getlocation(), lcl.config)>

<cfset lcl.config = structnew()>
<cfset lcl.config.options = "exact,below">
<cfset lcl.form.addformitem('behavior', 'Match Type', true, 'radio', lcl.block.getbehavior(), lcl.config)>

<cfset lcl.activeOptions = structnew()>
<cfset lcl.activeOptions.options = querynew('value,label')>
<cfset queryaddrow(lcl.activeOptions.options)>
<cfset querysetcell(lcl.activeOptions.options,'value','1')>
<cfset querysetcell(lcl.activeOptions.options,'label','')>

<cfset lcl.form.addformitem('active', 'Active', false, 'checkbox', lcl.block.getActive(), lcl.activeOptions)>

<cfset lcl.form.addformitem('sortorder', 'Priority', true, 'text', lcl.block.getSortOrder())>

<cfset lcl.form.addformitem('publish', '', false, 'hidden', 0)>


<cfset lcl.form.endform()>

<cfoutput>
	#lcl.form.showHTML()#
</cfoutput>