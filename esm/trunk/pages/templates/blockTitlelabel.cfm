<cfset lcl.block = getDataItem('block')>
<cfset lcl.form = createWidget("formcreator").init()>


<cfset lcl.form.startForm()>
<cfset lcl.form.addformitem('blockName', 'Name', true, 'text', lcl.block.getBlockName())>
<cfset lcl.form.endForm()>

<cfoutput>#lcl.form.showHTML()#</cfoutput>