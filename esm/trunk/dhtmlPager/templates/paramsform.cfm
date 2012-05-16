<cfset lcl.editableModel = getDataItem('editableModel')>
<cfset lcl.editableInfo = lcl.editableModel.getInfo()>
<cfset lcl.plist = lcl.editableModel.getParsedParameterList()>
<cfset lcl.form = createWidget("formcreator")>
<cfset lcl.form.startform()>
<cfset lcl.options = structnew()>

<cfset lcl.options.options = querynew("value,label")>
<cfloop from="0" to="10" index="lcl.count">
	<cfset queryaddrow(lcl.options.options)>
	<cfset querysetcell(lcl.options.options, 'value', lcl.count)>
	<cfset querysetcell(lcl.options.options, 'label',lcl.count)>
</cfloop>

<cfset querysetcell(lcl.options.options, 'value', "all")>
<cfset querysetcell(lcl.options.options, 'label',"all")>

<cfset queryaddrow(lcl.options.options)>

<cfset lcl.form.addformitem('startsopen', 'Item Starts Open', false, 'select', lcl.editableInfo.startsopen, lcl.options)>

<cfset lcl.options = structnew()>

<cfif structkeyexists(lcl.plist, 'type')>
	<cfset lcl.options.options = lcl.plist['type']>
<cfelse>
	<cfset lcl.options.options = "Accordion,Tabs">
</cfif>

<cfset lcl.form.addformitem('moduleaction', 'DHTML Type', false, 'select', lcl.editableInfo.moduleaction, lcl.options)>

<!--- this is for block admin.  --->
<cfif requestObj.getFormUrlVar("view", "default") EQ "block">
	<cfset lcl.form.addformitem('view', '', false, 'hidden', "block")>
</cfif>

<cfset lcl.form.endform()>
<cfoutput>#lcl.form.showHTML()#</cfoutput>
