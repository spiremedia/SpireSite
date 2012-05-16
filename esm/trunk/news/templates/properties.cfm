<cfset lcl.info = getDataItem('Info')>
<cfset lcl.form = createWidget("formcreator")>

<cfset lcl.options = structnew()>

<cfset lcl.form.startform()>

<cfset lcl.options = structnew()>
<cfset lcl.options.style="width:400px;">
<cfset lcl.form.addformitem('title', 'Rss and List Item Title', true, 'text', lcl.info.getTitle(),lcl.options)>

<cfset lcl.options = structnew()>
<cfset lcl.options.style="width:400px;height:40px;">
<cfset lcl.form.addformitem('description', 'Search and RSS Description', false, 'tiny-mce', lcl.info.getDescription(), lcl.options)>

<cfset lcl.options = structnew()>
<cfset lcl.options.options = getDataItem('newstypes')>
<cfset lcl.options.valueskey = 'id'>
<cfset lcl.options.labelskey = 'name'>

<cfset lcl.form.addformitem('newstypeids', 'News Type', false, 'listmanager',  lcl.info.getNewsTypeIds(), lcl.options)>
<cfset lcl.form.addformitem('itemdate', 'Item Date', true, 'date', lcl.info.getItemDate())>
<cfset lcl.form.addformitem('startdate', 'Show Date', false, 'date', lcl.info.getStartDate())>
<cfset lcl.form.addformitem('enddate', 'Hide Date', false, 'date', lcl.info.getEndDate())>

<cfset lcl.options = structnew()>
<cfset lcl.options.options = querynew('label,value')>
<cfset queryaddrow(lcl.options.options)>
<cfset querysetcell(lcl.options.options,'label','')>
<cfset querysetcell(lcl.options.options,'value','1')>

<!---<cfset lcl.form.addformitem('onhomepage', 'On Home Page?', false, 'checkbox',  lcl.info.getfield('onhomepage'), lcl.options)>--->

<cfset lcl.form.endform()>
<cfoutput>#lcl.form.showHTML()#</cfoutput>