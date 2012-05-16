<cfset lcl.form = createWidget("formcreator")>
<cfset lcl.form.startform()>
<cfset lcl.form.addformitem('filename', 'Image to Upload', false, 'file', "")>

<cfset lcl.form.endform()>
<cfoutput>#lcl.form.showHTML()#</cfoutput>