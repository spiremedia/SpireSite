<cfinclude template="nav.cfm">
<script>
	function settype(v){
		$(".database").hide();
		$(".other").hide();
		$("." + v).show();
	}
</script>
<form action="../modelform2" method="post">
	<input type="hidden" name="n" value="<cfoutput>#requestObject.getFormUrlVar("n")#</cfoutput>">
	<fieldset>
		<legend>Create New Model</legend>
		<input type="radio" name="type" value="database" checked onclick="settype(this.value)">Database Table
		<input type="radio" name="type" value="other" onclick="settype(this.value)">Other
	</fieldset>
	<fieldset class="database">
		<legend>For Database Table</legend>
			<select name="datamodelname">
				<cfoutput query="variables.tables">
					<option value="#table_name#">#table_name#</option>
				</cfoutput>
			</select>
	</fieldset>
	<fieldset class="other" style="display:none;">
		<legend>Other (Non database)</legend>
			<p><label for="othermodelname">Model Name</label><input type="text" name="othermodelname"></p>
	</fieldset>
	<fieldset class="more">
		<legend>Methods</legend>
			<p><label for="methodslist">Comma delimited list of methods</label><input type="text" name="methodslist" style="width:400px"></p>
	</fieldset>
	
	<input type="submit" value="Go">
</form>