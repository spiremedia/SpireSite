<cfset lcl.page = getDataItem('page')>
<cfset lcl.userobj = getDataItem('userobj')>


<cfoutput>
<cfset lcl.id = lcl.page.getPageId()>

<cfif (NOT requestObj.isFormUrlVarSet('id') AND securityObj.isallowed("pages","add Page")) 
	OR (requestObj.isFormUrlVarSet('id') AND securityOBj.isallowed("pages","Edit Page"))>
<!--- <cfif lcl.userobj.isallowed("pages","add Page") OR lcl.userobj.isallowed("pages","Edit Page")> --->
	<input type="submit" value="Save" style="width:35px;">
</cfif>

<cfif lcl.userobj.isallowed("pages","Reviewable Pages") AND isdataitemset('id') AND getdataitem('id') NEQ 0>
	<input type="button" value="Request Review" style="width:100px;" onclick="location.href='../startReview/?id=#lcl.id#';">
</cfif>

<cfif isDataItemSet('isreviseable')>
	<cfset lcl.reviseable = getDataItem('isreviseable')>
	<cfif lcl.reviseable>
		<input type="button" value="Send Feedback" onclick="location.href='../startRevise/?id=#lcl.id#';" style="width:95px;">
	</cfif>
</cfif>
<cfif lcl.userobj.isallowed("pages","publish page") AND isdataitemset('id') AND getdataitem('id') NEQ 0>
	<input type="button" value="Publish" onClick="sendPublish()" style="width:47px;">
</cfif>

<cfif lcl.userobj.isallowed("pages","Edit Page") AND isdataitemset('id') AND getdataitem('id') NEQ 0>
	<input type="button" value="Up" onClick="ajaxWResponseJsCaller('/pages/moveUpDown/', 'id=#getdataitem('id')#&dir=Up' );"  style="width:22px;">
	<input type="button" value="Down" onClick="ajaxWResponseJsCaller('/pages/moveUpDown/', 'id=#getdataitem('id')#&dir=Down' );" style="width:40px;">
</cfif>

<cfif lcl.userobj.isallowed("pages","delete page") AND isdataitemset('id') AND getdataitem('id') NEQ 0>
	<input type="button" value="Delete" onClick="verify('Are you sure you wish to delete this Page?','/Pages/DeletePage/?id=#lcl.id#')" style="width:42px;">
</cfif>

<input type='hidden' name='id' id='id' value="#lcl.id#">




<script>
	function sendPublish(id){
		var myForm = $("##myForm").serialize();
		myForm += '&publish=true'
		trace( myForm );
		ajaxWResponseJsCaller('/pages/savePage/', myForm );
	}

	function update(){
		var t = new Object();
		t.ID = 'leftContent';
		t.URL = '/Pages/Browse/?id=#lcl.page.getPageId()#';
		ajaxupdater(t)
	}
	
	//overriding function locally
	function submitAjaxForm(){
		//setting pageurl to be pagename by default if blank. removes all chars except a-z0-9\-
		if (document.getElementById('pageurl').value == ''){
			document.getElementById('pageurl').value = document.getElementById('pagename').value.replace(/[\-][\-]+/g, '-').replace(/[^a-z0-9\-]+/gi, '-').substr(0,50);
		}
		if (typeof(tinyMCE) == 'object') tinyMCE.triggerSave();
		var myForm = $("##myForm").serialize();
		trace( myForm );
		ajaxWResponseJsCaller('/Pages/savepage/',myForm);
		return false;
	}
</script>
</cfoutput>