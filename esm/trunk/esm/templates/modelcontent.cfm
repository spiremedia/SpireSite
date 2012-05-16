<cfset lcl.mdl = getDataItem("modulemdl")>
<cfset lcl.tables = getDataItem("tables")>
<cfset lcl.name = requestObj.getFormUrlVar("n")>

<cfset lcl.form = createWidget("formcreator")>
<cfset lcl.form.startForm()>
<cfset lcl.options = structnew()>
<cfset lcl.options.options = lcl.tables>
<cfset lcl.options.valueskey = 'table_name'>
<cfset lcl.options.labelskey = 'table_name'>
<cfset lcl.options.addblank = 1>
<cfset lcl.options.blanktext = "No database table">
<cfset lcl.form.addformitem('tablename', 'Choose a table', true, 'select', "",lcl.options)>

<cfset lcl.form.addformitem('n', '', true, 'hidden', lcl.name)>

<cfset lcl.form.addformitem('altName', 'Or designate a name', true, 'text', "")>

<cfset lcl.activestuff = structnew()>
<cfset lcl.activestuff.options = querynew('value,label')>
<cfset queryaddrow(lcl.activestuff.options)>
<cfset querysetcell(lcl.activestuff.options,'value','1')>
<cfset querysetcell(lcl.activestuff.options,'label','Yes')>
<cfset lcl.form.addformitem('addctrlerfactorymethod', 'Add Controler Factory Method?', true, 'checkbox', "1", lcl.activestuff)>
<cfset lcl.form.endForm()>
<cfoutput>#lcl.form.showHTML()#</cfoutput>
<input type="submit" value="go">