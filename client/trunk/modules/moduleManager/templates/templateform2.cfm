<cfinclude template="nav.cfm">
<cfoutput>
<form action="../templateaction" method="post">
	<input type="hidden" name="n" value="#requestObject.getFormUrlVar("n")#">
	<input type="hidden" name="templatename" value="#variables.templatename#">

	<fieldset>
		<legend>Model "#variables.templatename#" Text</legend>
			<p>
				<textarea name="templatetext" style="width:650px;height:500px">#variables.templatetext#</textarea>
			</p>
	</fieldset>
	
	<input type="submit" value="Create">
</form>
</cfoutput>