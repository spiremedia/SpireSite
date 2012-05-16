<cfset lcl.model = getDataItem("model")>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>Asset Upload</title>
	<style type="text/css" media="all">
		@import "/ui/css/c.css";
		@import "/ui/css/n.css";
		@import "/ui/css/f.css";
		@import "/ui/css/datepickercontrol.css";
	</style>

	<style>
		#msg {
			color:red;font-weight:bold;
		}
		#msg ul {
			margin-top:0;
			padding-top:0;
			margin-bottom:0;
			padding-bottom:0;
		}
		#submitIframe {
			display:none;
		}
		body,
		label,
		input {font-size:10px;}
	</style>
	<script>
		function showErrors(error){
			document.getElementById("msg").innerHTML = "There was a problem." + error;
		}
	</script>
</head>
<body>
	<cfoutput>
<form  enctype="multipart/form-data"  method='post' target="submitIframe" name="uploadForm" action="/assets/listedassetuploadaction/">
	<input type="hidden" name="id" value="#lcl.model.getId()#">
	<input type="hidden" name="groupname" value="#requestObj.getFormUrlVar("groupname")#">
	<h2>Listed Asset Upload</h2>
	<!---<h3>#requestObj.getFormUrlVar("GroupName")#</h3>--->
	<div id="msg">&nbsp;</div>
	<table class='formtable'>
	<tr>
	<td>
	<img class="errorimages" id="valimg_name" src='/ui/css/images/pending.gif'>
	<img src='/ui/css/images/label.required-bkgd.gif'>
	</td>
	<td class='label'>
	<label for='name'>
	Name
	</label>
	</td>
	<td>
	<input type='text' name='name' id='name' value="#lcl.model.getName()#" style="width:220px"  >
	</td>
	</tr>

	<tr>
	<td>
	<img class="errorimages" id="valimg_filename" src='/ui/css/images/pending.gif'>
	<img src='/ui/css/images/label.required-bkgd.gif'>
	</td>
	<td class='label'>
	<label for='filename'>
	File
	</label>
	</td>
	<td>
	<input type='file' name='filename' id='filename' value=""    >
	</td>
	</tr>
	</table>
	</cfoutput>
<input type="submit" value="Save">

</form>
<iframe id="submitIframe" name="submitIframe" width="500" height="100"></iframe>
</body>
</html>
