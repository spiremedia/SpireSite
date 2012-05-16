<cfinclude template="nav.cfm">
<cfoutput>
<form action="../testaction" method="post">
	<input type="hidden" name="n" value="#requestObject.getFormUrlVar("n")#">
	<input type="hidden" name="testfilename" value="#testfilename#">

	
	<fieldset>
		<legend>Test File "#variables.testfilename#" Text</legend>
			<p>
				<textarea name="testfiletext" style="width:650px;height:500px">#testfiletext#</textarea>
			</p>
	</fieldset>
	
	<input type="submit" value="Create">
</form>
</cfoutput>