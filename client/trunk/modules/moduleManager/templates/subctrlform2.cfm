<cfinclude template="nav.cfm">
<cfoutput>
<form action="../subctrlaction" method="post">
	<input type="hidden" name="n" value="#requestObject.getFormUrlVar("n")#">
	<input type="hidden" name="subctrlname" value="#variables.subctrlname#">

	<fieldset>
		<legend>Subcontroller "#variables.subctrlname#" Text</legend>
			<p>
				<textarea name="subctrltext" style="width:650px;height:300px">#variables.subctrltext#</textarea>
			</p>
	</fieldset>
	<cfif structkeyexists(variables, "templatetext")>
	<fieldset>
		<legend>Template "#variables.subctrlname#" Text</legend>
			<p>
				<textarea name="templatetext" style="width:650px;height:300px">#variables.templatetext#</textarea>
			</p>
	</fieldset>
	</cfif>
	
	<input type="submit" value="Create">
</form>
</cfoutput>