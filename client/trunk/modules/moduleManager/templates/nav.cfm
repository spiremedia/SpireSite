<style>
	body {
		font-size:12px;
		font-family:arial;	
	}
	label {
		width:140px;
		float:left;
		text-align:right;
		padding-right:10px;
	}
	fieldset p {
		margin:3px;
		clear:both;
	}
	.msg {
		font-weight:bold;
		color:red;
	}
</style>
<div class="nav">
	<a href="/system/modules/">Add Module</a>
	<a href="/system/modules/installables/">Download Module</a>
	<a href="/system/modules/siteTemplates/">Alter Site Template</a>
	Choose a module to Edit
	<form style="display:inline;">
		<select onchange="if (this.value !=  '') location.href='/system/modules/MgModule/?n=' + this.value">
		<option value="">Choose</option>
		<cfset lcl.modules = modules.getAll()>
		<cfif requestObject.isFormUrlVarSet("n")>
			<cfset lcl.activeModule = requestObject.getFormUrlVar("n")>
		<cfelse>
			<cfset lcl.activeModule = "">
		</cfif>
		<cfoutput query="lcl.modules">
			<option <cfif name EQ lcl.activeModule>selected</cfif> value="#name#">#name#</option>		
		</cfoutput>
		</select>
	</form>
</div>
<div class="msg"><cfoutput>#session.user.getFlash()#</cfoutput></div>