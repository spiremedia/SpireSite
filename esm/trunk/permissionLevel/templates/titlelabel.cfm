<cfset lcl.item = getDataItem('item')>
<cfset lcl.form = createWidget("formcreator").init()>

<cfset lcl.form.startForm()>
<cfset lcl.form.addformitem('name', 'Permission Level Name', true, 'text', lcl.item.getName())>
<cfset lcl.form.endForm()>

<cfoutput>#lcl.form.showHTML()#</cfoutput>