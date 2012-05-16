<cfset lcl.mdl = getDataItem("modulesmdl")>

<cfset lcl.name = requestObj.getFormUrlVar("n")>

<cfset lcl.form = createWidget("formcreator")>
<cfset lcl.form.startForm()>
<cfset lcl.options = structnew()>
<cfset lcl.options.options = lcl.mdl.getTemplatePatterns()>
<cfset lcl.options.valueskey = 'filename'>
<cfset lcl.options.labelskey = 'filename'>
<cfset lcl.form.addformitem('templatepattern', 'Pattern', true, 'select', "",lcl.options)>

<cfset lcl.form.addformitem('n', '', true, 'hidden', lcl.name)>

<cfset lcl.form.addformitem('templatename', 'Name of template<br>(alphanumeric)', true, 'text', "")>

<cfset lcl.form.endForm()>
<cfoutput>#lcl.form.showHTML()#</cfoutput>
<input type="submit" value="go">