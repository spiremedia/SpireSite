<cfset lcl.name = requestObj.getFormUrlVar("n")>
<cfset lcl.form = createWidget("formcreator")>

<cfset lcl.form.startForm()>

<cfset lcl.form.addformitem('n', '', true, 'hidden', lcl.name)>
<cfset lcl.form.addformitem('testfilename', 'The test file name(no extension)', true, 'text', "")>
<cfset lcl.form.addformitem('listoftestmethods', 'List of Test Methods', true, 'textarea', "")>

<cfset lcl.form.endForm()>

<cfoutput>#lcl.form.showHTML()#</cfoutput>
<input type="submit" value="go">