<cfset lcl.securityItems = getDataItem('securityItems')>
<cfset lcl.item = getDataItem('item')>
<cfset lcl.availableUsers = getDataItem('availableUsers')>
<cfset lcl.form = createWidget("formcreator")>

<cfset lcl.options = structnew()>

<cfset lcl.form.startform()>
<cfset lcl.config = structnew()>
<cfset lcl.config.options = lcl.availableusers>
<cfset lcl.config.labelskey = 'fullname'>
<cfset lcl.config.valueskey = 'id'>
<cfset lcl.form.addformitem('userids', 'Add a User to This Permission Level', false, 'listmanager', lcl.item.getUserIds(), lcl.config)>

<cfset lcl.form.endform()>

<cfoutput>#lcl.form.showHTML()#</cfoutput>