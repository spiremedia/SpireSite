<cfset lcl.mdl = getDataItem('Mdl')>

<cfset lcl.form = createWidget("formcreator")>

<cfset lcl.options = structnew()>

<cfset lcl.form.startform()>
<cfset lcl.options = structnew()>
<cfset lcl.options.options = "2,3">
<cfset lcl.form.addformitem('layout', 'Columns to Embed', false, 'select', lcl.mdl.getlayout(), lcl.options)>
<cfset lcl.form.addformitem('id', '', false, 'hidden', lcl.mdl.getid())>

<!--- this is for block admin.  --->
<cfif requestObj.getFormUrlVar("view", "default") EQ "block">
	<cfset lcl.form.addformitem('view', '', false, 'hidden', "block")>
</cfif>

<cfset lcl.form.endform()>
<cfoutput>#lcl.form.showHTML()#</cfoutput>
<input type="button" onclick="self.close()" value="Cancel">
<input type="submit" value="Save">


<script>
	window.resizeTo(870, 287);
</script>