<cfset lcl.requestObj = getDataItem('requestObj')>
<cfset lcl.form = createWidget("formcreator")>

<cfset lcl.options = structnew()>

<cfset lcl.form.startform()>
<cfset lcl.form.addformitem('filename', 'File', true,  'file', '')>
<cfset lcl.form.addFormItem('id','', true,'hidden',lcl.requestObj.getformurlvar('id'))>
<cfset lcl.form.endform()>
<cfoutput>#lcl.form.showHTML()#</cfoutput>

