<cfset lcl.info = getDataItem('info')>
<cfset lcl.form = createWidget("formcreator").init()>

<cfset lcl.form.startForm()>
<cfset lcl.form.addformitem('name', 'Video Name', true, 'text', lcl.info.getfield('name'))>
<cfset lcl.form.endForm()>

<cfoutput>#lcl.form.showHTML()#</cfoutput>