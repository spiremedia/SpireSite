<cfset lcl.info = getDataItem('info')>

<cfset lcl.form = createWidget("formcreator").init()>
<cfset lcl.form.startForm()>
<cfset lcl.unextra = structnew()>
<cfset lcl.form.addformitem('name', 'Event Name', true, 'text', lcl.info.getName(), lcl.unextra)>
<cfset lcl.form.endForm()>

<cfoutput>#lcl.form.showHTML()#</cfoutput>