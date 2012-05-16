<cfset lcl.TaxonomyItem = getDataItem('TaxonomyItem')>
<cfset lcl.form = createWidget("formcreator").init()>
<cfset lcl.form.startForm()>
<cfset lcl.unextra = structnew()>
<cfset lcl.unextra.style = "width:200px">
<cfset lcl.form.addformitem('name', 'Name', true, 'text', lcl.TaxonomyItem.getName(), lcl.unextra)>
<cfset lcl.form.endForm()>

<cfoutput>#lcl.form.showHTML()#</cfoutput>
