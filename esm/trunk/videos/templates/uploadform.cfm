<cfset lcl.form = createWidget("formcreator")>
<cfset lcl.form.startform()>
<!--- <cfset lcl.form.addformitem('videoid', 'videoid', false, 'hidden', requestObj.getFormUrlVar("id"))> --->
<cfset lcl.form.addformitem('thmbfilename', 'Image to Upload', false, 'file', "")>
<cfset lcl.form.addformitem('videofilename', 'Video to Upload', false, 'file', "")>

<cfset lcl.form.endform()>
<cfoutput>#lcl.form.showHTML()#</cfoutput>
