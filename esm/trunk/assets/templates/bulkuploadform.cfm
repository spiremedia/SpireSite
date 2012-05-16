<cfset lcl.form = createWidget("formcreator")>
<cfset lcl.form.startform()>
<cfset lcl.form.addformitem('assetszipfile', 'Asset to Upload', false, 'file', "")>

<cfset lcl.form.endform()>
<p>See help for information on how to use bulk upload.</p>
<cfoutput>#lcl.form.showHTML()#</cfoutput>