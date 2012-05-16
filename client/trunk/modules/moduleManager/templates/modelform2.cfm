<cfinclude template="nav.cfm">
<cfoutput>
<form action="modelaction" method="post">
	<input type="hidden" name="n" value="#requestObject.getFormUrlVar("n")#">
	<input type="hidden" name="modelname" value="#modelname#">

	
	<fieldset>
		<legend>Model "#variables.modelname#" Text</legend>
		
			<p>
				<textarea name="modeltext" style="width:650px;height:500px">#modeltext#</textarea>
			</p>
	</fieldset>
	
	<input type="submit" value="Create">
</form>
</cfoutput>