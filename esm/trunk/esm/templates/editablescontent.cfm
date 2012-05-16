<cfset lcl.name = requestObj.getFormUrlVar("n")>
<cfset lcl.mdl = getDataItem("moduleMdl")>
<cfset lcl.form = createWidget("formcreator")>

<cfset lcl.form.startForm()>

<cfset lcl.form.addformitem('n', '', true, 'hidden', lcl.name)>

<cfset lcl.form.addformitem('listofsaveables', 'List of Saveable fields', true, 'text', "")>

<cfset lcl.models = lcl.mdl.getModels()>
<cfset lcl.options = structnew()>
<cfset lcl.options.options = valuelist(lcl.models.filename)>

<cfset lcl.form.addformitem('modelstouse', 'Models To use', true, 'listmanager', "", lcl.options)>

<cfset lcl.form.endForm()>

<cfoutput>#lcl.form.showHTML()#</cfoutput>
<input type="submit" value="go">
<p>hint : You may wish to have a variable named view or id.  For instance, assets has assetid and assetids as saveables.	</p>