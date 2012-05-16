<cfset lcl.info = getDataItem('info')>
<cfset lcl.form = createWidget("formcreator").init()>

<cfset lcl.form.startForm()>
<cfset lcl.form.addformitem('name', 'Video Group Name', true, 'text', lcl.info.getname())>
<cfset lcl.form.endForm()>

<cfoutput>#lcl.form.showHTML()#</cfoutput>