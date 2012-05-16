<cfset lcl.settings = getDataItem('settings')>
<cfset lcl.form = createWidget("formcreator")>

<p>Add one tuplet per line. </p>
<cfset lcl.form.startform()>
<cfset lcl.config = structnew()>
<cfset lcl.config.style="width:400px;height:300px;">
<cfset lcl.form.addformitem('settings', 'Settings', true, 'textarea', lcl.settings, lcl.config)>
<cfset lcl.form.endform()>

<cfoutput>#lcl.form.showHTML()#</cfoutput>