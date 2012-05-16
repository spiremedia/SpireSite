<cfset lcl.Taxonomyinfo = getDataItem('taxonomyiteminfo')>

<cfset lcl.form = createWidget("formcreator")>
<cfset lcl.options = structnew()>
<cfset lcl.options.options = >
<cfset lcl.options.options = getDataItem('taxonomylist')>
<cfset lcl.form.startform()>

<cfset lcl.form.addformitem('id', '', true, 'hidden', lcl.Taxonomyinfo.id )>

<cfset lcl.s = structnew()>

<cfoutput query="lcl.taxonomyinfo" group="tmiid">
	<cfset lcl.favlist = listappend(lcl.favlist, lcl.taxonomyiteminfo.tmfid)>
</cfoutput>
	
<cfset lcl.form.addformitem('menuorder', 'Menu Order', true, 'listmanager', lcl., lcl.options )>

<cfset lcl.form.endform()>

<cfoutput>#lcl.form.showHTML()#</cfoutput>
