<cfinclude template="nav.cfm">
<form action="../cgNewModuleAction">
<fieldset>
	<legend>Module Information</legend>
	<p><label for="modulename">Module Folder Name </label><input type="text" name="modulename"></p>
	<!--- <p><label for="mactions">Module Actions </label><input type="text" name="mactions" style="width:400px;"></p>
</fieldset>
<fieldset>
	<legend>Create Models</legend>
	<p>
		<label for="models">Via Database Table</label>
		<select name="models" size="5" multiple="multiple">
			<cfoutput query="variables.tables">
				<option value="#table_name#">#table_name#</option>
			</cfoutput>
		</select>
	</p> --->
</fieldset>
<input type="submit" value="Go">
</form>