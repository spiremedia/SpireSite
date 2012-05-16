<cfset lcl.image = getDataItem('Image')>
<cfset lcl.form = createWidget("formcreator").init()>
<cfset lcl.form.startForm()>
<cfset lcl.unextra = structnew()>
<cfset lcl.unextra.style = "width:200px">
<cfset lcl.form.addformitem('name', 'Name', true, 'text', lcl.Image.getName(), lcl.unextra)>
<cfset lcl.form.endForm()>

<cfoutput>#lcl.form.showHTML()#</cfoutput>
