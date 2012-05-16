<cfset lcl.info = getDataItem('info')>


<cfset lcl.form = createWidget("formcreator")>

<cfset lcl.form.startform()>
<cfset lcl.assetoptions = structnew()>
<cfset lcl.assetoptions.options = getDataItem('assets') >
<cfset lcl.assetoptions.valueskey = 'id'>
<cfset lcl.assetoptions.labelskey = 'name'>
<cfset lcl.assetoptions.addBlank = 1>
<cfset lcl.assetoptions.BlankText = 'Choose an Asset for the mp3'>


<cfset lcl.form.addformitem('assetid', 'MP3', false, 'select', lcl.info.getAssetid(), lcl.assetoptions )>
<cfset lcl.form.endform()>
<cfoutput>#lcl.form.showHTML()#</cfoutput>
