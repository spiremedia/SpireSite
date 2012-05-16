<cfset lcl.form = createWidget("formcreator")>
<cfset lcl.form.startform()>
<cfset lcl.form.addformitem('imageid', 'imageid', false, 'hidden', requestObj.getFormUrlVar("id"))>
<cfset lcl.form.addformitem('imagefile', 'Asset to Upload', false, 'file', "")>

<cfset lcl.form.endform()>
<cfoutput>#lcl.form.showHTML()#</cfoutput>
