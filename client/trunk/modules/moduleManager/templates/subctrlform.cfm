<cfinclude template="nav.cfm">
<script>
	function settype(v){
		$(".fieldlist").hide();
		$(".dblist").hide();
		$(".formlist").hide();
		$(".dbform").hide();
		$(".other").hide();
		$("." + v).show();
	}
	$(function(){settype("fieldlist");})
</script>
<form action="../subctrlform2/" method="post">
	<input type="hidden" name="n" value="<cfoutput>#requestObject.getFormUrlVar("n")#</cfoutput>">
	<fieldset>
		<legend>New SubController</legend>
		<p><label for="subctrlname">SubController Name</label><input type="text" name="subctrlname"></p>
		<p><label for="subctrlinfo"></label><input type="radio" name="subctrllayout" value="showhtml" checked>Use showHTML?<input type="radio" name="subctrllayout" value="template">Use Template?</p>
		<p><label for="cacheable"></label><input type="checkbox" name="cacheable" value="1">Cacheable?</p>
		<p>
			Type
			<br style="clear:both">
			<input type="radio" onclick="settype(this.value)" name="ctrltype" checked value="fieldlist">List (give fieldlist)<br>
			<input type="radio" onclick="settype(this.value)" name="ctrltype" value="dblist">List (give database table)<br>
			<input type="radio" onclick="settype(this.value)" name="ctrltype" value="formlist">Form (give form list)<br>
			<input type="radio" onclick="settype(this.value)" name="ctrltype" value="dbform">Form (give database table)<br>
			<input type="radio" onclick="settype(this.value)" name="ctrltype" value="other">Other(blank)
		</p>
	</fieldset>
	<fieldset class="fieldlist">
		<legend>List by Fields</legend>
		<p><label>Field List</label><input type="text" name="fieldlist" style="width:300px;"></p>
		<p><label>Field List Type</label><input type="radio" checked name="fieldlisttype" value="divs"> Divs <input type="radio"  name="fieldlisttype" value="table"> Table</p>
		
	</fieldset>
	<fieldset class="dblist">
		<legend>List populated by database Table</legend>
		<p>
			<label>Table to take fields from</label>
			<select name="dblist">
				<cfoutput query="variables.tables">
					<option value="#table_name#">#table_name#</option>
				</cfoutput>
			</select>
		</p>
		<p><label>Table List Type</label><input type="radio" checked name="dblisttype" value="divs"> Divs <input type="radio"  name="dblisttype" value="table"> Table</p>
	</fieldset>
	<fieldset class="formlist">
		<legend>Form by fields</legend>
		<p>
			<label>Fields List</label><input type="text" name="formlist" style="width:300px;">
		</p>
	</fieldset>
	<fieldset class="dbform">
		<legend>Form by database table</legend>
		<p>
			<label>Table to take fields from</label>
			<select name="dbform">
				<cfoutput query="variables.tables">
					<option value="#table_name#">#table_name#</option>
				</cfoutput>
			</select>
		</p>
	</fieldset>
	
	<fieldset class="other">
		<legend>Other</legend>
			Too easy.
	</fieldset>
	
	<input type="submit" value="Go">
</form>