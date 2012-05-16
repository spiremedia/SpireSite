<cfset lcl.info = getDataItem('editModel')>

<cfset lcl.form = createWidget("formcreator")>

<cfset lcl.options = structnew()>

<cfset lcl.form.startform()>
<cfset lcl.options = structnew()>
<cfset lcl.options.style = "width:400px;">
<cfset lcl.form.addformitem('title', 'Title', false, 'text', lcl.info.getTitle(), lcl.options)>

<cfset lcl.options = structnew()>
<cfset lcl.options.style = "width:600px;height:300px;">
<cfset lcl.form.addformitem('Content', 'Content', false, 'textarea', lcl.info.getContent(), lcl.options)>

<cfset lcl.form.addformitem('id', '', false, 'hidden', lcl.info.getid())>

<!--- this is for block admin.  --->
<cfif requestObj.getFormUrlVar("view", "default") EQ "block">
	<cfset lcl.form.addformitem('view', '', false, 'hidden', "block")>
</cfif>

<cfset lcl.form.endform()>
<cfoutput>#lcl.form.showHTML()#</cfoutput>
<input type="button" onclick="self.close()" value="Cancel">
<input type="submit" value="Save">


<script>
	window.resizeTo(870, 602);
</script>