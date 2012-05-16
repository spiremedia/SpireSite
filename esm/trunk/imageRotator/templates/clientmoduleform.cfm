<cfset lcl.editModel = getDataItem('editablemodel')>

<cfset lcl.form = createWidget("formcreator")>

<cfset lcl.form.startform()>
<cfset lcl.form.addformitem('id', '', false, 'hidden', lcl.editModel.getid())>
<cfset lcl.form.endform()>
<cfoutput>#lcl.form.showHTML()#</cfoutput>
The content area has been saved as the image rotator module.<br><br>
<input type="button"  value="Close" onClick="reloadbase()">

<script>
	window.resizeTo(900, 280);
</script>
