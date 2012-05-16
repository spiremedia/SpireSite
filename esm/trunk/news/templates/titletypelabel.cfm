<cfset lcl.info = getDataItem('info')>
<cfset lcl.form = createWidget("formcreator").init()>

<cfset lcl.form.startForm()>
<cfset lcl.form.addformitem('name', 'News Type Name', true, 'text', lcl.info.getName())>
<cfset lcl.form.endForm()>

<cfoutput>#lcl.form.showHTML()#</cfoutput>