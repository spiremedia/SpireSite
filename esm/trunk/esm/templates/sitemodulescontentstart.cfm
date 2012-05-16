<div id="msg"></div>
<form name="myform">
<cfset lcl.tables = getDataItem("tables")>
<p>Create a new Module? </p>
<p>The name of the module : <input type="text" id="newmodule" name="newmodule" maxlength="25"></p>
<p>The type of relationship : <select id="type" name="type">
	<option value="skeleton">Skeleton</option>
	<option value="simple">Simple (One table)</option>
	<option value="belongsto">Belongs To (2 table)</option>
	<option value="habtm">HABTM (2 tables + link)</option>
</select>
</p>
<p id="simpletables" style="display:none">
	Choose the table you wish to manage : <select name="simpletablename" id="simpletablename">
		<cfoutput query="lcl.tables">
			<option value="#table_name#">#table_name#</option>
		</cfoutput>
	</select>
</p>
<button id="newmodulebtn" type="button">Go</button>

</form>
<script>
	$(function(){
		
		$("#type").change(function(){
			var type = $("#type").attr("value");
			$("#simpletables").css("display","none");
			
			if (type== "simple") $("#simpletables").css("display","block");
			else if (type == "belongsto" || type == "habtm") alert("belongs to and habtm not yet working.")
		});
		$("#newmodulebtn").click(function(){
			var type = $("#type").attr("value");
			var name = $('#newmodule').attr('value');
		
			if (type == "skeleton"){
				ajaxWResponseJsCaller('/ESM/saveSkeletonModule/', "name=" + $('#newmodule').attr('value') );
			} else if (type == "simple"){
				var table = $('#simpletablename').attr('value');
				ajaxWResponseJsCaller('/ESM/saveSimpleModule/', "table=" + table + "&name=" + $('#newmodule').attr('value') );
			} else if (type == "belongsto" || type == "habtm") {
				alert("belongs to and habtm not yet working.")
			}
		})
	});
</script>