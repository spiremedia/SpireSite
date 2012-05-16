<cfset lcl.taxonomyinfo = getDataItem('taxonomyiteminfo')>

<cfset lcl.form = createWidget("formcreator")>
<cfset lcl.options = structnew()>
<cfset lcl.options.options = getDataItem('taxonomylist')>
<cfset lcl.options.valueskey = "id">
<cfset lcl.options.labelskey = "name">
<cfset lcl.options.orderable = 1>
<cfset lcl.form.startform()>

<cfset lcl.form.addformitem('id', '', true, 'hidden', requestObj.getFormUrlVar("id"))>

<cfset lcl.s = structnew()>
<cfset lcl.favlist = "">
<cfoutput query="lcl.taxonomyinfo" group="tmiid">
	<cfset lcl.favlist = listappend(lcl.favlist, lcl.taxonomyinfo.tmitaxonomyid)>
</cfoutput>
	
<cfset lcl.form.addformitem('menuorder', 'Menu Order', true, 'listmanager', lcl.favlist, lcl.options )>

<cfset lcl.form.endform()>

<cfoutput>#lcl.form.showHTML()#</cfoutput>
