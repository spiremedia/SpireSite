<cfset lcl.tbl = getDataItem("tables")>

<p>Choose a table to estract the json meta data structure.</p>
<p>Table :
	<select id="table" name="table">
		<option>Choose</option>
		<cfoutput query="lcl.tbl">
			<option>#lcl.tbl.table_name#</option>
		</cfoutput>
	</select>
</p>
<p>
	<form>
		<textarea id="tableinfo" name="tableinfo" style="width:500px;height:300px;">

		</textarea>
	</form>
</p>
<script>
	$(function(){
		$("#table").change(function(){
			$("#tableinfo").load("../gettableinfo/", {"tablename":$(this).attr("value")})

		});
	});
</script>